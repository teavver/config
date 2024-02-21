#!/bin/bash

BASE_BACKUP_DIR="$HOME/preferences_backup"
CURRENT_DATE=$(date "+%d.%m.%Y")
BACKUP_DIR="${BASE_BACKUP_DIR}_${CURRENT_DATE}"

PREFERENCES_DIRS=(
  "$HOME/Library/Preferences"
  "/Library/Preferences"
)

mkdir -p "$BACKUP_DIR"

for dir in "${PREFERENCES_DIRS[@]}"; do
  rsync -avz "$dir" "$BACKUP_DIR"
done

# cleanup
CURRENT_TIME=$(date "+%H:%M:%S")
echo "Backup completed successfully at $CURRENT_TIME."
