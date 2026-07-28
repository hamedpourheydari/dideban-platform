# Phase 31.2 — Windows Service

این فاز Task Scheduler موقت Phase 31.1 را با Windows Service واقعی جایگزین می‌کند.

## امکانات

- سرویس با نام `Dideban`
- شروع خودکار همراه ویندوز
- اجرای Node.js همراه Installer
- توقف کامل پردازش‌های فرزند هنگام Stop
- Restart خودکار سرویس پس از Crash
- ثبت خروجی در `C:\ProgramData\Dideban\logs\service.log`
- حفظ داده‌ها هنگام Uninstall و Upgrade

## ساخت

پس از نصب Inno Setup 6:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\build-installer.ps1
```

اسکریپت ابتدا `DidebanService.exe` را با کامپایلر داخلی .NET Framework می‌سازد و سپس Installer را کامپایل می‌کند.

## تست سرویس بدون Installer

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\service\build-service.ps1
.\installer\service\DidebanService.exe --console --appdir "$PWD" --datadir "C:\ProgramData\Dideban"
```
