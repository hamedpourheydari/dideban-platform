# Dideban UI Phase 27 — One-click Automatic Update

این فاز چرخه کامل به‌روزرسانی ویندوز را با یک دکمه فعال می‌کند:

1. بررسی خودکار نسخه
2. دانلود HTTPS
3. بررسی SHA-256
4. اجرای Updater مستقل
5. توقف سرویس
6. استخراج امن بسته
7. پشتیبان‌گیری از فایل‌های جایگزین‌شونده
8. نصب فایل‌های برنامه
9. Rollback در صورت خطا
10. راه‌اندازی مجدد دیده‌بان

## داده‌های محافظت‌شده

`conf.json`, `super.json`, `.env`, `videos`, `streams`, `fileBin`, `logs`, `web/uploads`, `updates`, `backups`, `node_modules`

## ساخت بسته انتشار

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-update-package.ps1 -Version 1.0.1
```

این اسکریپت ZIP و SHA-256 را می‌سازد و `update.json` را خودکار به‌روزرسانی می‌کند. کاربر نهایی هیچ مقداری وارد نمی‌کند.
