param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [string]$Version = '',
    [string]$InnoSetupCompiler = ''
)
$ErrorActionPreference = 'Stop'

if (-not $Version) {
    $package = Get-Content (Join-Path $ProjectRoot 'package.json') -Raw | ConvertFrom-Json
    $Version = [string]$package.version
}
if (-not $InnoSetupCompiler) {
    $candidates = @(
        "$env:ProgramFiles(x86)\Inno Setup 6\ISCC.exe",
        "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
    )
    $InnoSetupCompiler = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $InnoSetupCompiler -or -not (Test-Path $InnoSetupCompiler)) {
    throw 'Inno Setup 6 compiler (ISCC.exe) was not found.'
}

$installerRoot = $PSScriptRoot

# Build the native Windows service wrapper before staging the installer.
& (Join-Path $installerRoot 'service\build-service.ps1')
if ($LASTEXITCODE -ne 0) { throw 'Windows service build failed.' }
$stage = Join-Path $installerRoot 'stage'
$output = Join-Path $installerRoot 'output'
Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $stage, $output | Out-Null

$excludeDirs = @('.git','release','installer\stage','installer\output','videos','logs','backups','updates','support-packages')
$excludeFiles = @('conf.json','super.json','.env')
$xd = $excludeDirs | ForEach-Object { Join-Path $ProjectRoot $_ }
$xf = $excludeFiles | ForEach-Object { Join-Path $ProjectRoot $_ }
& robocopy $ProjectRoot $stage /E /R:1 /W:1 /XD $xd /XF $xf /NFL /NDL /NJH /NJS /NP | Out-Null
if ($LASTEXITCODE -ge 8) { throw "Robocopy failed with exit code $LASTEXITCODE" }

Copy-Item (Join-Path $installerRoot 'DidebanLauncher.cmd') (Join-Path $stage 'DidebanLauncher.cmd') -Force
$serviceStage = Join-Path $stage 'service'
New-Item -ItemType Directory -Force -Path $serviceStage | Out-Null
Copy-Item (Join-Path $installerRoot 'service\DidebanService.exe') (Join-Path $serviceStage 'DidebanService.exe') -Force

$nodeCommand = Get-Command node.exe -ErrorAction Stop
$runtimeDir = Join-Path $stage 'runtime'
New-Item -ItemType Directory -Force -Path $runtimeDir | Out-Null
Copy-Item $nodeCommand.Source (Join-Path $runtimeDir 'node.exe') -Force

$iss = Join-Path $installerRoot 'DidebanSetup.iss'
& $InnoSetupCompiler "/DMyAppVersion=$Version" "/DSourceRoot=$stage" $iss
if ($LASTEXITCODE -ne 0) { throw "Inno Setup failed with exit code $LASTEXITCODE" }
Write-Host "Installer created in: $output" -ForegroundColor Green
