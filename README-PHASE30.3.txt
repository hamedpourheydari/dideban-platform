Dideban Phase 30.3 - System Health HTTP Fix

Changed only:
- camera.js
- web/pages/super.ejs

The health-check button now calls an authenticated HTTP endpoint:
POST /dideban-system-health

Other Support Center, update, rollback, and offline update features are unchanged.

After copying files:
1. Stop Node.js with Ctrl+C
2. Run: node camera.js
3. Refresh Super page with Ctrl+F5
