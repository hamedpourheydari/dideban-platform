param(
    [string]$OutputPath = (Join-Path $PSScriptRoot 'DidebanService.exe')
)
$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'DidebanService.cs'
if (-not (Test-Path $source)) { throw "Service source not found: $source" }

$frameworkRoots = @(
    "$env:WINDIR\Microsoft.NET\Framework64\v4.0.30319",
    "$env:WINDIR\Microsoft.NET\Framework\v4.0.30319"
)
$csc = $frameworkRoots | ForEach-Object { Join-Path $_ 'csc.exe' } | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $csc) { throw '.NET Framework C# compiler (csc.exe) was not found.' }

& $csc /nologo /target:exe /optimize+ /platform:anycpu /out:$OutputPath /reference:System.ServiceProcess.dll $source
if ($LASTEXITCODE -ne 0) { throw "Service compilation failed with exit code $LASTEXITCODE" }
if (-not (Test-Path $OutputPath)) { throw 'Service executable was not created.' }
Write-Host "Service executable created: $OutputPath" -ForegroundColor Green
