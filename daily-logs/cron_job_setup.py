#!/usr/bin/env python3
"""
Setup cron job for daily commits (Windows Task Scheduler alternative)
Since we're on Windows, this script creates a scheduled task instead of cron
"""

import subprocess
import sys
from pathlib import Path

def create_windows_task():
    """Create Windows scheduled task for daily commits"""
    script_dir = Path(__file__).parent.absolute()
    script_path = script_dir / "daily_commit.py"

    task_name = "DailyLogsCommit"

    # Windows Task Scheduler command
    # Run daily at 00:00 UTC (convert to local time as needed)
    command = f'''schtasks /create /tn "{task_name}" /tr "python \\"{script_path}\\"" /sc daily /st 00:00 /f'''

    print("Creating Windows Scheduled Task...")
    print(f"Task name: {task_name}")
    print(f"Script: {script_path}")
    print(f"Schedule: Daily at 00:00")

    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
        print("✅ Scheduled task created successfully!")
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to create scheduled task: {e}")
        print(f"Error output: {e.stderr}")
        return False

def create_cron_job():
    """Create cron job for Unix-like systems"""
    script_dir = Path(__file__).parent.absolute()
    cron_entry = f"0 0 * * * cd '{script_dir}' && python3 daily_commit.py >> cron.log 2>&1"

    print("Adding cron job...")
    print(f"Cron entry: {cron_entry}")

    try:
        # Get current crontab
        result = subprocess.run("crontab -l", shell=True, capture_output=True, text=True)
        current_crontab = result.stdout if result.returncode == 0 else ""

        # Check if entry already exists
        if "daily_commit.py" in current_crontab:
            print("⚠️ Cron job already exists")
            return True

        # Add new entry
        new_crontab = current_crontab + f"\n{cron_entry}\n"

        # Set new crontab
        process = subprocess.Popen("crontab -", shell=True, stdin=subprocess.PIPE, text=True)
        process.communicate(input=new_crontab)

        if process.returncode == 0:
            print("✅ Cron job added successfully!")
            return True
        else:
            print("❌ Failed to add cron job")
            return False

    except Exception as e:
        print(f"❌ Error setting up cron job: {e}")
        return False

def main():
    """Main function"""
    print("=" * 50)
    print("CRON JOB SETUP")
    print("=" * 50)

    # Detect operating system
    if sys.platform.startswith('win'):
        print("Windows detected - using Task Scheduler")
        success = create_windows_task()
    else:
        print("Unix-like system detected - using cron")
        success = create_cron_job()

    if success:
        print("\n🎉 Automated daily commits are now scheduled!")
        print("The script will run every day at 00:00 UTC")
    else:
        print("\n❌ Failed to setup automated scheduling")
        print("You may need to run this script as administrator/root")

if __name__ == "__main__":
    main()