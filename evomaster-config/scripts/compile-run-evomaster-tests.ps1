# NOT FINISHED YET, JUST A START IDEA FOR NOW

param(
    [string]$RootDir = "",
    [string]$OutputCsv = "",
    [string]$TempRoot = "",
    [string]$LogRoot = "",
    [int]$TimeoutSec = 300,
    [string]$MavenCommand = "mvn",
    [string]$JavaRelease = "21",
    [string]$EvoMasterDependencyVersion = "5.0.2"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RootDir) {
    $RootDir = (Resolve-Path (Join-Path $scriptDir "..\generated-tests\blackbox")).Path
}
if (-not $TempRoot) {
    $TempRoot = Join-Path (Resolve-Path (Join-Path $scriptDir "..")).Path "tmp-test-runner"
}
if (-not $LogRoot) {
    $LogRoot = Join-Path (Resolve-Path (Join-Path $scriptDir "..")).Path "runtime-logs"
}
if (-not $OutputCsv) {
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $OutputCsv = Join-Path $RootDir "evomaster_compile_run_$stamp.csv"
}

function Get-FileType {
    param([string]$FileName)

    if ($FileName -match "faults") { return "faults" }
    if ($FileName -match "successes") { return "successes" }
    if ($FileName -match "others") { return "others" }
    return "unknown"
}

function Get-ClassName {
    param([string]$Content)

    $match = [regex]::Match($Content, '(?m)^\s*public\s+class\s+([A-Za-z0-9_]+)')
    if ($match.Success) { return $match.Groups[1].Value }
    return ""
}

function Get-MethodBlocks {
    param([string]$Content)

    $pattern = '(?ms)(?<comment>/\*\*.*?\*/)?\s*(?<annotations>(?:@\w+(?:\([^)]*\))?\s*)+)public\s+void\s+(?<method>[A-Za-z0-9_]+)\s*\(\)\s*throws\s+Exception\s*\{(?<body>.*?)^\s*\}'
    return [regex]::Matches($Content, $pattern)
}

function Get-EndpointInfo {
    param(
        [string]$Comment,
        [string]$Body
    )

    $verb = ""
    $endpoint = ""

    if ($Comment) {
        $callMatch = [regex]::Match($Comment, '\(\d+\)\s+([A-Z]+):([^\r\n\s*]+)')
        if ($callMatch.Success) {
            $verb = $callMatch.Groups[1].Value
            $endpoint = $callMatch.Groups[2].Value
        }
    }

    if (-not $verb -or -not $endpoint) {
        $requestMatch = [regex]::Match(
            $Body,
            '\.(get|post|put|patch|delete)\(\s*baseUrlOfSut\s*\+\s*"([^"]+)"',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )
        if ($requestMatch.Success) {
            $verb = $requestMatch.Groups[1].Value.ToUpperInvariant()
            $endpoint = $requestMatch.Groups[2].Value
        }
    }

    [pscustomobject]@{
        Verb = $verb
        Endpoint = $endpoint
    }
}

function New-RunnerPom {
    param(
        [string]$Path,
        [string]$JavaRelease,
        [string]$EvoMasterDependencyVersion
    )

    $pom = @"
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.yas.evomaster</groupId>
  <artifactId>generated-test-runner</artifactId>
  <version>1.0-SNAPSHOT</version>

  <properties>
    <maven.compiler.release>$JavaRelease</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <junit.jupiter.version>5.12.2</junit.jupiter.version>
    <rest.assured.version>5.5.1</rest.assured.version>
    <evomaster.version>$EvoMasterDependencyVersion</evomaster.version>
    <maven.surefire.version>3.5.2</maven.surefire.version>
  </properties>

  <dependencies>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter-api</artifactId>
      <version>\${junit.jupiter.version}</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter-engine</artifactId>
      <version>\${junit.jupiter.version}</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>io.rest-assured</groupId>
      <artifactId>rest-assured</artifactId>
      <version>\${rest.assured.version}</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.hamcrest</groupId>
      <artifactId>hamcrest</artifactId>
      <version>3.0</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.evomaster</groupId>
      <artifactId>evomaster-client-java-controller-api</artifactId>
      <version>\${evomaster.version}</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.evomaster</groupId>
      <artifactId>evomaster-client-java-controller</artifactId>
      <version>\${evomaster.version}</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.evomaster</groupId>
      <artifactId>evomaster-test-utils-java</artifactId>
      <version>\${evomaster.version}</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>\${maven.surefire.version}</version>
        <configuration>
          <useModulePath>false</useModulePath>
          <failIfNoTests>false</failIfNoTests>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
"@

    Set-Content -Path $Path -Value $pom -Encoding UTF8
}

function Get-MavenExecutable {
    param([string]$MavenCommand)

    $cmd = Get-Command $MavenCommand -ErrorAction SilentlyContinue
    if (-not $cmd) {
        throw "Nao foi possivel localizar o comando Maven '$MavenCommand'."
    }
    return $cmd.Source
}

function Stop-ProcessTree {
    param([int]$Pid)

    try {
        Start-Process -FilePath "taskkill.exe" -ArgumentList "/PID $Pid /T /F" -WindowStyle Hidden -Wait | Out-Null
    }
    catch {
        try {
            Stop-Process -Id $Pid -Force -ErrorAction SilentlyContinue
        }
        catch {
        }
    }
}

function Get-ErrorSummary {
    param([string]$CombinedLog)

    $patterns = @(
        '(?m)^\[ERROR\].+$',
        '(?m)^.*COMPILATION ERROR.*$',
        '(?m)^.*Failures:.*$',
        '(?m)^.*Errors:.*$',
        '(?m)^.*Exception.*$'
    )

    foreach ($pattern in $patterns) {
        $match = [regex]::Match($CombinedLog, $pattern)
        if ($match.Success) {
            return $match.Value.Trim()
        }
    }

    return ""
}

