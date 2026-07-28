# Phase 14 Fix 1 — Instruction Center database initialization

- Fixed a race condition where instruction queries could run before the tables were created.
- Reworked table initialization to use independent Knex schema builders.
- Added an automatic table-ensure wrapper before every instruction-center query.
- Removed database-specific timestamp defaults from the automatic migration.
- Added a unique read-state key for each instruction/user pair.
