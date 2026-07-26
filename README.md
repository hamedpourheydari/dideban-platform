<div align="center">

<p align="center">
  <img src="docs/images/banner.png" alt="Dideban Platform Banner" width="100%">
</p>

# دیده‌بان | Dideban Platform

### Enterprise Video Management System (VMS / NVR)

Modern, Persian-first Video Surveillance Platform built on the Shinobi Engine.

<p>

![License](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)
![Node.js](https://img.shields.io/badge/Node.js-18+-green)
![Platform](https://img.shields.io/badge/Linux-Windows-lightgrey)
![Version](https://img.shields.io/badge/version-1.0-orange)

</p>

A modern enterprise Video Management System with a redesigned Persian-first user experience.

</div>

---

# Overview

Dideban Platform is a modern Video Management System (VMS/NVR) designed for enterprise surveillance systems.

Built on the powerful Shinobi engine, Dideban focuses on improving usability, localization, and visual design while preserving the mature and reliable backend.

The project introduces a redesigned dashboard, Persian RTL interface, cleaner workflows and an enterprise-grade user experience suitable for organizations and security operations centers.

---

# Highlights

- 🇮🇷 Persian First (RTL)
- 🎥 Multi Camera Monitoring
- 📹 RTSP Streaming
- 🔍 ONVIF Discovery
- 💾 Continuous Recording
- 🚨 Motion Detection
- 📁 Event Management
- 👥 Multi User Support
- ⚡ Live Dashboard
- 🖥 Linux & Windows
- 🎨 Modern Enterprise UI

---

# Screenshots

## Dashboard

<p align="center">
<img src="docs/images/dashboard.png" width="90%">
</p>

---

## Monitor Management

<p align="center">
<img src="docs/images/monitor.png" width="90%">
</p>

---

## Archive

<p align="center">
<img src="docs/images/archive.png" width="90%">
</p>

---

## Events

<p align="center">
<img src="docs/images/events.png" width="90%">
</p>

---

# Why Dideban?

Compared to the original Shinobi interface, Dideban introduces:

| Shinobi | Dideban |
|---------|----------|
| Classic UI | Modern Enterprise UI |
| English-first | Persian-first |
| Traditional Layout | Redesigned Dashboard |
| Generic Branding | Dideban Identity |
| Legacy Components | Modern Components |
| Basic UX | Enterprise UX |

---

# Architecture

```
IP Cameras
      │
      ▼
 ONVIF / RTSP
      │
      ▼
 Shinobi Engine
      │
      ▼
 Dideban Platform
      │
 ├──────── Dashboard
 ├──────── Archive
 ├──────── Events
 ├──────── Users
 └──────── Live View
```

---

# Technology Stack

| Layer | Technology |
|--------|------------|
| Backend | Node.js |
| Database | MariaDB / MySQL |
| Streaming | FFmpeg |
| Frontend | HTML + CSS + JavaScript |
| Realtime | Socket.IO |
| Camera Protocols | RTSP / ONVIF |

---

# Installation

## Requirements

- Node.js 18+
- FFmpeg
- MariaDB / MySQL

Clone repository

```bash
git clone https://github.com/hamedpourheydari/dideban-platform.git
cd dideban-platform
```

Install dependencies

```bash
npm install
```

Start

```bash
node camera.js
```

---

# Project Structure

```
camera.js
conf.sample.json
languages/
definitions/
plugins/
web/
libs/
```

---

# Roadmap

## Version 1.0

- ✅ Persian Localization
- ✅ Branding
- ✅ Dashboard Redesign
- ✅ Sidebar Redesign
- ✅ Statistics Widgets

---

## Version 1.1

- ⏳ Camera Wizard
- ⏳ Monitor Editor
- ⏳ Settings Redesign
- ⏳ User Management

---

## Version 1.2

- ⏳ Archive
- ⏳ Timeline
- ⏳ Playback
- ⏳ Search

---

## Version 2.0

- ⏳ Theme Engine
- ⏳ Widget System
- ⏳ Plugin Marketplace
- ⏳ Dashboard Personalization

---

# Contributing

Contributions are welcome.

1. Fork the project
2. Create your feature branch
3. Commit your changes
4. Push the branch
5. Open a Pull Request

---

# Credits

Dideban Platform is built upon the Shinobi Open Source NVR engine.

Special thanks to the Shinobi developers and community.

---

# License

This project is derived from Shinobi.

Please ensure that all license obligations of the upstream project are respected.

See the LICENSE file for details.

---

<div align="center">

## Dideban Platform

Enterprise Video Management System

Built on Shinobi

Made with ❤️ in Iran

</div>