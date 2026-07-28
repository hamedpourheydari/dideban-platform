param(
    [Parameter(Mandatory=$true)][string]$Version,
    [string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [string]$OutputDirectory = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'release')
)
$ErrorActionPreference='Stop'
$staging = Join-Path $env:TEMP ('dideban-release-' + [guid]::NewGuid().ToString('N'))
$payload = Join-Path $staging 'dideban'
New-Item -ItemType Directory -Force -Path $payload,$OutputDirectory | Out-Null
$excluded = @('.git','node_modules','videos','streams','fileBin','logs','updates','backups','web\uploads','conf.json','super.json','.env','release')
Get-ChildItem -LiteralPath $RepositoryRoot -Force | ForEach-Object {
    if($excluded -contains $_.Name){ return }
    Copy-Item -LiteralPath $_.FullName -Destination $payload -Recurse -Force
}
$manifestPath=Join-Path $RepositoryRoot 'update.json'
$manifest=Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$packageJsonPath=Join-Path $payload 'package.json'
$package=Get-Content -LiteralPath $packageJsonPath -Raw | ConvertFrom-Json
$package.version=$Version
$package | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $packageJsonPath -Encoding UTF8
@{schemaVersion=1;productId='com.dideban.platform';version=$Version;payloadDirectory='.';description='Dideban Platform automatic/offline update package';changelog=@($manifest.changelog)} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $payload 'update-package.json') -Encoding UTF8
$zip=Join-Path $OutputDirectory ('dideban-update-'+$Version+'.zip')
if(Test-Path $zip){Remove-Item $zip -Force}
Compress-Archive -Path (Join-Path $payload '*') -DestinationPath $zip -CompressionLevel Optimal
$hash=(Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
$manifest.version=$Version
$manifest.sha256=$hash
$manifest.downloadUrl=('https://github.com/hamedpourheydari/dideban-platform/releases/download/v'+$Version+'/dideban-update-'+$Version+'.zip')
$manifest.releaseDate=(Get-Date -Format 'yyyy-MM-dd')
$manifest | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
Remove-Item -LiteralPath $staging -Recurse -Force
Write-Host "Package: $zip"
Write-Host "SHA256: $hash"
Write-Host "update.json was updated automatically."
