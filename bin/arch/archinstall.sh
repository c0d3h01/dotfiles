#!/usr/bin/env bash
#
# shellcheck disable=SC2162
#
# ==============================================================================
# -*- Automated Arch Linux Installation Personal Setup Script -*-
# ==============================================================================

set -exuo pipefail

# -*- Color codes -*-
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

declare -A CONFIG

# -*- Configuration function -*-
function init_config() {
    local drive=""
    local hostname=""
    local username=""
    local password=""
    local confirm_password=""
    local locale=""

    # --- Disk selection ---
    echo -e "${BLUE}Available disks:${NC}"
    lsblk -dpno NAME,SIZE,MODEL | grep -E '^/dev/(sd|hd|vd|nvme)' || { echo "No disks found."; exit 1; }
    echo
    while [[ -z "$drive" ]]; do
        read -rp "Enter disk device (e.g. /dev/nvme0n1): " drive
        [[ -b "$drive" ]] && break
        echo "!Invalid or non-existent block device: $drive"
        drive=""
    done

    # --- Hostname & username ---
    while [[ -z "$hostname" ]]; do
        read -rp "Enter hostname: " hostname
    done
    while [[ -z "$username" ]]; do
        read -rp "Enter username: " username
    done

    # --- Password confirmation ---
    while true; do
        read -rsp "Enter password for root and user: " password
        echo
        read -rsp "Confirm password: " confirm_password
        echo
        if [[ "$password" == "$confirm_password" && -n "$password" ]]; then
            break
        else
            echo "!Passwords do not match or are empty. Try again."
        fi
    done

    # --- Locale: safe default + optional override ---
    locale_default="en_IN.UTF-8"
    read -rp "Locale [$locale_default]: " user_locale
    locale="${user_locale:-$locale_default}"
    echo "Using locale: $locale"

    # --- Timezone selection ---
    timezone_default="Asia/Kolkata"
    read -rp "Timezone [$timezone_default]: " user_tz
    timezone="${user_tz:-$timezone_default}"
    echo "Using timezone: $timezone"

    CONFIG=(
        [DRIVE]="$drive"
        [HOSTNAME]="$hostname"
        [USERNAME]="$username"
        [PASSWORD]="$password"
        [TIMEZONE]="$timezone"
        [LOCALE]="$locale"
        [EFI_PART]="$drive"p1
        [ROOT_PART]="$drive"p2
    )
}

# -*- Logging functions -*-
function info() { echo -e "${BLUE}INFO: $* ${NC}"; }
function success() { echo -e "${GREEN}SUCCESS:$* ${NC}"; }

function setup_disk() {
    # -*- Wipe and prepare the disk -*-
    wipefs -af "${CONFIG[DRIVE]}"
    sgdisk --zap-all "${CONFIG[DRIVE]}"

    # -*- Create fresh GPT -*-
    sgdisk --clear "${CONFIG[DRIVE]}"

    # -*- Create partitions -*-
    sgdisk \
        --new=1:0:+1G --typecode=1:ef00 --change-name=1:"EFI" \
        --new=2:0:0 --typecode=2:8300 --change-name=2:"ROOT" \
        "${CONFIG[DRIVE]}"

    # -*- Reload the partition table -*-
    partprobe "${CONFIG[DRIVE]}"
}

function setup_filesystems() {
    # -*- Format partitions -*-
    mkfs.fat -F32 "${CONFIG[EFI_PART]}"
    mkfs.btrfs -L "ROOT" -n 16k -f "${CONFIG[ROOT_PART]}"

    # -*- Mount root partition temporarily -*-
    mount "${CONFIG[ROOT_PART]}" /mnt

    # -*- Create subvolumes -*-
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@tmp
    btrfs subvolume create /mnt/@log
    btrfs subvolume create /mnt/@cache

    # -*- Unmount and remount with subvolumes -*-
    umount /mnt
    mount -o "subvol=@,noatime,compress=zstd:3,ssd,space_cache=v2" "${CONFIG[ROOT_PART]}" /mnt

    # -*- Create necessary directories -*-
    mkdir -p /mnt/boot/efi /mnt/home /mnt/var/tmp /mnt/var/log /mnt/var/cache

    # -*- Mount EFI and home subvolumes -*-
    mount "${CONFIG[EFI_PART]}" /mnt/boot/efi
    mount -o "subvol=@home,noatime,compress=zstd:3,ssd,space_cache=v2" "${CONFIG[ROOT_PART]}" /mnt/home
    mount -o "subvol=@tmp,noatime,compress=zstd:3,ssd,space_cache=v2" "${CONFIG[ROOT_PART]}" /mnt/var/tmp
    mount -o "subvol=@cache,nodatacow,noatime,ssd,space_cache=v2" "${CONFIG[ROOT_PART]}" /mnt/var/cache
    mount -o "subvol=@log,noatime,compress=zstd:3,ssd,space_cache=v2" "${CONFIG[ROOT_PART]}" /mnt/var/log
}

