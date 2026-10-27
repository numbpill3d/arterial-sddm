#!/usr/bin/env bash
# Install the Arterial SDDM theme (needs root to write /usr/share and /etc).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
THEME_DIR=/usr/share/sddm/themes/arterial
sudo mkdir -p "$THEME_DIR"
sudo cp -a "$HERE"/. "$THEME_DIR"/
sudo rm -rf "$THEME_DIR/.git"
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=arterial\n' | sudo tee /etc/sddm.conf.d/zz-arterial.conf >/dev/null
echo "Installed. Preview without logging out:"
echo "  sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/arterial"
