# راهنمای نصب دیده‌بان روی ویندوز

این راهنما مراحل نصب و اجرای پروژه **دیده‌بان (Dideban)** روی Windows را توضیح می‌دهد و همچنین روش رفع خطاهای رایج اتصال MySQL را پوشش می‌دهد.

> نکته امنیتی: فایل `conf.json` شامل رمز دیتابیس و سایر اطلاعات حساس است و نباید در Git یا GitHub ثبت شود. برای ساخت آن از `conf.sample.json` استفاده کنید.

---

## 1. پیش‌نیازها

پیش از شروع، موارد زیر را نصب کنید:

- Git
- Node.js
- MySQL Server 8
- FFmpeg

برای بررسی نصب Node.js و Git:

```powershell
node --version
npm --version
git --version
```

برای بررسی MySQL، در صورت اضافه‌بودن به PATH:

```powershell
mysql --version
```

اگر دستور `mysql` شناخته نشد، می‌توانید از مسیر کامل استفاده کنید:

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --version
```

---

## 2. دریافت پروژه

مخزن را Clone کنید:

```powershell
git clone https://github.com/hamedpourheydari/dideban-platform.git
cd dideban-platform
```

اگر پروژه را به‌صورت ZIP دریافت کرده‌اید، آن را Extract کرده و PowerShell را در پوشه اصلی پروژه باز کنید.

---

## 3. نصب وابستگی‌های Node.js

در پوشه پروژه اجرا کنید:

```powershell
npm install
```

اگر پروژه وابستگی‌ها را در پوشه والد نگهداری می‌کند، مطمئن شوید دستور را در همان مسیری اجرا می‌کنید که فایل `package.json` قرار دارد.

---

## 4. ساخت فایل تنظیمات

فایل نمونه را کپی کنید:

```powershell
Copy-Item .\conf.sample.json .\conf.json
```

سپس فایل را باز کنید:

```powershell
notepad .\conf.json
```

بخش دیتابیس باید مشابه نمونه زیر باشد:

```json
"db": {
  "host": "127.0.0.1",
  "user": "dideban",
  "password": "YOUR_DATABASE_PASSWORD",
  "database": "ccio",
  "port": 3306
}
```

در نصب فارسی، این مقدار نیز پیشنهاد می‌شود:

```json
"language": "fa"
```

رمز `YOUR_DATABASE_PASSWORD` را با یک رمز قوی جایگزین کنید. همین رمز باید برای کاربر MySQL نیز تنظیم شود.

---

## 5. ورود به MySQL

با حساب مدیریتی MySQL وارد شوید:

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p
```

رمز حساب `root` را وارد کنید.

بعد از ورود موفق، خط فرمان باید از حالت PowerShell:

```text
PS C:\...
```

به حالت زیر تغییر کند:

```text
mysql>
```

دستورهای SQL مانند `CREATE USER`، `ALTER USER` و `GRANT` فقط باید داخل محیط `mysql>` اجرا شوند، نه مستقیماً داخل PowerShell.

هشدار زیر در برخی نسخه‌های فارسی ویندوز ممکن است نمایش داده شود:

```text
mysql: Unknown OS character set 'cp720'.
mysql: Switching to the default character set 'utf8mb4'.
```

این هشدار معمولاً مانع اتصال نمی‌شود و قابل چشم‌پوشی است.

---

## 6. ساخت دیتابیس و کاربر MySQL

داخل محیط `mysql>` دستورات زیر را اجرا کنید. رمز نمونه را با همان رمزی که در `conf.json` نوشته‌اید جایگزین کنید:

```sql
CREATE DATABASE IF NOT EXISTS ccio
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'dideban'@'localhost'
IDENTIFIED BY 'YOUR_DATABASE_PASSWORD';

CREATE USER IF NOT EXISTS 'dideban'@'127.0.0.1'
IDENTIFIED BY 'YOUR_DATABASE_PASSWORD';

GRANT ALL PRIVILEGES ON ccio.* TO 'dideban'@'localhost';
GRANT ALL PRIVILEGES ON ccio.* TO 'dideban'@'127.0.0.1';

FLUSH PRIVILEGES;
```

