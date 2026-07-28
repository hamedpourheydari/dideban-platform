param([Parameter(Mandatory=$true)][string]$ArchivePath)
$ErrorActionPreference='Stop'
$work=Join-Path $env:TEMP ('dideban-inspect-'+[guid]::NewGuid().ToString('N'))
try{
    if(-not (Test-Path -LiteralPath $ArchivePath -PathType Leaf)){throw 'فایل بسته پیدا نشد.'}
    if([IO.Path]::GetExtension($ArchivePath).ToLowerInvariant() -ne '.zip'){throw 'بسته باید ZIP باشد.'}
    New-Item -ItemType Directory -Force -Path $work | Out-Null
    Expand-Archive -LiteralPath $ArchivePath -DestinationPath $work -Force
    $root=$work
    $top=@(Get-ChildItem -LiteralPath $work -Force)
    if($top.Count -eq 1 -and $top[0].PSIsContainer){$root=$top[0].FullName}
    $manifestPath=Join-Path $root 'update-package.json'
    if(-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)){throw 'فایل update-package.json داخل بسته وجود ندارد.'}
    $manifest=Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    if([int]$manifest.schemaVersion -ne 1){throw 'نسخه ساختار بسته پشتیبانی نمی‌شود.'}
    if(([string]$manifest.productId) -ne 'com.dideban.platform'){throw 'این بسته متعلق به نرم‌افزار دیده‌بان نیست.'}
    $version=([string]$manifest.version).Trim()
    if($version -notmatch '^\d+\.\d+\.\d+([.-][0-9A-Za-z.-]+)?$'){throw 'نسخه بسته معتبر نیست.'}
    $payload=$root
    if($manifest.payloadDirectory){
        $candidate=[IO.Path]::GetFullPath((Join-Path $root ([string]$manifest.payloadDirectory)))
        $base=[IO.Path]::GetFullPath($root).TrimEnd('\')+'\'
        if(-not $candidate.StartsWith($base,[StringComparison]::OrdinalIgnoreCase) -and $candidate -ne [IO.Path]::GetFullPath($root)){throw 'مسیر payload نامعتبر است.'}
        if(-not (Test-Path -LiteralPath $candidate -PathType Container)){throw 'پوشه payload بسته پیدا نشد.'}
        $payload=$candidate
    }
    $packageJson=Join-Path $payload 'package.json'
    if(-not (Test-Path -LiteralPath $packageJson -PathType Leaf)){throw 'package.json داخل بسته پیدا نشد.'}
    $package=Get-Content -LiteralPath $packageJson -Raw | ConvertFrom-Json
    if(([string]$package.version) -ne $version){throw 'نسخه package.json با Manifest بسته هماهنگ نیست.'}
    $files=@(Get-ChildItem -LiteralPath $payload -Recurse -Force -File)
    if($files.Count -lt 2){throw 'بسته فایل کافی برای نصب ندارد.'}
    $changes=@()
    if($manifest.changelog){$changes=@($manifest.changelog | Select-Object -First 30)}
    @{ok=$true;productId='com.dideban.platform';version=$version;description=[string]$manifest.description;changelog=$changes;fileCount=$files.Count} | ConvertTo-Json -Compress -Depth 8
}catch{
    @{ok=$false;message=$_.Exception.Message} | ConvertTo-Json -Compress -Depth 4
    exit 1
}finally{
    try{if(Test-Path -LiteralPath $work){Remove-Item -LiteralPath $work -Recurse -Force}}catch{}
}
