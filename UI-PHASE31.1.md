# Phase 31.1 — Windows Installer Foundation

This phase adds the first real Windows packaging foundation without changing application backend or UI logic.

## Included
- Inno Setup definition for `DidebanSetup.exe`
- Bundled Node runtime from the build machine
- Automatic startup through a Windows SYSTEM scheduled task
- Firewall rule for TCP 8080
- Persistent data under `C:\ProgramData\Dideban`
- Junctions/hard links that keep configuration, logs, backups, updates and support packages outside the application directory
- Uninstall keeps customer data intact

## Build
1. Install Inno Setup 6 on the build machine.
2. Run PowerShell as Administrator:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\build-installer.ps1
```

Output:

```text
installer\output\DidebanSetup-<version>.exe
```

## Important
This phase uses a SYSTEM startup task as a safe built-in Windows background runner. A dedicated Windows service wrapper will replace it in Phase 31.2.