اگر حساب‌ها از قبل وجود دارند، رمز هر دو حساب را هماهنگ کنید:

```sql
ALTER USER 'dideban'@'localhost'
IDENTIFIED BY 'YOUR_DATABASE_PASSWORD';

ALTER USER 'dideban'@'127.0.0.1'
IDENTIFIED BY 'YOUR_DATABASE_PASSWORD';

GRANT ALL PRIVILEGES ON ccio.* TO 'dideban'@'localhost';
GRANT ALL PRIVILEGES ON ccio.* TO 'dideban'@'127.0.0.1';

FLUSH PRIVILEGES;
```

برای بررسی حساب‌ها:

```sql
SELECT User, Host, plugin
FROM mysql.user
WHERE User = 'dideban';
```

برای بررسی سطح دسترسی:

```sql
SHOW GRANTS FOR 'dideban'@'localhost';
SHOW GRANTS FOR 'dideban'@'127.0.0.1';
```

برای خروج از MySQL:

```sql
EXIT;
```

---

## 7. آزمایش ورود مستقیم به MySQL

از PowerShell اجرا کنید:

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u dideban -p -h 127.0.0.1 ccio
```

رمزی را وارد کنید که در `conf.json` قرار داده‌اید.

اگر ورود موفق بود، اجرا کنید:

```sql
EXIT;
```

---

## 8. بررسی اینکه رمز از conf.json خوانده می‌شود

در پوشه پروژه اجرا کنید:

```powershell
node -e "const c=require('./conf.json'); console.log({host:c.db.host,user:c.db.user,database:c.db.database,passwordLength:(c.db.password||'').length})"
```

خروجی صحیح باید `passwordLength` بزرگ‌تر از صفر داشته باشد:

```text
{
  host: '127.0.0.1',
  user: 'dideban',
  database: 'ccio',
  passwordLength: 21
}
```

اگر خروجی این بود:

```text
passwordLength: 0
```

یعنی فایل `conf.json` فعلی هنوز رمز خالی دارد، تغییرات ذخیره نشده‌اند یا فایل دیگری را ویرایش کرده‌اید.

مسیر فایل واقعی را بررسی کنید:

```powershell
Resolve-Path .\conf.json
```

مقدار رمز را بدون نمایش کامل تنظیمات بررسی کنید:

```powershell
Get-Content .\conf.json | Select-String '"password"'
```

برای تنظیم رمز از طریق PowerShell:

```powershell
$config = Get-Content .\conf.json -Raw | ConvertFrom-Json
$config.db.password = "YOUR_DATABASE_PASSWORD"
$config | ConvertTo-Json -Depth 20 | Set-Content .\conf.json -Encoding UTF8
```

سپس آزمایش `passwordLength` را دوباره اجرا کنید.

---

## 9. آزمایش اتصال Node.js به MySQL

در پوشه پروژه اجرا کنید:

```powershell
node -e "const mysql=require('mysql2');const c=require('./conf.json').db;const x=mysql.createConnection(c);x.connect(e=>{console.log(e||'DATABASE CONNECTION OK');x.end()})"
```

خروجی موفق:

```text
DATABASE CONNECTION OK
```

---

## 10. رفع خطاهای احراز هویت MySQL

### خطای using password: NO

```text
Access denied for user 'dideban'@'localhost' (using password: NO)
```

معنی خطا:

- برنامه هیچ رمزی برای MySQL ارسال نمی‌کند.
- مقدار `db.password` در `conf.json` خالی است.
- فایل تنظیمات اشتباه ویرایش شده یا ذخیره نشده است.

راه‌حل:

1. مقدار `password` را در `conf.json` وارد کنید.
2. فایل را ذخیره کنید.
3. دستور بررسی `passwordLength` را اجرا کنید.
4. برنامه را مجدداً راه‌اندازی کنید.

### خطای using password: YES

```text
Access denied for user 'dideban'@'localhost' (using password: YES)
```

معنی خطا:

- برنامه رمز ارسال می‌کند.
- ولی رمز ثبت‌شده در MySQL با رمز `conf.json` یکسان نیست.
- یا مجوز کاربر برای دیتابیس `ccio` کافی نیست.

راه‌حل:

داخل محیط MySQL رمز و مجوزهای هر دو حساب را اصلاح کنید:

```sql
ALTER USER 'dideban'@'localhost'
IDENTIFIED BY 'YOUR_DATABASE_PASSWORD';

