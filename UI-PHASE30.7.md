# Phase 30.7 — Support and System Cards Side by Side

Only the layout of `web/pages/super.ejs` was changed.

- The existing `#support_center` and `#system` cards now share one full-width row.
- Both cards retain their original IDs, classes, buttons, attributes, and JavaScript hooks.
- No backend, route, WebSocket, HTTP endpoint, or button behavior was changed.
- On screens narrower than 900px, the cards stack vertically.