if (-not (Test-Path $RootDir)) {
    throw "Diretorio nao encontrado: $RootDir"
}

New-Item -ItemType Directory -Force -Path $TempRoot | Out-Null
New-Item -ItemType Directory -Force -Path $LogRoot | Out-Null
$mavenExe = Get-MavenExecutable -MavenCommand $MavenCommand

$results = New-Object System.Collections.Generic.List[object]
$javaFiles = Get-ChildItem -Path $RootDir -Recurse -Filter "*.java" -File | Sort-Object FullName

foreach ($file in $javaFiles) {
    $content = Get-Content $file.FullName -Raw
    $className = Get-ClassName -Content $content
    $fileType = Get-FileType -FileName $file.Name
    $methodBlocks = Get-MethodBlocks -Content $content

    $relativePath = $file.FullName.Substring($RootDir.Length).TrimStart('\')
    $segments = $relativePath -split '[\\/]'
    $service = if ($segments.Length -ge 1) { $segments[0] } else { "" }
    $profile = if ($segments.Length -ge 2) { $segments[1] } else { "" }

    $hash = (Get-FileHash -Algorithm SHA256 -Path $file.FullName).Hash.Substring(0, 12).ToLowerInvariant()
    $workDir = Join-Path $TempRoot "$service\$profile\$hash"
    $testSourceDir = Join-Path $workDir "src\test\java"
    $surefireDir = Join-Path $workDir "target\surefire-reports"
    $logDir = Join-Path $LogRoot "$service\$profile"
    $stdoutPath = Join-Path $logDir "$($file.BaseName)_stdout.log"
    $stderrPath = Join-Path $logDir "$($file.BaseName)_stderr.log"

    Remove-Item -Recurse -Force $workDir -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $testSourceDir | Out-Null
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null

    Copy-Item -Path $file.FullName -Destination (Join-Path $testSourceDir $file.Name) -Force
    New-RunnerPom -Path (Join-Path $workDir "pom.xml") -JavaRelease $JavaRelease -EvoMasterDependencyVersion $EvoMasterDependencyVersion

    $args = @(
        "-q",
        "-Dtest=$className",
        "test"
    )

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $peakWorkingSetMb = 0.0
    $cpuSeconds = 0.0
    $timedOut = $false
    $process = Start-Process -FilePath $mavenExe `
        -ArgumentList $args `
        -WorkingDirectory $workDir `
        -NoNewWindow `
        -PassThru `
        -RedirectStandardOutput $stdoutPath `
        -RedirectStandardError $stderrPath

    while (-not $process.HasExited) {
        Start-Sleep -Milliseconds 500
        try {
            $current = Get-Process -Id $process.Id -ErrorAction Stop
            $peakWorkingSetMb = [math]::Max($peakWorkingSetMb, [math]::Round($current.WorkingSet64 / 1MB, 2))
            $cpuSeconds = [math]::Max($cpuSeconds, [math]::Round($current.TotalProcessorTime.TotalSeconds, 2))
        }
        catch {
        }

        if ($stopwatch.Elapsed.TotalSeconds -ge $TimeoutSec) {
            $timedOut = $true
            Stop-ProcessTree -Pid $process.Id
            break
        }
    }

    if (-not $process.HasExited) {
        $process.WaitForExit()
    }
    $stopwatch.Stop()

    $stdout = if (Test-Path $stdoutPath) { Get-Content $stdoutPath -Raw } else { "" }
    $stderr = if (Test-Path $stderrPath) { Get-Content $stderrPath -Raw } else { "" }
    $combinedLog = ($stdout + [Environment]::NewLine + $stderr).Trim()

    $compileSucceeded = $false
    $runSucceeded = $false
    $runDetected = $false

    if ($combinedLog -match 'COMPILATION ERROR') {
        $compileSucceeded = $false
        $runDetected = $false
    }
    else {
        $compileSucceeded = $true
        if ($combinedLog -match 'Tests run:' -or (Test-Path $surefireDir)) {
            $runDetected = $true
        }
    }

    if ($compileSucceeded -and $runDetected -and -not $timedOut -and $process.ExitCode -eq 0) {
        $runSucceeded = $true
    }

    $baseRow = @{
        service = $service
        profile = $profile
        file = $file.Name
        class = $className
        file_type = $fileType
        file_path = $file.FullName
        compiles = $compileSucceeded
        runs = $runSucceeded
        run_detected = $runDetected
        exit_code = $process.ExitCode
        timeout = $timedOut
        execution_seconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2)
        peak_working_set_mb = $peakWorkingSetMb
        cpu_seconds = $cpuSeconds
        error_or_exception = (Get-ErrorSummary -CombinedLog $combinedLog)
        stdout_log = $stdoutPath
        stderr_log = $stderrPath
    }

    if ($methodBlocks.Count -eq 0) {
        $results.Add([pscustomobject]($baseRow + @{
            test_method = ""
            endpoint = ""
            http_verb = ""
        })) | Out-Null
        continue
    }

    foreach ($block in $methodBlocks) {
        $methodName = $block.Groups["method"].Value
        $comment = $block.Groups["comment"].Value
        $body = $block.Groups["body"].Value
        $endpointInfo = Get-EndpointInfo -Comment $comment -Body $body

        $results.Add([pscustomobject]($baseRow + @{
            test_method = $methodName
            endpoint = $endpointInfo.Endpoint
            http_verb = $endpointInfo.Verb
        })) | Out-Null
    }
}

$results | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Host "CSV gerado em: $OutputCsv" -ForegroundColor Green
