# Dideban UI Phase 23

## Instruction attachment completion-state fix

- Clears the attachment upload/save busy state after the server confirms `instruction_saved`.
- Shows an explicit success message after the attachment and instruction are persisted.
- Restores the save button and progress UI before closing the modal.
- Prevents the form from remaining on “uploading” or “saving” after a successful operation.
