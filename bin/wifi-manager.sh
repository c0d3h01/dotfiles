#!/usr/bin/env bash
# wifi-powersave.sh — Enable/Disable Wi-Fi power saving
# Usage: sudo ./wifi-powersave.sh --enable | --disable

set -euo pipefail

[[ $EUID -ne 0 ]] && {
  echo "Run as root."
  exit 1
}

case "${1:-}" in
--enable)
  value=3
  state="on"
  ;;
--disable)
  value=2
  state="off"
  ;;
*)
  echo "Usage: $0 --enable | --disable"
  exit 1
  ;;
esac

command -v iw >/dev/null || {
  echo "'iw' not found."
  exit 1
}

# Properly read interfaces into array
interfaces=()
while IFS= read -r line; do
  interfaces+=("$line")
done < <(iw dev | awk '/Interface/ {print $2}')

[[ ${#interfaces[@]} -eq 0 ]] && {
  echo "No Wi-Fi interfaces found."
  exit 0
}

echo "Detected: ${interfaces[*]}"

for iface in "${interfaces[@]}"; do
  if iw dev "$iface" set power_save "$state" 2>/dev/null; then
    echo "[OK] $iface → power_save=$state"
  else
    echo "[WARN] Failed to set power_save on $iface"
  fi
  if command -v nmcli >/dev/null 2>&1; then
    nmcli connection modify "$iface" 802-11-wireless.powersave "$value" 2>/dev/null || true
  fi
done

nm_conf="/etc/NetworkManager/conf.d/wifi-powersave.conf"
if command -v NetworkManager >/dev/null 2>&1; then
  mkdir -p "$(dirname "$nm_conf")"
  printf "[connection]\nwifi.powersave=%s\n" "$value" >"$nm_conf"
fi

udev_rule="/etc/udev/rules.d/70-wifi-powersave.rules"
: >"$udev_rule"
for iface in "${interfaces[@]}"; do
  echo "ACTION==\"add\", SUBSYSTEM==\"net\", KERNEL==\"$iface\", RUN+=\"/usr/sbin/iw dev $iface set power_save $state\"" >>"$udev_rule"
done

echo
echo "=== ACTION COMPLETE ==="
echo "Restart NetworkManager or reboot to apply."
echo "To check manually:"
for iface in "${interfaces[@]}"; do
  echo "  iw dev $iface get power_save"
done
