# Phase 28.2 - Windows PowerShell UTF-8 Fix

PowerShell scripts that contain Persian messages are now stored as UTF-8 with BOM.
This prevents Windows PowerShell 5.1 from interpreting Persian bytes as ANSI and producing ParserError / UnexpectedToken errors.

Affected files:
- updater/Inspect-DidebanPackage.ps1
- updater/DidebanUpdater.ps1
- scripts/build-update-package.ps1
