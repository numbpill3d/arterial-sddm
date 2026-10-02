#!/usr/bin/env bash
# Install the Arterial SDDM theme (needs root to write /usr/share and /etc).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
sudo cp -r "$HERE" /usr/share/sddm/themes/arterial
sudo rm -rf /usr/share/sddm/themes/arterial/.git
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=arterial\n' | sudo tee /etc/sddm.conf.d/zz-arterial.conf >/dev/null
echo "Installed. Preview without logging out:"
echo "  sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/arterial"
