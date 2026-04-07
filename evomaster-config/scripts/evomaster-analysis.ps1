param(
    [string]$RootDir = "",
    [string]$OutputCsv = ""
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RootDir) {
    $RootDir = (Resolve-Path (Join-Path $scriptDir "..\generated-tests\blackbox")).Path
}
if (-not $OutputCsv) {
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $OutputCsv = Join-Path $RootDir "evomaster_analysis_$stamp.csv"
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

function Get-AssertedStatusCode {
    param([string]$Body)

    $matches = [regex]::Matches($Body, '\.statusCode\((\d+)\)')
    if ($matches.Count -eq 0) { return "" }
    return (($matches | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique) -join ";")
}

function Get-AssertCount {
    param([string]$Body)

    $thenIndex = $Body.IndexOf(".then()")
    $assertionBody = if ($thenIndex -ge 0) { $Body.Substring($thenIndex) } else { $Body }
    $assertPattern = '\.(statusCode|body|header|headers|contentType|statusLine|time|cookie|cookies)\('
    return [regex]::Matches($assertionBody, $assertPattern).Count
}

if (-not (Test-Path $RootDir)) {
    throw "Directory not found: $RootDir"
}

$rows = New-Object System.Collections.Generic.List[object]
$javaFiles = Get-ChildItem -Path $RootDir -Recurse -Filter "*.java" -File | Sort-Object FullName

foreach ($file in $javaFiles) {
    $content = Get-Content $file.FullName -Raw
    $className = Get-ClassName -Content $content
    $fileType = Get-FileType -FileName $file.Name

    $relativePath = $file.FullName.Substring($RootDir.Length).TrimStart('\', '/')
    $segments = $relativePath -split '[\\/]'
    $service = if ($segments.Length -ge 1) { $segments[0] } else { "" }
    $profile = if ($segments.Length -ge 2) { $segments[1] } else { "" }

    $methodBlocks = Get-MethodBlocks -Content $content
    if ($methodBlocks.Count -eq 0) {
        $rows.Add([pscustomobject]@{
            service = $service
            profile = $profile
            file = $file.Name
            class = $className
            test_method = ""
            endpoint = ""
            http = ""
            asserted_code = ""
            assert_count = 0
            file_type = $fileType
            file_path = $file.FullName
        }) | Out-Null
        continue
    }

    foreach ($block in $methodBlocks) {
        $methodName = $block.Groups["method"].Value
        $comment = $block.Groups["comment"].Value
        $body = $block.Groups["body"].Value
        $endpointInfo = Get-EndpointInfo -Comment $comment -Body $body
        $statusCode = Get-AssertedStatusCode -Body $body
        $assertCount = Get-AssertCount -Body $body

        $rows.Add([pscustomobject]@{
            service = $service
            profile = $profile
            file = $file.Name
            class = $className
            test_method = $methodName
            endpoint = $endpointInfo.Endpoint
            http = $endpointInfo.Verb
            asserted_code = $statusCode
            assert_count = $assertCount
            file_type = $fileType
            file_path = $file.FullName
        }) | Out-Null
    }
}

$rows | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Host "CSV gerado em: $OutputCsv" -ForegroundColor Green
