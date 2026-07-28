#define MyAppName "Dideban Platform"
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#ifndef SourceRoot
  #define SourceRoot "stage"
#endif
#define MyAppPublisher "Dideban Platform Team"
#define MyAppExeName "DidebanLauncher.cmd"

[Setup]
AppId={{7D42943F-3B2B-4C6D-A910-6E13A63E7D11}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\Dideban
DefaultGroupName=Dideban
OutputDir=output
OutputBaseFilename=DidebanSetup-{#MyAppVersion}
Compression=lzma2/ultra64
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
WizardStyle=modern
UninstallDisplayIcon={app}\web\libs\img\icon\favicon-96.png
SetupLogging=yes
CloseApplications=yes
RestartApplications=no
ChangesEnvironment=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Dirs]
Name: "{commonappdata}\Dideban"; Permissions: users-modify
Name: "{commonappdata}\Dideban\logs"; Permissions: users-modify
Name: "{commonappdata}\Dideban\backups"; Permissions: users-modify
Name: "{commonappdata}\Dideban\updates"; Permissions: users-modify
Name: "{commonappdata}\Dideban\support-packages"; Permissions: users-modify

[Files]
Source: "{#SourceRoot}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "conf.json,super.json,.env,videos\*,logs\*,backups\*,updates\*,support-packages\*"
Source: "{#SourceRoot}\conf.sample.json"; DestDir: "{commonappdata}\Dideban"; DestName: "conf.json"; Flags: onlyifdoesntexist
Source: "{#SourceRoot}\super.sample.json"; DestDir: "{commonappdata}\Dideban"; DestName: "super.json"; Flags: onlyifdoesntexist
Source: "scripts\Install-Dideban.ps1"; DestDir: "{app}\installer\scripts"; Flags: ignoreversion
Source: "scripts\Uninstall-Dideban.ps1"; DestDir: "{app}\installer\scripts"; Flags: ignoreversion

[Icons]
Name: "{group}\Dideban"; Filename: "{app}\DidebanLauncher.cmd"; WorkingDir: "{app}"
Name: "{commondesktop}\Dideban"; Filename: "{app}\DidebanLauncher.cmd"; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{group}\Open Dideban"; Filename: "http://localhost:8080"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Run]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\installer\scripts\Install-Dideban.ps1"" -AppDir ""{app}"" -DataDir ""{commonappdata}\Dideban"""; Flags: runhidden waituntilterminated
Filename: "http://localhost:8080"; Description: "Open Dideban"; Flags: postinstall shellexec skipifsilent

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\installer\scripts\Uninstall-Dideban.ps1"" -AppDir ""{app}"" -DataDir ""{commonappdata}\Dideban"""; Flags: runhidden waituntilterminated; RunOnceId: "DidebanUninstall"

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Exec(ExpandConstant('{sys}\sc.exe'), 'stop Dideban', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Sleep(1500);
  Result := '';
end;
