{
  pkgs,
  userConfig,
  ...
}:

{
  # Enable X server and GNOME
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      xkb.layout = "us";
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0 &&
            subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    });
  '';

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Exclude unwanted GNOME packages
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-font-viewer
      epiphany
      yelp
      baobab
      gnome-music
      gnome-remote-desktop
      gnome-usage
      gnome-system-monitor
    ];

    systemPackages = with pkgs; [
      # Desktop common Apps
      gnome-photos
      gnome-tweaks
      libreoffice
      transmission_4

      # Gnome extensions
      gnomeExtensions.tiling-assistant
    ];
  };

  home-manager.users."${userConfig.username}" = {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "tiling-assistant@leleat-on-github"
          "gsconnect@andyholmes.github.io"
        ];
      };

      # interface
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-date = true;
        clock-format = "12h";
        color-scheme = "prefer-dark";
      };

      # touchpad
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
        natural-scroll = true;
      };

      # keyboard
      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
      };

      # workspaces
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        workspaces-only-on-primary = true;
      };

      # wallpaper
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/${userConfig.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
        picture-uri-dark = "file:///home/${userConfig.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
        picture-options = "zoom";
      };
    };

    # Configure XDG portals for the user
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
      config = {
        common.default = "gnome";
      };
    };
  };
}
