#!/bin/bash

echo "--- 🚀 Starting CachyOS Maintenance ---"

# 1. Update System and AUR
echo "📦 Updating system and AUR packages..."
yay -Syu --noconfirm

# 2. Deep Clean Ghost/Temporary Downloads
# Added -rf to delete the 'download-xxx' directories properly
echo "👻 Clearing temporary download files and directories..."
sudo rm -rf /var/cache/pacman/pkg/*.part /var/cache/pacman/pkg/download-*

# 3. Clean the Pacman Cache
echo "🧹 Cleaning package cache (keeping last 2 versions)..."
sudo paccache -rk2
sudo paccache -ruk0

# 4. Remove Orphaned Packages
if [[ -n $(pacman -Qdtq) ]]; then
    echo "🗑️  Removing orphaned packages..."
    sudo pacman -Rs $(pacman -Qdtq) --noconfirm
else
    echo "✅ No orphaned packages found."
fi

# 5. Clean Yay/AUR Cache
echo "🧼 Cleaning AUR build cache..."
yay -Sc --noconfirm

# 6. Check for Failed Systemd Services
echo "🔍 Checking for failed services..."
failed_services=$(systemctl --failed --quiet)
if [[ -z "$failed_services" ]]; then
    echo "✅ All systemd services are healthy."
else
    systemctl --failed
fi

# 7. Reboot Check
echo "🛡️  Checking if a reboot is required..."
if [[ -f /var/run/reboot-required ]] || [[ $(uname -r) != $(pacman -Q linux-cachyos | awk '{print $2}' | sed 's/.arch/-cachyos/')* ]]; then
    REBOOT_NEEDED=true
    echo "⚠️  NOTE: A kernel update was detected. Please REBOOT soon."
else
    REBOOT_NEEDED=false
    echo "✅ No reboot required."
fi

echo ""
echo "--- ✨ System is Clean and Up-to-Date! ---"
echo ""

# 8. The Success Chime
# Using 'paplay' (standard in Plasma) to play a system sound
if [ -f /usr/share/sounds/freedesktop/stereo/complete.oga ]; then
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
fi

# The exit prompt
echo "Press any key to close this window..."
read -n 1 -s -r
exit 0
