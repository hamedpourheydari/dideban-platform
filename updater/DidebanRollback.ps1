param(
    [Parameter(Mandatory=$true)][string]$JobPath
)
$ErrorActionPreference='Stop'
function Normalize-RelativePath { param([string]$Base,[string]$Full) $b=New-Object System.Uri(($Base.TrimEnd('\\')+'\\'));$f=New-Object System.Uri($Full);[System.Uri]::UnescapeDataString($b.MakeRelativeUri($f).ToString()).Replace('/','\\') }
function Write-Result { param([string]$Status,[string]$Message,[hashtable]$Extra=@{}) $o=@{status=$Status;message=$Message;completedAt=(Get-Date).ToUniversalTime().ToString('o')};foreach($k in $Extra.Keys){$o[$k]=$Extra[$k]};$o|ConvertTo-Json -Depth 8|Set-Content -LiteralPath $job.resultPath -Encoding UTF8 }
$job=Get-Content -LiteralPath $JobPath -Raw|ConvertFrom-Json
$appRoot=[IO.Path]::GetFullPath([string]$job.applicationRoot)
$backupPath=[IO.Path]::GetFullPath([string]$job.backupPath)
try{
 if(-not (Test-Path -LiteralPath $backupPath -PathType Container)){throw 'نسخه پشتیبان انتخاب‌شده پیدا نشد.'}
 $manifestPath=Join-Path $backupPath 'backup-manifest.json'
 if(-not (Test-Path -LiteralPath $manifestPath)){throw 'فایل مشخصات نسخه پشتیبان پیدا نشد.'}
 $m=Get-Content -LiteralPath $manifestPath -Raw|ConvertFrom-Json
 if([string]$m.productId -ne 'com.dideban.platform'){throw 'این نسخه پشتیبان متعلق به دیده‌بان نیست.'}
 if($job.parentPid){try{Wait-Process -Id ([int]$job.parentPid) -Timeout 90 -ErrorAction Stop}catch{try{Stop-Process -Id ([int]$job.parentPid) -Force -ErrorAction SilentlyContinue}catch{};Start-Sleep 2}}
 foreach($rel in @($m.createdFiles)){ $target=[IO.Path]::GetFullPath((Join-Path $appRoot ([string]$rel)));if($target.StartsWith(($appRoot.TrimEnd('\\')+'\\'),[StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $target -PathType Leaf)){Remove-Item -LiteralPath $target -Force} }
 Get-ChildItem -LiteralPath $backupPath -Recurse -Force -File|Where-Object{$_.Name -ne 'backup-manifest.json'}|ForEach-Object{ $rel=Normalize-RelativePath $backupPath $_.FullName;$dest=[IO.Path]::GetFullPath((Join-Path $appRoot $rel));if(-not $dest.StartsWith(($appRoot.TrimEnd('\\')+'\\'),[StringComparison]::OrdinalIgnoreCase)){throw 'مسیر بازیابی نامعتبر است.'};New-Item -ItemType Directory -Force -Path ([IO.Path]::GetDirectoryName($dest))|Out-Null;Copy-Item -LiteralPath $_.FullName -Destination $dest -Force }
 Write-Result 'success' ('بازگشت به نسخه '+[string]$m.fromVersion+' با موفقیت انجام شد.') @{version=[string]$m.fromVersion;backupPath=$backupPath}
}catch{Write-Result 'failed' $_.Exception.Message @{backupPath=$backupPath}}
finally{if($job.restartFile -and (Test-Path -LiteralPath ([string]$job.restartFile))){Start-Process -FilePath ([string]$job.restartFile) -WorkingDirectory $appRoot}else{Start-Process -FilePath 'node.exe' -ArgumentList 'camera.js' -WorkingDirectory $appRoot}}
