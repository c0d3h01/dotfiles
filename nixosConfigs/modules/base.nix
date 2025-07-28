{
  lib,
  pkgs,
  userConfig,
  hostName,
  ...
}:
{
  # Basic system configuration that applies to all machines

  # Set hostname
  networking.hostName = userConfig.hostname;

  # System state version
  system.stateVersion = lib.trivial.release;

  programs.zsh.enable = true;
  # Create the main user
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
    ];
    shell = pkgs.${userConfig.dev.shell or "bash"};
  };

  # Enable sudo for wheel group
  security.sudo.wheelNeedsPassword = false;

  # Run dynamically linked librarys.
  programs.nix-ld.enable = true;

  services.libinput.enable = lib.mkIf (userConfig.machine.type == "laptop") true;
  services.libinput.touchpad.tapping = lib.mkIf (userConfig.machine.type == "laptop") true;

  # Configure X11
  services.xserver = lib.mkIf userConfig.machine.hasGUI {
    enable = true;
    xkb = {
      layout = "us,in";
      variant = ""; # Standard QWERTY
      options = "grp:alt_shift_toggle";
    };

    videoDrivers = [
      "modesetting"
      "fbdev"
    ];
  };

  # Timezone and locale - INDIAN timing
  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  # Scheduled fstrim
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Fonts
  fonts.packages = with pkgs; [
    (lib.mkIf (userConfig.dev.terminalFont == "JetBrains Mono") jetbrains-mono)
    (lib.mkIf (userConfig.dev.terminalFont == "Fira Code") fira-code)
    corefonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-emoji # emoji fallback
    liberation_ttf # Common document fonts
  ];
}
