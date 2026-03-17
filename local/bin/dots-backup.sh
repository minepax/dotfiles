#!/bin/bash

DOTS_DIR="$HOME/dotfiles"
CONF_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"

# 1. Sync files to the dotfiles folder
# We use rsync to efficiently copy only changed files
echo "Syncing configs..."
rsync -av --delete --exclude 'google-chrome' --exclude 'discord' "$CONF_DIR/waybar" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/konsave" "$DOTS_DIR/config/"
rsync -av --delete "$BIN_DIR/" "$DOTS_DIR/local/bin/"

# Add any other specific configs you want here
# Example: cp "$HOME/.zshrc" "$DOTS_DIR/"

# 2. Git Automation
cd "$DOTS_DIR" || exit
git add .

# Only commit if there are changes
if git diff-index --quiet HEAD --; then
    echo "No changes to backup."
else
    echo "Changes detected. Pushing to GitHub..."
    git commit -m "Backup: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    notify-send "Backup Complete" "Your dotfiles have been synced to GitHub." -i standard-icon-git
fi
