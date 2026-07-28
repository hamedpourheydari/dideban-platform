# Phase 30.1 - Health Check Hang Fix

- Health check errors are now returned to the Super panel instead of leaving the UI waiting.
- Removed blocking `ffmpeg -version` execution from the synchronous health check.
- FFmpeg is detected from configured paths, bundled paths, or the operating-system PATH.
- Added a 15-second client timeout with a visible error message.
- Support-center request timers are cleared after success or failure.
