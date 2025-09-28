# Daily Logs Repository

This repository automatically logs daily updates using a Python script.

## Files

- `log.txt` - Daily log file with timestamps
- `daily_commit.py` - Python script for automatic commits
- `setup.sh` - Setup script for initial configuration
- `cron_setup.sh` - Script to setup cron job

## Setup Instructions

### 1. Configure Git
```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### 2. Add SSH Remote Origin
```bash
git remote add origin git@github.com:username/daily-logs.git
```

### 3. Setup SSH Key (if not already configured)
```bash
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
cat ~/.ssh/id_rsa.pub
# Add this key to your GitHub SSH keys
```

### 4. Test Script
```bash
python daily_commit.py
```

### 5. Setup Cron Job
```bash
# Edit crontab
crontab -e

# Add this line to run daily at 00:00 UTC
0 0 * * * cd /path/to/daily-logs && python3 daily_commit.py >> cron.log 2>&1
```

## Script Functionality

The `daily_commit.py` script automatically:

1. Opens the repository directory
2. Appends "Update at [UTC datetime]" to log.txt
3. Runs `git add .`
4. Runs `git commit -m "update <datetime>"`
5. Runs `git push origin main`

## Log Format

Each entry in log.txt follows this format:
```
Update at YYYY-MM-DD HH:MM:SS UTC
```

## Cron Job

The cron job runs daily at 00:00 UTC and logs output to `cron.log` for debugging.