ALTER USER 'dideban'@'127.0.0.1'
IDENTIFIED BY 'YOUR_DATABASE_PASSWORD';

GRANT ALL PRIVILEGES ON ccio.* TO 'dideban'@'localhost';
GRANT ALL PRIVILEGES ON ccio.* TO 'dideban'@'127.0.0.1';

FLUSH PRIVILEGES;
```

سپس اتصال Node.js را دوباره آزمایش کنید.

---

## 11. اجرای دیده‌بان

در پوشه پروژه:

```powershell
node camera.js
```

خروجی موفق باید مشابه زیر باشد:

```text
دیده بان - PORT : 8080
دیده‌بان آماده استفاده است.
```

پنل به‌صورت پیش‌فرض از این آدرس در دسترس است:

```text
http://localhost:8080
```

---

## 12. رفع مشکل ثبت‌نشدن کاربر

اگر کاربر در پنل ساخته می‌شود ولی بعد از Refresh ناپدید می‌شود، معمولاً عملیات `INSERT` در MySQL شکست خورده است.

ابتدا اتصال را بررسی کنید:

```powershell
node -e "const mysql=require('mysql2');const c=require('./conf.json').db;const x=mysql.createConnection(c);x.connect(e=>{console.log(e||'DATABASE CONNECTION OK');x.end()})"
```

اگر در نسخه دارای گزارش تشخیصی، خروجی زیر دیده شد، ثبت موفق است:

```text
=== INSERT USER ===
ERR = null
RESULT = ResultSetHeader ...
```

اگر `ERR` شامل `ER_ACCESS_DENIED_ERROR` باشد، مراحل تنظیم رمز و مجوز MySQL را دوباره انجام دهید.

---

## 13. نکات امنیتی Git

بررسی کنید `conf.json` توسط Git نادیده گرفته می‌شود:

```powershell
git check-ignore -v conf.json
```

خروجی مورد انتظار:

```text
.gitignore:44:/conf.json        conf.json
```

فایل نمونه باید در مخزن باشد:

```text
conf.sample.json
```

ولی فایل واقعی نباید Commit شود:

```text
conf.json
```

قبل از Commit بررسی کنید رمز واقعی وارد فایل‌های قابل ردیابی نشده باشد:

```powershell
git grep -n "YOUR_REAL_DATABASE_PASSWORD"
```

در صورت امن‌بودن مخزن، این دستور نباید خروجی داشته باشد.

---

## 14. خطاها و هشدارهای غیرمسدودکننده

هشدارهای مربوط به circular dependency یا APIهای deprecated در برخی نسخه‌های جدید Node.js ممکن است نمایش داده شوند، مانند:

```text
Warning: Accessing non-existent property ...
DeprecationWarning: The util.isArray API is deprecated.
```

اگر برنامه اجرا می‌شود و اتصال دیتابیس موفق است، این موارد معمولاً دلیل خطای احراز هویت یا ثبت کاربر نیستند.

---

## چک‌لیست نهایی

- [ ] Node.js، Git، MySQL و FFmpeg نصب شده‌اند.
- [ ] وابستگی‌ها با `npm install` نصب شده‌اند.
- [ ] فایل `conf.json` از روی `conf.sample.json` ساخته شده است.
- [ ] رمز `conf.json` خالی نیست.
- [ ] دیتابیس `ccio` وجود دارد.
- [ ] کاربران `dideban@localhost` و `dideban@127.0.0.1` وجود دارند.
- [ ] رمز MySQL و `conf.json` یکسان است.
- [ ] کاربر `dideban` روی `ccio.*` مجوز دارد.
- [ ] آزمایش Node.js پیام `DATABASE CONNECTION OK` می‌دهد.
- [ ] برنامه با `node camera.js` اجرا می‌شود.
- [ ] `conf.json` در `.gitignore` قرار دارد.
