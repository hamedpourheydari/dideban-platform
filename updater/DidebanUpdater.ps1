param(
    [Parameter(Mandatory=$true)]
    [string]$JobPath
)

$ErrorActionPreference = 'Stop'

function Write-Result {
    param([string]$Status,[string]$Message,[hashtable]$Extra=@{})
    $payload = @{
        status = $Status
        message = $Message
        completedAt = (Get-Date).ToUniversalTime().ToString('o')
    }
    foreach($key in $Extra.Keys){ $payload[$key] = $Extra[$key] }
    $payload | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $job.resultPath -Encoding UTF8
}

function Normalize-RelativePath {
    param([string]$Base,[string]$Full)
    $baseUri = New-Object System.Uri(($Base.TrimEnd('\') + '\'))
    $fullUri = New-Object System.Uri($Full)
    return [System.Uri]::UnescapeDataString($baseUri.MakeRelativeUri($fullUri).ToString()).Replace('/','\')
}

function Is-ProtectedPath {
    param([string]$Relative,[object[]]$Protected)
    $candidate = $Relative.Replace('/','\').TrimStart('\').ToLowerInvariant()
    foreach($item in $Protected){
        $protectedPath = ([string]$item).Replace('/','\').Trim('\').ToLowerInvariant()
        if($candidate -eq $protectedPath -or $candidate.StartsWith($protectedPath + '\')){ return $true }
    }
    return $false
}

$job = Get-Content -LiteralPath $JobPath -Raw | ConvertFrom-Json
$appRoot = [System.IO.Path]::GetFullPath([string]$job.applicationRoot)
$archivePath = [System.IO.Path]::GetFullPath([string]$job.archivePath)
$backupRoot = [System.IO.Path]::GetFullPath([string]$job.backupRoot)
$version = ([string]$job.version -replace '[^0-9A-Za-z._-]','_')
$workRoot = Join-Path ([System.IO.Path]::GetDirectoryName($JobPath)) ('work-' + $version + '-' + [DateTimeOffset]::UtcNow.ToUnixTimeSeconds())
$extractRoot = Join-Path $workRoot 'extracted'
$backupPath = Join-Path $backupRoot (($job.currentVersion -replace '[^0-9A-Za-z._-]','_') + '-before-' + $version + '-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$copiedFiles = New-Object System.Collections.Generic.List[string]
$createdFiles = New-Object System.Collections.Generic.List[string]
$replacedFiles = New-Object System.Collections.Generic.List[string]

try {
    if(-not (Test-Path -LiteralPath $archivePath)){ throw 'فایل بسته به‌روزرسانی پیدا نشد.' }
    New-Item -ItemType Directory -Force -Path $extractRoot,$backupPath | Out-Null

    if($job.parentPid){
        try { Wait-Process -Id ([int]$job.parentPid) -Timeout 90 -ErrorAction Stop } catch {
            try { Stop-Process -Id ([int]$job.parentPid) -Force -ErrorAction SilentlyContinue } catch {}
            Start-Sleep -Seconds 2
        }
    }

    Expand-Archive -LiteralPath $archivePath -DestinationPath $extractRoot -Force

    $payloadRoot = $extractRoot
    $topItems = @(Get-ChildItem -LiteralPath $extractRoot -Force)
    if($topItems.Count -eq 1 -and $topItems[0].PSIsContainer){ $payloadRoot = $topItems[0].FullName }

    $packageManifest = Join-Path $payloadRoot 'update-package.json'
    if(Test-Path -LiteralPath $packageManifest){
        $package = Get-Content -LiteralPath $packageManifest -Raw | ConvertFrom-Json
        if(([string]$package.productId) -ne 'com.dideban.platform'){ throw 'این بسته متعلق به نرم‌افزار دیده‌بان نیست.' }
        if($package.version -and ([string]$package.version -ne [string]$job.version)){
            throw "نسخه بسته با نسخه Manifest هماهنگ نیست."
        }
        if($package.payloadDirectory){
            $candidate = [System.IO.Path]::GetFullPath((Join-Path $payloadRoot ([string]$package.payloadDirectory)))
            if(-not $candidate.StartsWith([System.IO.Path]::GetFullPath($payloadRoot),[System.StringComparison]::OrdinalIgnoreCase)){ throw 'مسیر payload نامعتبر است.' }
            if(-not (Test-Path -LiteralPath $candidate -PathType Container)){ throw 'پوشه payload بسته پیدا نشد.' }
            $payloadRoot = $candidate
        }
    }

    $files = @(Get-ChildItem -LiteralPath $payloadRoot -Recurse -Force -File)
    if($files.Count -eq 0){ throw 'بسته به‌روزرسانی هیچ فایلی برای نصب ندارد.' }

    foreach($file in $files){
        $relative = Normalize-RelativePath -Base $payloadRoot -Full $file.FullName
        if($relative -eq 'update-package.json'){ continue }
        if(Is-ProtectedPath -Relative $relative -Protected $job.protectedPaths){ continue }
        if($relative.StartsWith('.git\') -or $relative -eq '.git'){ continue }

        $destination = [System.IO.Path]::GetFullPath((Join-Path $appRoot $relative))
        if(-not $destination.StartsWith(($appRoot.TrimEnd('\') + '\'),[System.StringComparison]::OrdinalIgnoreCase)){ throw 'مسیر فایل بسته خارج از پوشه برنامه است.' }

        if(Test-Path -LiteralPath $destination -PathType Leaf){
            $replacedFiles.Add($relative)
            $backupFile = Join-Path $backupPath $relative
            New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($backupFile)) | Out-Null
            Copy-Item -LiteralPath $destination -Destination $backupFile -Force
        } else {
            $createdFiles.Add($relative)
        }

        New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($destination)) | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
        $copiedFiles.Add($destination)
    }

    $postUpdate = Join-Path $payloadRoot '_dideban_update\post-update.ps1'
    if(Test-Path -LiteralPath $postUpdate){
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $postUpdate -ApplicationRoot $appRoot
        if($LASTEXITCODE -ne 0){ throw 'اجرای عملیات تکمیلی بسته ناموفق بود.' }
    }

    $backupManifest = @{schemaVersion=1;productId='com.dideban.platform';fromVersion=[string]$job.currentVersion;toVersion=$version;createdAt=(Get-Date).ToUniversalTime().ToString('o');replacedFiles=@($replacedFiles);createdFiles=@($createdFiles);protectedPaths=@($job.protectedPaths)}
    $backupManifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $backupPath 'backup-manifest.json') -Encoding UTF8

    Write-Result -Status 'success' -Message ('نسخه ' + $version + ' با موفقیت نصب شد.') -Extra @{version=$version;backupPath=$backupPath;filesInstalled=$copiedFiles.Count}
}
catch {
    $failure = $_.Exception.Message
    try {
        foreach($relative in $createdFiles){
            $createdPath = Join-Path $appRoot $relative
            if(Test-Path -LiteralPath $createdPath -PathType Leaf){ Remove-Item -LiteralPath $createdPath -Force }
        }
        if(Test-Path -LiteralPath $backupPath){
            Get-ChildItem -LiteralPath $backupPath -Recurse -Force -File | ForEach-Object {
                $relative = Normalize-RelativePath -Base $backupPath -Full $_.FullName
                $destination = Join-Path $appRoot $relative
                New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($destination)) | Out-Null
                Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
            }
        }
    } catch {}
    Write-Result -Status 'failed' -Message $failure -Extra @{version=$version;backupPath=$backupPath}
}
finally {
    try { if(Test-Path -LiteralPath $workRoot){ Remove-Item -LiteralPath $workRoot -Recurse -Force } } catch {}
    if($job.restartFile -and (Test-Path -LiteralPath ([string]$job.restartFile))){
        Start-Process -FilePath ([string]$job.restartFile) -WorkingDirectory $appRoot
    } else {
        Start-Process -FilePath 'node.exe' -ArgumentList 'camera.js' -WorkingDirectory $appRoot
    }
}
