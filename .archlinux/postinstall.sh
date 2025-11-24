#!/usr/bin/env bash
set -euo pipefail

# ---- Get target user safely ----
TARGET_USER=${SUDO_USER:-${USER:-$(logname)}}
[[ -n "$TARGET_USER" ]] || { echo "Could not determine target user"; exit 1; }

# --- Packages to install ---
PKGS=(
  # Core
  base-devel btrfs-progs efibootmgr grub

  # Network/Security
  firewalld openssh avahi nss-mdns

  # Audio/Video
  pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber 
  gstreamer gst-plugins-{base,good,bad,ugly} gst-libav

  # CLI & Dev Tools
  git git-lfs git-crypt git-delta lazygit diffutils rustup go zig pyenv 
  docker docker-compose lazydocker jdk17-openjdk postgresql mariadb-lts
  vim tmux htop fastfetch curl wget zram-generator reflector 
  sops sshpass inxi alsa-utils bluez bluez-utils lm_sensors stow

  # Fonts & UX
  noto-fonts{,-cjk,-emoji} ttf-fira-code
  
  # User Apps
  chromium discord qbittorrent wezterm

  # Extras
  snapper snap-pac grub-btrfs cups xclip
)

# --- Run as root ---
(( EUID == 0 )) || { echo "Run as root"; exit 1; }

echo "→ Updating mirrors & packages"
pacman -S reflector
reflector --country India --age 7 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyu --noconfirm

echo "→ Installing packages"
pacman -S --needed --noconfirm "${PKGS[@]}"

echo "→ Adding user to groups"
usermod -aG video,audio,sys,rfkill,storage,lp,docker "$TARGET_USER"

echo "→ Enabling services"
systemctl enable \
  avahi-daemon sshd bluetooth docker.socket cups.socket \
  systemd-resolved systemd-timesyncd fstrim.timer \
  snapper-timeline.timer snapper-cleanup.timer firewalld

# --- Pacman config ---
echo "→ Configuring pacman"
sed -i \
  -e 's/^#ParallelDownloads/ParallelDownloads/' \
  -e 's/^#Color/Color/' \
  -e '/# Misc options/a DisableDownloadTimeout\nILoveCandy' \
  -e 's/^#\[multilib\]/[multilib]/' \
  /etc/pacman.conf

# Enable multilib Include line (handles both commented states)
sed -i '/^\[multilib\]/,/^Include/ s/^#Include/Include/' /etc/pacman.conf

# --- Zram configuration ---
echo "→ Configuring zram"
cat > /etc/systemd/zram-generator.conf <<'EOF'
[zram0]
compression-algorithm = zstd
zram-size = ram
swap-priority = 100
fs-type = swap
EOF

systemctl daemon-reload
systemctl start systemd-zram-setup@zram0.service

# --- Chaotic-AUR ---
echo "→ Adding Chaotic-AUR repository"
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB

pacman -U --noconfirm \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Append repo if not already present
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
  cat >> /etc/pacman.conf <<'EOF'

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
fi

# Update package databases
pacman -Sy --noconfirm

# --- Install yay as user ---
echo "→ Installing yay AUR helper"
YAY_DIR="/tmp/yay-install-$TARGET_USER"
sudo -u "$TARGET_USER" mkdir -p "$YAY_DIR"
sudo -u "$TARGET_USER" git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$YAY_DIR"
pushd "$YAY_DIR" > /dev/null
sudo -u "$TARGET_USER" env HOME="/home/$TARGET_USER" \
  makepkg -si --noconfirm --needed
popd > /dev/null
rm -rf "$YAY_DIR"

# --- PostgreSQL initialization ---
echo "→ Initializing PostgreSQL"
if [[ ! -d /var/lib/postgres/data/base ]]; then
  sudo -u postgres initdb -D /var/lib/postgres/data
  systemctl enable --now postgresql
  echo "✓ PostgreSQL initialized and started"
else
  echo "✓ PostgreSQL already initialized"
  systemctl enable postgresql
fi

# --- MariaDB initialization ---
echo "→ Initializing MariaDB"
if [[ ! -d /var/lib/mysql/mysql ]]; then
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
  systemctl enable --now mariadb
  echo "✓ MariaDB initialized and started"
  echo ""
  echo "⚠ Run 'sudo mysql_secure_installation' after reboot to secure MariaDB"
else
  echo "✓ MariaDB already initialized"
  systemctl enable mariadb
fi

# --- Rustup configuration ---
echo "→ Configuring rustup for $TARGET_USER"
sudo -u "$TARGET_USER" env HOME="/home/$TARGET_USER" rustup default stable 2>/dev/null || {
  echo "⚠ Rustup toolchain installation will complete on first user login"
}

echo ""
echo ""
echo "Done! Reboot when ready."
