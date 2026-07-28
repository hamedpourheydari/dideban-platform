# Dideban Phase 28 — Offline USB/ZIP Update

این فاز نصب بسته آفلاین را به پنل Super اضافه می‌کند. مدیر فایل ZIP تولیدشده توسط اسکریپت انتشار را از USB انتخاب می‌کند؛ سامانه آن را به‌صورت جریانی بارگذاری، SHA-256 آن را محاسبه، ساختار و شناسه محصول را بررسی و سپس با همان Updater مستقل نصب می‌کند.

## فرایند کاربر

1. ورود به پنل Super
2. انتخاب «نصب بسته آفلاین (USB/ZIP)»
3. انتخاب فایل `dideban-update-x.y.z.zip`
4. تأیید نسخه نمایش‌داده‌شده
5. بکاپ، نصب و Restart خودکار

هیچ لینک، هش، نسخه یا مسیر به‌صورت دستی وارد نمی‌شود.

## کنترل‌های امنیتی

- توکن یک‌بارمصرف با اعتبار ۱۰ دقیقه
- بارگذاری جریانی بدون نگهداری کل فایل در RAM
- محدودیت حجم پیش‌فرض ۱ گیگابایت
- پذیرش فقط ZIP
- محاسبه SHA-256 هنگام دریافت
- وجود `update-package.json`
- بررسی `productId=com.dideban.platform`
- هماهنگی نسخه Manifest و `package.json`
- کنترل مسیر payload
- حفظ مسیرهای داده و تنظیمات
- بکاپ و Rollback توسط Updater

## ساخت بسته

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-update-package.ps1 -Version 1.0.1
```

فایل ساخته‌شده در پوشه `release` هم برای GitHub Release و هم برای USB قابل استفاده است.
