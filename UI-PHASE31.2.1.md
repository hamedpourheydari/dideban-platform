# Phase 31.2.1 — Development Node Runtime Fallback

The Windows service wrapper now resolves Node.js in this order:

1. `DIDEBAN_NODE_EXE` environment variable
2. `<appdir>\runtime\node.exe` (production installer)
3. `<appdir>\node.exe`
4. `node.exe` found in the Windows `PATH` (development mode)

This keeps production installations pinned to the bundled runtime while allowing console testing directly from the source repository.
