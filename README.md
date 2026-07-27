<div align="center">

<!--
برای نمایش بنر، تصویر واقعی پروژه را در مسیر زیر قرار دهید:
docs/images/banner.png
-->
<img src="docs/images/banner.png" alt="Dideban Platform Banner" width="100%">

# دیده‌بان | Dideban Platform

### سامانه مدیریت ویدئو و ضبط تصاویر تحت شبکه  
### Video Management System (VMS / NVR)

A modern, self-hosted and Persian-first video surveillance platform built on the Shinobi engine.

<br>

[![Status](https://img.shields.io/badge/status-active%20development-orange)](#roadmap)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows-blue)](#requirements)
[![Node.js](https://img.shields.io/badge/runtime-Node.js-green)](#technology-stack)
[![Persian UI](https://img.shields.io/badge/UI-Persian%20RTL-6f42c1)](#معرفی-فارسی)
[![License](https://img.shields.io/badge/license-see%20LICENSE-lightgrey)](#license)

[English](#overview) • [فارسی](#معرفی-فارسی) • [Installation](#installation) • [نصب](#نصب-و-راه‌اندازی) • [Roadmap](#roadmap)

</div>

---

## Overview

**Dideban Platform** is a self-hosted Video Management System (VMS/NVR) for centralized monitoring, recording and management of IP cameras.

The project is built on the Shinobi surveillance engine and introduces a redesigned Persian-first interface, right-to-left layout, Dideban branding and a more modern dashboard experience.

Dideban aims to preserve the mature camera and streaming capabilities of the upstream engine while improving localization, usability, visual consistency and readiness for organizational deployments.

### Project goals

- Persian-first and right-to-left user experience
- Modern and consistent dashboard design
- Centralized IP camera monitoring and management
- Maintainable and extensible codebase
- Clear documentation and incremental development
- Preparation for production and organizational environments

---

## معرفی فارسی

**دیده‌بان** یک سامانه متن‌باز و قابل‌استقرار روی سرور شخصی برای مدیریت ویدئو، مانیتورینگ زنده، ضبط تصاویر و مدیریت متمرکز دوربین‌های تحت شبکه است.

این پروژه بر پایه هسته **Shinobi** توسعه یافته و با هدف ارائه رابط کاربری فارسی، راست‌چین و مدرن بازطراحی شده است. در دیده‌بان تلاش می‌شود قابلیت‌های پایدار هسته اصلی حفظ شوند و در کنار آن، تجربه کاربری، برندسازی، مستندسازی و آمادگی برای استفاده سازمانی بهبود پیدا کند.

### اهداف اصلی پروژه

- ارائه رابط کاربری فارسی و راست‌چین
- ساده‌سازی مدیریت و مشاهده دوربین‌ها
- طراحی داشبورد مدرن و مناسب مراکز مانیتورینگ
- حفظ قابلیت‌های فنی هسته Shinobi
- توسعه تدریجی و مستند پروژه
- آماده‌سازی برای استقرار در محیط‌های حرفه‌ای و سازمانی

---

## Features

| Capability | Status |
|---|:---:|
| Persian user interface and RTL layout | ✅ |
| Dideban branding | ✅ |
| Redesigned dashboard and sidebar | ✅ |
| Multi-camera live monitoring | ✅ |
| Video recording and playback | ✅ |
| Web-based management panel | ✅ |
| Multi-user management | ✅ |
| RTSP camera streams | ✅ |
| FFmpeg-based media processing | ✅ |
| Linux and Windows support | ✅ |
| Monitor editor redesign | 🚧 |
| Archive and timeline redesign | 🚧 |
| Security review and production hardening | 🚧 |

> Some capabilities are provided by the underlying Shinobi engine. Dideban-specific interface and workflow improvements are being developed incrementally.

---

## قابلیت‌ها

- رابط کاربری فارسی و راست‌چین
- داشبورد و نوار کناری بازطراحی‌شده
- نمایش زنده هم‌زمان چند دوربین
- مدیریت متمرکز دوربین‌های تحت شبکه
- ضبط و بازپخش تصاویر
- پردازش جریان ویدئویی با FFmpeg
- مدیریت کاربران و دسترسی‌ها
- پنل مدیریتی تحت وب
- پشتیبانی از Linux و Windows
- توسعه مرحله‌ای صفحات آرشیو، رویدادها و تنظیمات دوربین

---

## Screenshots

> تصاویر این بخش باید اسکرین‌شات واقعی نرم‌افزار باشند و در پوشه `docs/images` قرار بگیرند.

### Dashboard

<div align="center">
  <img src="docs/images/dashboard.png" alt="Dideban Dashboard" width="92%">
</div>

### Monitor Management

<div align="center">
  <img src="docs/images/monitor.png" alt="Dideban Monitor Management" width="92%">
</div>

### Archive

<div align="center">
  <img src="docs/images/archive.png" alt="Dideban Archive" width="92%">
</div>

### Events

<div align="center">
  <img src="docs/images/events.png" alt="Dideban Events" width="92%">
</div>

Expected image structure:

```text
docs/
└── images/
    ├── banner.png
    ├── dashboard.png
    ├── monitor.png
    ├── archive.png
    └── events.png
```

---

## Why Dideban?

| Upstream Shinobi interface | Dideban Platform |
|---|---|
| General-purpose interface | Persian-first interface |
| Left-to-right oriented experience | Native RTL layout |
| Upstream branding | Dideban visual identity |
| Traditional dashboard | Redesigned monitoring workspace |
| Generic navigation | Localized and simplified navigation |
| Upstream documentation | Project-specific Persian and English documentation |

Dideban does not attempt to hide its upstream foundation. The project builds on Shinobi and focuses on localization, user experience, branding and deployment needs for Persian-speaking environments.

---

## Architecture

```text
IP Cameras
    │
    ├── RTSP
    └── ONVIF / Camera Discovery
    │
    ▼
┌───────────────────────────┐
│      Shinobi Engine       │
│ Streaming • Recording     │
│ Events • Users • Storage  │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│    Dideban Platform UI    │
│ Persian • RTL • Branding  │
└─────────────┬─────────────┘
              │
      ├── Dashboard
      ├── Live View
      ├── Monitor Management
      ├── Archive
      ├── Events
      ├── Users
      └── Settings
```

---

## Technology Stack

| Layer | Technology |
|---|---|
| Application runtime | Node.js |
| Database | MariaDB / MySQL |
| Media processing | FFmpeg / FFprobe |
| Frontend | EJS, HTML, CSS and JavaScript |
| Realtime communication | Socket.IO |
| Camera streaming | RTSP |
| Camera integration | Shinobi camera and ONVIF components |

---

## Requirements

Before installation, prepare the following components:

- Git
- Node.js and npm
- MariaDB or MySQL
- FFmpeg and FFprobe
- A supported Linux or Windows environment
- Network access to the IP cameras

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/hamedpourheydari/dideban-platform.git
cd dideban-platform
```

### 2. Install dependencies

```bash
npm install
```

### 3. Create the configuration file

Linux:

```bash
cp conf.sample.json conf.json
```

Windows PowerShell:

```powershell
Copy-Item conf.sample.json conf.json
```

Windows Command Prompt:

```cmd
copy conf.sample.json conf.json
```

Review `conf.json` and configure the database, application port and other environment-specific settings before starting the service.

### 4. Start Dideban

```bash
node camera.js
```

### 5. Open the management panel

```text
http://localhost:8080
```

> The actual address or port may be different if it has been changed in `conf.json`.

---

## نصب و راه‌اندازی

### ۱. دریافت پروژه

```bash
git clone https://github.com/hamedpourheydari/dideban-platform.git
cd dideban-platform
```

### ۲. نصب وابستگی‌ها

```bash
npm install
```

### ۳. ساخت فایل تنظیمات

در PowerShell ویندوز:

```powershell
Copy-Item conf.sample.json conf.json
```

در Linux:

```bash
cp conf.sample.json conf.json
```

سپس فایل `conf.json` را باز کرده و مشخصات پایگاه داده، پورت برنامه و سایر تنظیمات موردنیاز را وارد کنید.

### ۴. اجرای برنامه

```bash
node camera.js
```

### ۵. ورود به پنل

```text
http://localhost:8080
```

---

## FFmpeg Requirement

Dideban uses FFmpeg and FFprobe for stream processing, recording and media inspection.

The FFmpeg executables are not stored in this repository because they are large and operating-system dependent.

### Windows setup

Place these files in the `ffmpeg` directory at the project root:

```text
dideban-platform/
└── ffmpeg/
    ├── ffmpeg.exe
    └── ffprobe.exe
```

Verify the executables:

```powershell
.\ffmpeg\ffmpeg.exe -version
.\ffmpeg\ffprobe.exe -version
```

The `ffmpeg/` directory and downloaded archives are intentionally excluded from Git.

---

## پیش‌نیاز FFmpeg

دیده‌بان برای پردازش، ضبط و بررسی جریان‌های ویدئویی به `FFmpeg` و `FFprobe` نیاز دارد.

فایل‌های اجرایی FFmpeg به دلیل حجم بالا و وابستگی به سیستم‌عامل داخل مخزن نگهداری نمی‌شوند.

در ویندوز فایل‌های زیر را در پوشه `ffmpeg` در ریشه پروژه قرار دهید:

```text
dideban-platform/
└── ffmpeg/
    ├── ffmpeg.exe
    └── ffprobe.exe
```

برای بررسی نصب:

```powershell
.\ffmpeg\ffmpeg.exe -version
.\ffmpeg\ffprobe.exe -version
```

---

## Repository Structure

```text
dideban-platform/
├── definitions/        # Application definitions
├── docs/               # Documentation and screenshots
├── languages/          # Language and localization files
├── plugins/            # Optional plugins and integrations
├── sql/                # Database-related files
├── tools/              # Development and maintenance tools
├── web/                # Web interface, assets and frontend files
├── camera.js           # Main application entry point
├── conf.sample.json    # Sample application configuration
├── package.json        # Node.js dependencies and scripts
├── INSTALL.md          # Additional installation information
├── LICENSE             # License information
└── README.md           # Project overview
```

---

## Development Principles

- Persian-first design
- Security by design
- Incremental development
- Conventional Commits
- Continuous documentation
- Reviewable and reversible changes
- Preservation of upstream attribution and license obligations

---

## Roadmap

### v1.0.0 — Foundation and identity

- [x] Development environment
- [x] Persian localization
- [x] RTL interface improvements
- [x] Dideban branding
- [x] Dashboard redesign
- [x] Sidebar redesign
- [x] Dashboard statistics and quick actions
- [x] Dideban logo in the account area
- [x] Bilingual project README

### v1.1.0 — Camera management

- [ ] Camera setup wizard
- [ ] Monitor editor redesign
- [ ] Settings interface redesign
- [ ] User management interface improvements

### v1.2.0 — Archive and events

- [ ] Archive redesign
- [ ] Event timeline
- [ ] Playback improvements
- [ ] Search and filtering improvements

### v2.0.0 — Extended platform experience

- [ ] Complete interface design system
- [ ] Theme engine
- [ ] Custom dashboard widgets
- [ ] Dashboard personalization
- [ ] Plugin management experience
- [ ] Production hardening and extended security review

---

## Documentation

Project-specific documentation should be maintained in the `docs` directory.

Suggested documents:

```text
docs/
├── images/
├── architecture.md
├── installation.md
├── branding.md
├── development-log.md
├── security.md
├── testing.md
└── release-notes.md
```

---

## Contributing

Contributions, bug reports and improvement proposals are welcome.

1. Fork the repository.
2. Create a dedicated branch:

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Apply and test your changes.
4. Commit using a clear Conventional Commit message:

   ```bash
   git commit -m "feat: describe the new feature"
   ```

5. Push the branch:

   ```bash
   git push origin feature/your-feature-name
   ```

6. Open a Pull Request and explain the purpose and impact of the change.

For major changes, open an Issue before implementation so the design and technical approach can be discussed.

---

## Credits and Upstream

Dideban Platform is based on the **Shinobi Open Source NVR** project.

The camera management, streaming and recording foundation originates from the upstream Shinobi project. Dideban adds project-specific localization, branding, interface design and documentation.

Thanks to the Shinobi developers and contributors for building and maintaining the upstream surveillance platform.

---

## License

This repository contains `LICENSE` and `COPYING` files inherited from or associated with the upstream codebase.

Before distributing, modifying or deploying the project, review those files carefully and ensure that:

- Upstream copyright notices remain intact.
- Shinobi attribution is preserved.
- Source-distribution requirements are respected.
- Modified versions comply with all applicable upstream license terms.

This README is not a substitute for the legal terms contained in `LICENSE` and `COPYING`.

---

## Security

Dideban is currently under active development and should be reviewed before being exposed directly to the public internet.

For production use:

- Change all default credentials.
- Use HTTPS through a properly configured reverse proxy.
- Restrict access using firewall and network policies.
- Keep Node.js, FFmpeg, the database and dependencies updated.
- Review camera credentials and user permissions.
- Back up the database and recorded media.
- Perform a security review before organizational deployment.

---

<div align="center">

## Dideban Platform

**سامانه مدیریت ویدئو و نظارت تصویری دیده‌بان**

Built on the Shinobi engine  
Designed for a Persian-first monitoring experience

</div>
