#!/usr/bin/env python3
"""
Daily Commit Script
Automatically updates log.txt with timestamp and commits to Git repository
"""

import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path

def run_git_command(command):
    """Run git command and return result"""
    try:
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            check=True,
            cwd=Path(__file__).parent
        )
        return True, result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return False, e.stderr.strip()

def main():
    """Main function to perform daily commit"""
    print("=" * 50)
    print("DAILY COMMIT SCRIPT")
    print("=" * 50)

    # Get script directory
    script_dir = Path(__file__).parent.absolute()
    log_file = script_dir / "log.txt"

    print(f"Working directory: {script_dir}")
    print(f"Log file: {log_file}")

    # Change to script directory
    os.chdir(script_dir)

    # Get current UTC datetime
    utc_now = datetime.utcnow()
    timestamp = utc_now.strftime("%Y-%m-%d %H:%M:%S UTC")
    commit_timestamp = utc_now.strftime("%Y%m%d_%H%M%S")

    print(f"Current UTC time: {timestamp}")

    # Step 1: Update log.txt
    try:
        print("Updating log.txt...")
        with open(log_file, "a", encoding="utf-8") as f:
            f.write(f"\nUpdate at {timestamp}")
        print("Log file updated successfully")
    except Exception as e:
        print(f"Error updating log file: {e}")
        return False

    # Step 2: Git add log.txt
    print("Adding log.txt to git...")
    success, output = run_git_command("git add log.txt")
    if not success:
        print(f"Git add failed: {output}")
        return False
    print("File added to git successfully")

    # Step 3: Git commit
    commit_message = f"update {commit_timestamp}"
    print(f"Committing with message: '{commit_message}'")
    success, output = run_git_command(f'git commit -m "{commit_message}"')
    if not success:
        if "nothing to commit" in output.lower():
            print("ℹ️ Nothing to commit")
            return True
        else:
            print(f"Git commit failed: {output}")
            return False
    print("Changes committed successfully")

    # Step 4: Git push to main branch
    print("Pushing to origin main...")
    success, output = run_git_command("git push origin main")
    if not success:
        print(f"Git push failed: {output}")
        return False
    print("Changes pushed to GitHub successfully")

    print("Daily commit completed successfully!")
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\nScript interrupted")
        sys.exit(1)
    except Exception as e:
        print(f"\nError: {e}")
        sys.exit(1)