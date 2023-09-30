#!/bin/bash

# Set the trash directory
TRASH_DIR="$HOME/.trash"

# Create the trash directory if it doesn't exist
if [ ! -d "$TRASH_DIR" ]; then
  mkdir -p "$TRASH_DIR"
fi

# Move the files to the trash directory
for file in "$@"; do
  mv -i "$file" "$TRASH_DIR"
done

# Clear the trash directory on system startup or every 7 days
if [ "$(id -u)" = "0" ]; then
  echo "0 0 * * * rm -rf $TRASH_DIR/*" > /etc/cron.d/trash
else
  (crontab -l 2>/dev/null; echo "0 0 * * * rm -rf $TRASH_DIR/*") | crontab -
fi