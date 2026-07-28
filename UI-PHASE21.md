# Phase 21 – Instruction Attachment Download

- Adds a dedicated attachment download route.
- Adds explicit “has attachment” indicators in Super and user panels.
- Uses server-provided attachment URLs instead of relying on static web paths.
- Prevents path traversal by serving only files from `web/uploads/instructions`.