# -*- Base system installation function -*-
function install_base_system() {
    info "Installing base system..."

    info "Configuring pacman for iso installaton..."
    # -*- Pacman configure for arch-iso -*-
    sed -i 's/^#ParallelDownloads/ParallelDownloads/' "/etc/pacman.conf"
    sed -i '/^# Misc options/a DisableDownloadTimeout' "/etc/pacman.conf"

    # -*- Refresh package databases -*-
    pacman -Syy

    info "Running reflctor..."
    reflector --country India --age 7 --protocol https --sort rate --save "/etc/pacman.d/mirrorlist"

    local base_packages=(
        # -*- Core System -*-
        base              # Minimal package set to define a basic Arch Linux installation
        base-devel        # Basic tools to build Arch Linux packages
        linux-firmware    # Firmware files for Linux
        linux-lts         # The LTS Linux kernel and modules

        # -*- Filesystem -*-
        btrfs-progs # Btrfs filesystem utilities

        # -*- Boot -*-
        grub       # GNU GRand Unified Bootloader
        efibootmgr # Linux user-space application to modify the EFI Boot Manager

        # -*- CPU & GPU Drivers -*-
        amd-ucode         # Microcode update image for AMD CPUs
        libva-mesa-driver # mesa with 32bit driver
        mesa              # Open-source OpenGL drivers
        vulkan-radeon     # Open-source Vulkan driver for AMD GPUs
        xf86-video-amdgpu # X.org amdgpu video driver
        xf86-video-ati    # X.org ati video driver
        xorg-server       # Xorg X server
        xorg-xinit        # X.Org initialisation program

        # -*- Network & firewall -*-
        networkmanager # Network connection manager and user applications
        firewalld      # Firewall daemon with D-Bus interface

        # -*- Multimedia & Bluetooth -*-
        bluez            # Daemons for the bluetooth protocol stack
        bluez-utils      # Development and debugging utilities for the bluetooth protocol stack
        pipewire         # Low-latency audio/video router and processor
        pipewire-pulse   # Low-latency audio/video router and processor - PulseAudio replacement
        pipewire-alsa    # Low-latency audio/video router and processor - ALSA configuration
        pipewire-jack    # Low-latency audio/video router and processor - JACK replacement
        wireplumber      # Session / policy manager implementation for PipeWire
        gstreamer        # Multimedia graph framework - core
        gst-libav        # Multimedia graph framework - libav plugin
        gst-plugins-base # Multimedia graph framework - base plugins
        gst-plugins-good # Multimedia graph framework - good plugins
        gst-plugins-bad  # Multimedia graph framework - bad plugins
        gst-plugins-ugly # Multimedia graph framework - ugly plugins

        # -*- Desktop environment [ Gnome ] -*-
        nautilus                 # Default file manager for GNOME
        sushi                    # A quick previewer for Nautilus
        totem                    # Movie player for the GNOME desktop based on GStreamer
        loupe                    # A simple image viewer for GNOME
        evince                   # Document viewer (PDF, PostScript, XPS, djvu, dvi, tiff, cbr, cbz, cb7, cbt)
        file-roller              # Create and modify archives
        rhythmbox                # Music playback and management application
        vlc                      # Free and open source cross-platform multimedia player and framework
        gnome-notes              # Write out notes, every detail matters
        gdm                      # Display manager and login screen
        gnome-settings-daemon    # GNOME Settings Daemon
        gnome-browser-connector  # Native browser connector for integration with extensions.gnome.org
        gnome-backgrounds        # Background images and data for GNOME
        gnome-session            # The GNOME Session Handler
        gnome-calculator         # GNOME Scientific calculator
        gnome-clocks             # gnome-clocks
        gnome-control-center     # GNOME's main interface to configure various aspects
        gnome-disk-utility       # Disk Management Utility for GNOME
        gnome-calendar           # Calendar application
        gnome-keyring            # Stores passwords and encryption keys
        gnome-nettool            # Graphical interface for various networking tools
        gnome-power-manager      # System power information and statistics
        gnome-screenshot         # Take pictures of your screen
        gnome-shell              # Next generation desktop shell
        gnome-themes-extra       # Extra Themes for GNOME Applications
        gnome-tweaks             # Graphical interface for advanced GNOME 3 settings (Tweak Tool)
        gnome-logs               # A log viewer for the systemd journal
        gnome-firmware           # Manage firmware on devices supported by fwupd
        snapshot                 # Take pictures and videos
        gvfs                     # VFS implementation for GIO
        gvfs-afc                 # VFS implementation for GIO - AFC backend (Apple mobile devices)
        gvfs-gphoto2             # VFS implementation for GIO - gphoto2 backend (PTP camera, MTP media player)
        gvfs-mtp                 # VFS implementation for GIO - MTP backend (Android, media player)
        gvfs-nfs                 # VFS implementation for GIO - NFS backend
        gvfs-smb                 # VFS implementation for GIO - SMB/CIFS backend (Windows file sharing)
        xdg-desktop-portal-gnome # Backend implementation for xdg-desktop-portal for the GNOME desktop environment
        xdg-user-dirs-gtk        # Creates user dirs and asks to relocalize them

        # -*- Fonts -*-
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        ttf-fira-code

        # Git Clients
        git
        git-lfs
        git-delta
        git-crypt
        diffutils
        lazygit

        # -*- Essential System Utilities -*-
        wezterm
        zram-generator
        reflector
        pacutils
        fastfetch
        htop
        wget
        curl
        sshpass
        openssh
        inxi
        cups
        snapper
        snap-pac
        grub-btrfs
        xclip
        vim
        tmux

        # -*- Development-tool -*-
        sops
        rustup
        lld
        mold
        gcc
        glibc
        gdb
        make
        cmake
        clang
        nvm
        postgresql
        mariadb-lts
        mysql-workbench
        docker
        docker-compose
        docker-buildx
        lazydocker
        jdk17-openjdk
        pyenv
        zig
        go
        php

        # -*- User Utilities -*-
        chromium
        discord
        qbittorrent
    )
    pacstrap -K /mnt --needed "${base_packages[@]}"
}

