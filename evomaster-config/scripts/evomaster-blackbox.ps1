param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('product', 'media', 'customer', 'cart', 'rating', 'order', 'payment', 'location', 'inventory', 'tax', 'promotion', 'search', 'sampledata')]
    [string]$ServiceName,

    [ValidateSet('admin', 'customer', 'none')]
    [string]$Role = 'none',

    [ValidateSet('single', 'multi')]
    [string]$AuthProfiles = 'single',

    [string]$RunLabel = '',

    [int]$MaxTimeSec = 60,

    [int]$RatePerMinute = 60,

    [string]$Seed = '',

    [string]$YasApiUrl = '',

    [string]$KeycloakUrl = ''
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir 'auth-config.ps1')

$defaults = Get-YasAuthDefaults
if (-not $YasApiUrl) { $YasApiUrl = $defaults.YasApiUrl }
if (-not $KeycloakUrl) { $KeycloakUrl = $defaults.KeycloakUrl }

$configDir = (Resolve-Path (Join-Path $scriptDir '..')).Path
$outputBaseDir = Join-Path $configDir 'generated-tests\blackbox'
$tempConfigBaseDir = Join-Path $configDir 'tmp-em-config'

$servicePaths = @{
    product    = 'product'
    media      = 'media'
    customer   = 'customer'
    cart       = 'cart'
    rating     = 'rating'
    order      = 'order'
    payment    = 'payment'
    location   = 'location'
    inventory  = 'inventory'
    tax        = 'tax'
    promotion  = 'promotion'
    search     = 'search'
    sampledata = 'sampledata'
}

function Assert-DockerEngine {
    try {
        & docker version | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw 'Docker nao respondeu.'
        }
    }
    catch {
        throw "Docker Desktop/daemon nao esta respondendo corretamente. Reinicie o Docker Desktop e valide com 'docker version' e 'docker ps'."
    }
}

function Get-HttpStatusCode {
    param([string]$Url)

    try {
        $response = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec 30
        return [int]$response.StatusCode
    }
    catch {
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            return [int]$_.Exception.Response.StatusCode.value__
        }
        return 0
    }
}

function Save-RunInfo {
    param(
        [string]$Path,
        [hashtable]$Data
    )

    $Data | ConvertTo-Json -Depth 6 | Set-Content -Path $Path
}

function New-EvoMasterMultiAuthConfig {
    param(
        [string]$ConfigFile,
        [string]$SwaggerUrl,
        [int]$MaxTimeSec,
        [int]$RatePerMinute,
        [string]$AdminToken,
        [string]$CustomerToken,
        [string]$OutputFilePrefix
    )

    $safeAdminToken = $AdminToken.Replace("'", "''")
    $safeCustomerToken = $CustomerToken.Replace("'", "''")

    $configContent = @"
configs:
  bbSwaggerUrl: '$SwaggerUrl'
  blackBox: true
  maxTime: '${MaxTimeSec}s'
  ratePerMinute: $RatePerMinute
  outputFormat: 'JAVA_JUNIT_5'
  outputFolder: '/output'
  outputFilePrefix: '$OutputFilePrefix'

auth:
  - name: 'admin'
    fixedHeaders:
      - name: 'Authorization'
        value: 'Bearer $safeAdminToken'
  - name: 'customer'
    fixedHeaders:
      - name: 'Authorization'
        value: 'Bearer $safeCustomerToken'
"@

    Set-Content -Path $ConfigFile -Value $configContent
}

Assert-DockerEngine

$roleFolder = if ($RunLabel) { "${Role}_$RunLabel" } else { $Role }
$outputDir = Join-Path $outputBaseDir "$ServiceName\$roleFolder"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$logFile = Join-Path $outputDir 'evomaster.log'
$runInfoFile = Join-Path $outputDir 'run-info.json'
$runTimestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$contextPath = $servicePaths[$ServiceName]
$swaggerUrl = "$YasApiUrl/$contextPath/v3/api-docs"

Write-Host ''
Write-Host '=== EvoMaster Black-Box (PowerShell) - YAS ===' -ForegroundColor Cyan
Write-Host "Servico: $ServiceName"
Write-Host "Role: $Role"
Write-Host "Perfis auth: $AuthProfiles"
if ($RunLabel) { Write-Host "RunLabel: $RunLabel" }
Write-Host "Tempo maximo: ${MaxTimeSec}s"
Write-Host "Taxa: $RatePerMinute req/min"
Write-Host "API URL: $YasApiUrl"
Write-Host "Keycloak URL: $KeycloakUrl"

