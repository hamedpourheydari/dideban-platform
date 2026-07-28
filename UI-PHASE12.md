# Dideban UI Phase 12

## Super configuration redesign

- Replaced the default raw JSON editor with categorized configuration forms.
- Added tabs for General, Database, Storage, Mail, and Advanced settings.
- Password fields are masked and can be revealed temporarily.
- Added dynamic secondary storage management.
- Preserved unknown configuration keys when standard fields are saved.
- Kept direct `conf.json` editing behind an explicit advanced warning.
- Added JSON validation and save confirmation.
- Retained the UTF-8 BOM-safe configuration parser in `camera.js`.
