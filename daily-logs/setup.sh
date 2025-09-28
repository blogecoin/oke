#!/bin/bash

echo "=================================="
echo "DAILY LOGS REPOSITORY SETUP"
echo "=================================="

# Get current directory
REPO_DIR=$(pwd)
echo "📁 Repository directory: $REPO_DIR"

# Check if we're in a Git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a Git repository"
    echo "Run 'git init' first"
    exit 1
fi

echo "✅ Git repository detected"

# Configure Git user (prompt for input)
echo ""
echo "🔧 Git Configuration"
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

git config user.name "$git_username"
git config user.email "$git_email"

echo "✅ Git user configured: $git_username <$git_email>"

# Setup SSH key if not exists
SSH_KEY="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
    echo ""
    echo "🔑 SSH Key Setup"
    echo "No SSH key found. Generating new SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$git_email" -f "$SSH_KEY" -N ""
    echo "✅ SSH key generated"

    echo ""
    echo "📋 Your SSH public key (add this to GitHub):"
    echo "============================================"
    cat "$SSH_KEY.pub"
    echo "============================================"
    echo ""
    echo "Go to GitHub → Settings → SSH and GPG keys → New SSH key"
    echo "Paste the above key and save it"
    echo ""
    read -p "Press ENTER after adding the SSH key to GitHub..."
else
    echo "✅ SSH key already exists"
fi

# Setup remote origin
echo ""
echo "🌐 Remote Repository Setup"
read -p "Enter your GitHub repository URL (SSH format: git@github.com:username/repo.git): " repo_url

# Remove existing origin if exists
git remote remove origin 2>/dev/null

# Add new origin
git remote add origin "$repo_url"
echo "✅ Remote origin added: $repo_url"

# Test SSH connection
echo ""
echo "🔍 Testing SSH connection to GitHub..."
ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
if [ $? -eq 0 ]; then
    echo "✅ SSH connection successful"
else
    echo "⚠️ SSH connection failed - please check your SSH key setup"
fi

# Create initial commit
echo ""
echo "💾 Creating initial commit..."
git add .
git commit -m "Initial commit - Daily logs setup"

# Push to GitHub
echo ""
echo "🚀 Pushing to GitHub..."
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ Repository pushed successfully"
else
    echo "❌ Push failed - please check your repository URL and SSH setup"
    exit 1
fi

# Test the daily commit script
echo ""
echo "🧪 Testing daily commit script..."
python3 daily_commit.py

if [ $? -eq 0 ]; then
    echo "✅ Daily commit script test successful"
else
    echo "❌ Daily commit script test failed"
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Run './cron_setup.sh' to setup the daily cron job"
echo "2. The script will run automatically every day at 00:00 UTC"
echo ""