# Dideban UI Phase 26 — Secure Update Download

- دانلود بسته به‌روزرسانی از HTTPS
- نمایش پیشرفت دانلود در پنل Super
- محدودیت حجم دانلود
- بررسی SHA-256 پیش از آماده‌سازی
- ذخیره فایل تأییدشده در `updates/downloads`
- عدم نصب یا جایگزینی فایل‌ها در این فاز
- ثبت نتیجه در System Log

برای فعال شدن دکمه دانلود، `downloadUrl` و `sha256` معتبر باید در `update.json` منتشر شوند.