# -*- System configuration function -*-
function configure_system() {
    info "Configuring system..."

    # -*- Generate fstab -*-
    genfstab -U /mnt >>/mnt/etc/fstab

    # -*- Chroot and configure -*-
    arch-chroot /mnt /bin/bash <<EOF
    # Set timezone and synchronize hardware clock
    ln -sf /usr/share/zoneinfo/${CONFIG[TIMEZONE]} "/etc/localtime"

    # Synchronizes system time with hardware clock, using UTC
    hwclock --systohc

    # Configure system locale specified locale generation file
    echo "${CONFIG[LOCALE]} UTF-8" >> "/etc/locale.gen"

    # Generate locale configurations
    locale-gen

    # Set default language configuration
    echo "LANG=${CONFIG[LOCALE]}" > "/etc/locale.conf"

    # Set keyboard layout for virtual console
    echo "KEYMAP=us" > "/etc/vconsole.conf"

    # Set system hostname
    echo "${CONFIG[HOSTNAME]}" > "/etc/hostname"

    # Configure hosts file for network resolution
    # Sets localhost and system-specific hostname mappings
    cat > "/etc/hosts" << HOSTS
127.0.0.1   localhost
::1         localhost
HOSTS

    # Set root password using chpasswd (securely)
    echo "root:${CONFIG[PASSWORD]}" | chpasswd

    # Create new user account
    useradd -m -G wheel,video,audio,sys,rfkill,storage,lp -s /bin/bash "${CONFIG[USERNAME]}"

    # Set user password
    echo "${CONFIG[USERNAME]}:${CONFIG[PASSWORD]}" | chpasswd

    # Enable sudo access for wheel group members
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' "/etc/sudoers"

    # -*- Install GRUB bootloader for UEFI systems -*-
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

    # -*- Generate GRUB configuration file -*-
    grub-mkconfig -o /boot/grub/grub.cfg

    # -*- Regenerate initramfs for all kernels -*-
    mkinitcpio -P
EOF
}

function custom_configuration() {
    arch-chroot /mnt /bin/bash <<EOF
    # -*- Create zram configuration file for systemd zram generator -*-
    cat > "/usr/lib/systemd/zram-generator.conf" << ZRAM
[zram0]
compression-algorithm = zstd
zram-size = ram
swap-priority = 100
fs-type = swap
ZRAM

    # Configure pacman with parallel downloads, color output, multilib repo, and extra options
    sed -i 's/^#ParallelDownloads/ParallelDownloads/' "/etc/pacman.conf"
    sed -i 's/^#Color/Color/' "/etc/pacman.conf"
    sed -i '/^# Misc options/a DisableDownloadTimeout\nILoveCandy' "/etc/pacman.conf"
    sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' "/etc/pacman.conf"

    # -*- Enable additional services -*-
    systemctl enable \
    NetworkManager \
    bluetooth \
    fstrim.timer \
    gdm \
    dbus \
    lm_sensors \
    avahi-daemon \
    docker.socket \
    sshd \
    cups.socket \
    systemd-homed \
    systemd-timesyncd \
    snapper-timeline.timer snapper-cleanup.timer

    systemctl --user enable pipewire wireplumber

    # Modern DNS
    systemctl enable systemd-resolved
    ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

    # Ensure PipeWire replaces PulseAudio system-wide
    ln -sf /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/
    systemctl --global enable pipewire pipewire-pulse wireplumber
EOF
}

function main() {
    info "Starting Arch Linux installation script..."

    # Resize fonts while installations
    setfont latarcyrheb-sun32
    setfont ter-132n

    init_config

    # Main installation steps
    setup_disk
    setup_filesystems
    install_base_system
    configure_system
    custom_configuration

    read -p "Installation successful!, Unmount NOW? (y/n): " UNMOUNT
    if [[ $UNMOUNT =~ ^[Yy]$ ]]; then
        umount -R /mnt
    else
        arch-chroot /mnt
    fi
}

# Execute main function
main
