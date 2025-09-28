#!/bin/bash

echo "=================================="
echo "CRON JOB SETUP FOR DAILY COMMITS"
echo "=================================="

# Get absolute path to repository
REPO_DIR=$(pwd)
SCRIPT_PATH="$REPO_DIR/daily_commit.py"
LOG_PATH="$REPO_DIR/cron.log"

echo "📁 Repository: $REPO_DIR"
echo "🐍 Script: $SCRIPT_PATH"
echo "📄 Log file: $LOG_PATH"

# Check if script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "❌ daily_commit.py not found in current directory"
    exit 1
fi

# Check if Python3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ python3 not found. Please install Python 3"
    exit 1
fi

# Create cron job entry
CRON_ENTRY="0 0 * * * cd \"$REPO_DIR\" && python3 daily_commit.py >> \"$LOG_PATH\" 2>&1"

echo ""
echo "📋 Cron job entry:"
echo "$CRON_ENTRY"

# Backup existing crontab
echo ""
echo "💾 Backing up existing crontab..."
crontab -l > crontab_backup.txt 2>/dev/null || echo "No existing crontab found"

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "daily_commit.py"; then
    echo "⚠️ Daily commit cron job already exists"
    echo "Existing entries:"
    crontab -l | grep "daily_commit.py"
    echo ""
    read -p "Do you want to replace it? (y/N): " replace

    if [[ $replace =~ ^[Yy]$ ]]; then
        # Remove existing daily_commit entries
        crontab -l 2>/dev/null | grep -v "daily_commit.py" | crontab -
        echo "✅ Removed existing cron job"
    else
        echo "❌ Setup cancelled"
        exit 1
    fi
fi

# Add new cron job
echo ""
echo "📅 Adding cron job..."
(crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -

if [ $? -eq 0 ]; then
    echo "✅ Cron job added successfully"
else
    echo "❌ Failed to add cron job"
    exit 1
fi

# Display current crontab
echo ""
echo "📋 Current crontab:"
echo "==================="
crontab -l
echo "==================="

# Create log file if it doesn't exist
touch "$LOG_PATH"

# Test cron service
echo ""
echo "🔍 Checking cron service..."
if systemctl is-active --quiet cron 2>/dev/null; then
    echo "✅ Cron service is running"
elif systemctl is-active --quiet crond 2>/dev/null; then
    echo "✅ Crond service is running"
elif service cron status >/dev/null 2>&1; then
    echo "✅ Cron service is running"
else
    echo "⚠️ Cron service status unknown - please ensure cron is installed and running"
    echo "Ubuntu/Debian: sudo systemctl start cron"
    echo "CentOS/RHEL: sudo systemctl start crond"
fi

# Test the script manually
echo ""
echo "🧪 Testing script execution..."
cd "$REPO_DIR"
python3 daily_commit.py

if [ $? -eq 0 ]; then
    echo "✅ Script test successful"
else
    echo "❌ Script test failed - check the script for errors"
fi

echo ""
echo "🎉 Cron job setup completed!"
echo ""
echo "📊 Summary:"
echo "- Script runs daily at 00:00 UTC"
echo "- Logs are saved to: $LOG_PATH"
echo "- Backup of old crontab: crontab_backup.txt"
echo ""
echo "🔍 To monitor:"
echo "- Check logs: tail -f \"$LOG_PATH\""
echo "- View crontab: crontab -l"
echo "- Remove cron job: crontab -e (then delete the line)"
echo ""