$swaggerStatus = Get-HttpStatusCode -Url $swaggerUrl
if ($swaggerStatus -ne 200) {
    throw "OpenAPI spec indisponivel em $swaggerUrl (HTTP $swaggerStatus). Verifique se o host do Windows resolve 'api.yas.local' e se o nginx e o servico '$ServiceName' estao no ar."
}

$authHeader = ''
$configFile = ''
$tempConfigDir = ''
$authenticated = $false

if ($AuthProfiles -eq 'multi') {
    Write-Host 'Garantindo existencia do usuario customer...' -ForegroundColor Yellow
    Ensure-YasCustomerUserExists -KeycloakUrl $KeycloakUrl -Realm $defaults.KeycloakRealm -AdminUsername $defaults.KeycloakAdminUsername -AdminPassword $defaults.KeycloakAdminPassword -CustomerUsername $defaults.CustomerUsername -CustomerPassword $defaults.CustomerPassword

    Write-Host 'Obtendo token admin...' -ForegroundColor Yellow
    $adminToken = Get-YasOAuthToken -KeycloakUrl $KeycloakUrl -Realm $defaults.KeycloakRealm -ClientId $defaults.KeycloakClientId -ClientSecret $defaults.KeycloakClientSecret -Username $defaults.AdminUsername -Password $defaults.AdminPassword
    if (-not $adminToken) {
        throw "Falha ao obter token admin em $KeycloakUrl. Verifique o host 'identity' no arquivo hosts e o container identity."
    }

    Write-Host 'Obtendo token customer...' -ForegroundColor Yellow
    $customerToken = Get-YasOAuthToken -KeycloakUrl $KeycloakUrl -Realm $defaults.KeycloakRealm -ClientId $defaults.KeycloakClientId -ClientSecret $defaults.KeycloakClientSecret -Username $defaults.CustomerUsername -Password $defaults.CustomerPassword
    if (-not $customerToken) {
        throw "Falha ao obter token customer em $KeycloakUrl. Verifique o host 'identity' no arquivo hosts e o container identity."
    }

    $tempConfigDir = Join-Path $tempConfigBaseDir "$ServiceName\$roleFolder"
    New-Item -ItemType Directory -Force -Path $tempConfigDir | Out-Null
    $configFile = Join-Path $tempConfigDir 'em.yaml'
    $outputFilePrefix = "EvoMaster_${ServiceName}_${Role}"
    New-EvoMasterMultiAuthConfig -ConfigFile $configFile -SwaggerUrl $swaggerUrl -MaxTimeSec $MaxTimeSec -RatePerMinute $RatePerMinute -AdminToken $adminToken -CustomerToken $customerToken -OutputFilePrefix $outputFilePrefix
    $authenticated = $true
    Write-Host 'Usando autenticacao multiusuario (admin + customer + anonimo implicito)...' -ForegroundColor Yellow
}
elseif ($Role -eq 'admin') {
    Write-Host 'Obtendo token admin...' -ForegroundColor Yellow
    $token = Get-YasOAuthToken -KeycloakUrl $KeycloakUrl -Realm $defaults.KeycloakRealm -ClientId $defaults.KeycloakClientId -ClientSecret $defaults.KeycloakClientSecret -Username $defaults.AdminUsername -Password $defaults.AdminPassword
    if (-not $token) {
        throw "Falha ao obter token admin em $KeycloakUrl. Verifique o host 'identity' no arquivo hosts e o container identity."
    }
    $authHeader = "Authorization:Bearer $token"
    $authenticated = $true
}
elseif ($Role -eq 'customer') {
    Write-Host 'Garantindo existencia do usuario customer...' -ForegroundColor Yellow
    Ensure-YasCustomerUserExists -KeycloakUrl $KeycloakUrl -Realm $defaults.KeycloakRealm -AdminUsername $defaults.KeycloakAdminUsername -AdminPassword $defaults.KeycloakAdminPassword -CustomerUsername $defaults.CustomerUsername -CustomerPassword $defaults.CustomerPassword

    Write-Host 'Obtendo token customer...' -ForegroundColor Yellow
    $token = Get-YasOAuthToken -KeycloakUrl $KeycloakUrl -Realm $defaults.KeycloakRealm -ClientId $defaults.KeycloakClientId -ClientSecret $defaults.KeycloakClientSecret -Username $defaults.CustomerUsername -Password $defaults.CustomerPassword
    if (-not $token) {
        throw "Falha ao obter token customer em $KeycloakUrl. Verifique o host 'identity' no arquivo hosts e o container identity."
    }
    $authHeader = "Authorization:Bearer $token"
    $authenticated = $true
}
else {
    Write-Host 'Executando sem autenticacao.' -ForegroundColor Yellow
}

