#!/bin/bash

DOTS_DIR="$HOME/dotfiles"
CONF_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"

# 1. Sync files to the dotfiles folder
echo "Syncing configs..."
rsync -av --delete --exclude 'google-chrome' --exclude 'discord' "$CONF_DIR/fastfetch" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/waybar" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/swaync" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/rofi" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/kitty" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/zed" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/nvim" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/obs-studio" "$DOTS_DIR/config/"
rsync -av --delete "$CONF_DIR/Open-RGB" "$DOTS_DIR/config/"

rsync -av --delete "$BIN_DIR/" "$DOTS_DIR/local/bin/"

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
