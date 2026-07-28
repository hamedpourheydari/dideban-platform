param(
    [Parameter(Mandatory=$true)][string]$AppDir,
    [Parameter(Mandatory=$true)][string]$DataDir
)
$ErrorActionPreference = 'Stop'
$serviceName = 'Dideban'
$serviceExe = Join-Path $AppDir 'service\DidebanService.exe'
if (-not (Test-Path $serviceExe)) { throw "Service executable not found: $serviceExe" }

$folders = @('logs','backups','updates','support-packages','videos','uploads')
New-Item -ItemType Directory -Force -Path $DataDir | Out-Null
foreach ($folder in $folders) { New-Item -ItemType Directory -Force -Path (Join-Path $DataDir $folder) | Out-Null }

# Remove the old scheduled-task implementation from Phase 31.1, when present.
schtasks.exe /Delete /TN 'Dideban' /F 2>$null | Out-Null

$existing = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($existing) {
    if ($existing.Status -ne 'Stopped') {
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
        (Get-Service -Name $serviceName).WaitForStatus('Stopped', (New-TimeSpan -Seconds 30))
    }
    sc.exe delete $serviceName | Out-Null
    Start-Sleep -Seconds 2
}

$binPath = '"{0}" --appdir "{1}" --datadir "{2}"' -f $serviceExe, $AppDir, $DataDir
sc.exe create $serviceName binPath= $binPath start= auto DisplayName= 'Dideban Platform Service' | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not create Windows service. sc.exe exit code: $LASTEXITCODE" }
sc.exe description $serviceName 'Runs Dideban Platform and automatically starts it with Windows.' | Out-Null
sc.exe failure $serviceName reset= 86400 actions= restart/5000/restart/15000/restart/30000 | Out-Null
sc.exe failureflag $serviceName 1 | Out-Null

# Allow local and remote access to the configured default web port.
netsh advfirewall firewall delete rule name='Dideban Web 8080' 2>$null | Out-Null
netsh advfirewall firewall add rule name='Dideban Web 8080' dir=in action=allow protocol=TCP localport=8080 profile=any | Out-Null

Start-Service -Name $serviceName
(Get-Service -Name $serviceName).WaitForStatus('Running', (New-TimeSpan -Seconds 30))
Write-Host 'Dideban Windows service installed and started.' -ForegroundColor Green