$runInfo = @{
    service = $ServiceName
    role = $Role
    auth_profiles = $AuthProfiles
    run_label = $RunLabel
    timestamp = $runTimestamp
    max_time_seconds = $MaxTimeSec
    rate_per_minute = $RatePerMinute
    seed = $(if ($Seed) { $Seed } else { 'random' })
    swagger_url = $swaggerUrl
    api_url = $YasApiUrl
    keycloak_url = $KeycloakUrl
    authenticated = $authenticated
    evomaster_image = 'webfuzzing/evomaster'
}
Save-RunInfo -Path $runInfoFile -Data $runInfo

$dockerArgs = @(
    'run', '--rm',
    '-v', "${outputDir}:/output",
    '--add-host=identity:host-gateway',
    '--add-host=api.yas.local:host-gateway'
)

if ($configFile) {
    $dockerArgs += @('-v', "${tempConfigDir}:/config")
}

$dockerArgs += @(
    'webfuzzing/evomaster'
)

if ($configFile) {
    $dockerArgs += @('--configPath', '/config/em.yaml')
}
else {
    $testSuiteName = "EvoMaster_${ServiceName}_${Role}"
    $dockerArgs += @(
        '--blackBox', 'true',
        '--bbSwaggerUrl', $swaggerUrl,
        '--maxTime', "${MaxTimeSec}s",
        '--ratePerMinute', "$RatePerMinute",
        '--outputFormat', 'JAVA_JUNIT_5',
        '--outputFolder', '/output',
        '--testSuiteFileName', $testSuiteName,
        '--writeStatistics', 'true',
        '--statisticsFile', '/output/statistics.csv',
        '--snapshotInterval', '1'
    )
}

if ($Seed) {
    $dockerArgs += @('--seed', $Seed)
}

if ($authHeader) {
    $dockerArgs += @('--header0', $authHeader)
}

Write-Host ''
Write-Host 'Executando EvoMaster...' -ForegroundColor Green
Write-Host "Swagger URL: $swaggerUrl"
Write-Host "Saida: $outputDir"
Write-Host "Log: $logFile"
Write-Host ''

& docker @dockerArgs 2>&1 | Tee-Object -FilePath $logFile
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0 -and (Test-Path $logFile)) {
    $rawLog = Get-Content $logFile -Raw
    if ($rawLog -match '^\* \[ERROR\]' -or $rawLog -match '\[ERROR\]') {
        $exitCode = 1
    }
}

$results = @{}
if (Test-Path $logFile) {
    $logContent = Get-Content $logFile -Raw
    $covered = [regex]::Match($logContent, 'Covered targets: ([0-9]+)').Groups[1].Value
    $saved = [regex]::Match($logContent, 'Going to save ([0-9]+) tests to').Groups[1].Value
    $success2xx = [regex]::Match($logContent, 'Successfully executed \(HTTP code 2xx\) ([0-9]+ endpoints out of [0-9]+)').Groups[1].Value

    if ($covered -or $saved -or $success2xx) {
        $results = @{
            covered_targets = $covered
            endpoints_2xx = $success2xx
            tests_generated = $saved
            exit_code = $exitCode
        }
    }
}

if ($results.Count -gt 0) {
    $runInfo.results = $results
    Save-RunInfo -Path $runInfoFile -Data $runInfo
}

if ($exitCode -ne 0) {
    throw "EvoMaster falhou com codigo $exitCode"
}

Write-Host ''
Write-Host "Testes gerados com sucesso em: $outputDir" -ForegroundColor Green
