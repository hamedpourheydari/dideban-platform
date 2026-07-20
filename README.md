# دیده‌بان | Dideban

> A modern video surveillance platform designed for secure monitoring, centralized camera management, and Persian-first user experience.

![Status](https://img.shields.io/badge/status-under%20development-orange)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-blue)

---

# Overview

Dideban is a self-hosted video surveillance platform developed to provide reliable camera monitoring, recording, and management capabilities.

The project is designed with a focus on:

- Persian-first user interface
- Right-to-left (RTL) support
- Modern and intuitive user experience
- Secure architecture
- High maintainability
- Enterprise-ready deployment

The project is currently under active development.

---

# Features

- 🎥 Live camera monitoring
- 📹 Video recording and playback
- 👥 Multi-user management
- 🔐 Secure authentication
- 🌐 Web-based management panel
- 🖥️ Cross-platform support
- 🇮🇷 Persian (RTL) interface
- ⚙️ Flexible configuration

---

# Current Progress

- ✅ Development environment configured
- ✅ Dependencies installed
- ✅ FFmpeg configured
- ✅ Server startup verified
- ✅ Git workflow established
- ✅ Initial Persian interface implementation
- ⏳ Complete UI redesign
- ⏳ Branding
- ⏳ Security review
- ⏳ Production release

---

# Repository Structure

```text
camera/
│
├── docs/
├── ffmpeg/
├── languages/
├── libs/
├── plugins/
├── web/
├── conf.json
├── camera.js
└── README.md
```

---

# Requirements

- Node.js
- FFmpeg
- Git

---

# Installation

Clone the repository

```bash
git clone https://github.com/hamedpourheydari/camera.git
```

Install dependencies

```bash
npm install
```

Create configuration

```bash
copy conf.sample.json conf.json
```

Run

```bash
node camera.js
```

Open

```
http://localhost:8080
```

---

# Documentation

Documentation is available in the `docs` directory.

Contents include:

- Development Log
- Software Architecture
- Installation Guide
- Branding Guide
- Test Reports
- Release Notes

---

# Development Principles

- Clean Architecture
- Continuous Documentation
- Conventional Commits
- Incremental Development
- Security by Design

---

# Roadmap

## Phase 1

- Environment setup
- Persian interface
- Branding

## Phase 2

- UI redesign
- Performance improvements
- Feature completion

## Phase 3

- Security hardening
- Production optimization
- Stable release

---

# License

This project is distributed under the terms described in the LICENSE file.


## پیش‌نیاز FFmpeg

دیده‌بان برای پردازش، ضبط و بررسی جریان‌های ویدئویی به FFmpeg نیاز دارد.

فایل‌های اجرایی FFmpeg به دلیل حجم بالا و وابستگی به سیستم‌عامل، داخل مخزن Git نگهداری نمی‌شوند.

### راه‌اندازی در ویندوز

نسخه مناسب FFmpeg را دانلود و استخراج کنید. سپس فایل‌های زیر را در پوشه `ffmpeg` در ریشه پروژه قرار دهید:

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

پوشه `ffmpeg/` و فایل‌های ZIP مربوط به آن به‌صورت عمدی توسط Git نادیده گرفته می‌شوند.