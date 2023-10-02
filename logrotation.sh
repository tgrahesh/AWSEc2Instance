#!/bin/bash
set -x
# Define log directory and backup directory
LOG_DIR="/var/log/apache2"
BACKUP_DIR="/home/ubuntu/apache2-backup"

# Define log file and backup prefix
LOG_FILE="access.log"
BACKUP_PREFIX="access_log_"

# Define retention period in days
RETENTION_DAYS=7

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get the current date in YYYYMMDD format
CURRENT_DATE=$(date "+%Y%m%d")

# Calculate the date for log rotation (subtract RETENTION_DAYS)
ROTATE_DATE=$(date -d "$RETENTION_DAYS days ago" "+%Y%m%d")

# Check if the log file exists
if [ -e "$LOG_DIR/$LOG_FILE" ]; then
  # Rotate logs if it's a new day
  if [ "$CURRENT_DATE" != "$ROTATE_DATE" ]; then
    # Rename the log file with the current date
    cp "$LOG_DIR/$LOG_FILE" "$BACKUP_DIR/$BACKUP_PREFIX$ROTATE_DATE.log"

    # Compress old log files
    find "$BACKUP_DIR" -name "$BACKUP_PREFIX*.log" -mtime +$RETENTION_DAYS -exec gzip {} \;
fi

else
  echo "Error: Log file not found."
  exit 1
fi

# Delete old backup files that exceed the retention period
find "$BACKUP_DIR" -name "$BACKUP_PREFIX*.gz" -mtime +$RETENTION_DAYS -delete

# Exit successfully
exit 0