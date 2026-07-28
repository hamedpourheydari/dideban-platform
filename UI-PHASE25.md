# Dideban UI Phase 25 — Software Update Center

## قابلیت‌ها
- کارت «به‌روزرسانی نرم‌افزار» در پنل Super
- نمایش نسخه نصب‌شده از `package.json`
- بررسی فایل Manifest از سرور انتشار
- مقایسه نسخه‌ها و نمایش وضعیت به فارسی
- نمایش تغییرات نسخه جدید
- ثبت نتیجه بررسی در System Logs

## محدوده ایمنی فاز 25
این فاز فقط اطلاعات نسخه را بررسی و نمایش می‌دهد. هیچ فایل برنامه، تنظیمات، دیتابیس، ویدئو یا فایل کاربر را تغییر نمی‌دهد.

## نشانی Manifest
مقدار پیش‌فرض:

`https://raw.githubusercontent.com/hamedpourheydari/dideban-platform/main/update.json`

برای سرور اختصاصی، در `conf.json` اضافه شود:

```json
"didebanUpdate": {
  "manifestUrl": "https://updates.example.com/dideban/update.json"
}
```

یا متغیر محیطی `DIDEBAN_UPDATE_MANIFEST_URL` تنظیم شود.

فقط HTTPS پذیرفته می‌شود؛ HTTP صرفاً برای localhost در محیط توسعه مجاز است.
