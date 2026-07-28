param(
    [Parameter(Mandatory=$true)][string]$AppDir,
    [Parameter(Mandatory=$true)][string]$DataDir
)
$ErrorActionPreference = 'Continue'
$serviceName = 'Dideban'
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($service) {
    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
    try { (Get-Service -Name $serviceName).WaitForStatus('Stopped', (New-TimeSpan -Seconds 30)) } catch {}
    sc.exe delete $serviceName | Out-Null
}
schtasks.exe /Delete /TN 'Dideban' /F 2>$null | Out-Null
netsh advfirewall firewall delete rule name='Dideban Web 8080' 2>$null | Out-Null
# DataDir is intentionally preserved for reinstall/upgrade recovery.
