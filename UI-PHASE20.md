# UI Phase 20 — Reliable instruction attachment upload

- Removed the fragile chunk/acknowledgement path from the Super instruction form.
- Attachments are now sent with the normal instruction save request as a Data URL.
- Increased Socket.IO `maxHttpBufferSize` to 20 MB so a 10 MB file plus Base64/JSON overhead is accepted.
- Existing server-side extension, size, path and filename validation remains active.
- The form now reports when reading is complete and the file is being persisted.
