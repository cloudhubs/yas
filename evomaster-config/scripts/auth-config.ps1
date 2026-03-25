function Get-YasAuthDefaults {
    [pscustomobject]@{
        KeycloakUrl       = if ($env:KEYCLOAK_URL) { $env:KEYCLOAK_URL } else { 'http://identity' }
        KeycloakRealm     = if ($env:KEYCLOAK_REALM) { $env:KEYCLOAK_REALM } else { 'Yas' }
        KeycloakClientId  = if ($env:KEYCLOAK_CLIENT_ID) { $env:KEYCLOAK_CLIENT_ID } else { 'backoffice-bff' }
        KeycloakClientSecret = if ($env:KEYCLOAK_CLIENT_SECRET) { $env:KEYCLOAK_CLIENT_SECRET } else { 'TVacLC0cQ8tiiEKiTVerTb2YvwQ1TRJF' }
        YasApiUrl         = if ($env:YAS_API_URL) { $env:YAS_API_URL } else { 'http://api.yas.local' }
        AdminUsername     = if ($env:ADMIN_USERNAME) { $env:ADMIN_USERNAME } else { 'admin' }
        AdminPassword     = if ($env:ADMIN_PASSWORD) { $env:ADMIN_PASSWORD } else { 'password' }
        CustomerUsername  = if ($env:CUSTOMER_USERNAME) { $env:CUSTOMER_USERNAME } else { 'user' }
        CustomerPassword  = if ($env:CUSTOMER_PASSWORD) { $env:CUSTOMER_PASSWORD } else { 'password' }
        KeycloakAdminUsername = if ($env:KC_ADMIN_USERNAME) { $env:KC_ADMIN_USERNAME } else { 'admin' }
        KeycloakAdminPassword = if ($env:KC_ADMIN_PASSWORD) { $env:KC_ADMIN_PASSWORD } else { 'admin' }
    }
}

function Get-YasOAuthToken {
    param(
        [Parameter(Mandatory = $true)][string]$KeycloakUrl,
        [Parameter(Mandatory = $true)][string]$Realm,
        [Parameter(Mandatory = $true)][string]$ClientId,
        [Parameter(Mandatory = $true)][string]$ClientSecret,
        [Parameter(Mandatory = $true)][string]$Username,
        [Parameter(Mandatory = $true)][string]$Password
    )

    $tokenUrl = "$KeycloakUrl/realms/$Realm/protocol/openid-connect/token"
    try {
        $response = Invoke-RestMethod -Uri $tokenUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body @{
            grant_type    = 'password'
            client_id     = $ClientId
            client_secret = $ClientSecret
            username      = $Username
            password      = $Password
        } -TimeoutSec 30
    }
    catch {
        return ''
    }

    if ($response.access_token) {
        return $response.access_token
    }

    return ''
}

function Get-YasKeycloakAdminToken {
    param(
        [Parameter(Mandatory = $true)][string]$KeycloakUrl,
        [Parameter(Mandatory = $true)][string]$AdminUsername,
        [Parameter(Mandatory = $true)][string]$AdminPassword
    )

    $tokenUrl = "$KeycloakUrl/realms/master/protocol/openid-connect/token"
    try {
        $response = Invoke-RestMethod -Uri $tokenUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body @{
            grant_type = 'password'
            client_id  = 'admin-cli'
            username   = $AdminUsername
            password   = $AdminPassword
        } -TimeoutSec 30
    }
    catch {
        return ''
    }

    if ($response.access_token) {
        return $response.access_token
    }

    return ''
}

function Ensure-YasCustomerUserExists {
    param(
        [Parameter(Mandatory = $true)][string]$KeycloakUrl,
        [Parameter(Mandatory = $true)][string]$Realm,
        [Parameter(Mandatory = $true)][string]$AdminUsername,
        [Parameter(Mandatory = $true)][string]$AdminPassword,
        [Parameter(Mandatory = $true)][string]$CustomerUsername,
        [Parameter(Mandatory = $true)][string]$CustomerPassword
    )

    $adminToken = Get-YasKeycloakAdminToken -KeycloakUrl $KeycloakUrl -AdminUsername $AdminUsername -AdminPassword $AdminPassword
    if (-not $adminToken) {
        throw 'Nao foi possivel obter o token de administrador do Keycloak.'
    }

    $headers = @{ Authorization = "Bearer $adminToken" }
    $usersUrl = "$KeycloakUrl/admin/realms/$Realm/users?username=$CustomerUsername&exact=true"

    try {
        $existingUsers = Invoke-RestMethod -Uri $usersUrl -Method Get -Headers $headers -TimeoutSec 30
    }
    catch {
        throw 'Falha ao consultar o usuario customer no Keycloak.'
    }

    if ($existingUsers -and $existingUsers.Count -gt 0) {
        return
    }

    $createBody = @{
        username    = $CustomerUsername
        enabled     = $true
        credentials = @(@{
            type      = 'password'
            value     = $CustomerPassword
            temporary = $false
        })
    } | ConvertTo-Json -Depth 5

    try {
        Invoke-WebRequest -Uri "$KeycloakUrl/admin/realms/$Realm/users" -Method Post -Headers $headers -ContentType 'application/json' -Body $createBody -TimeoutSec 30 | Out-Null
    }
    catch {
        throw 'Falha ao criar o usuario customer no Keycloak.'
    }
}
