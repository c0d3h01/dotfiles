{ config
, pkgs
, user
, lib
, ...
}:
{
  # Enable X server and GNOME
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      xkb.layout = "us";
      desktopManager.gnome.enable = true;
      excludePackages = with pkgs; [ xterm ];
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

  # Exclude unwanted GNOME packages
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-backgrounds
      gnome-font-viewer
      epiphany
      yelp
      baobab
      gnome-weather
      gnome-text-editor
      gnome-connections
      gnome-music
      gnome-remote-desktop
      gnome-usage
      gnome-contacts
      gnome-system-monitor
    ];

    systemPackages = with pkgs.unstable; [
      gnome-photos
      gnome-tweaks
      micro
      libreoffice
      rhythmbox
      transmission_4-gtk
      gnomeExtensions.gsconnect
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
    ];

    pathsToLink = [
      "/share/icons"
      "/share/applications"
    ];
  };

  home-manager.users.${user.username} = { pkgs, ... }: {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "gsconnect@andyholmes.github.io"
          "appindicator@rgcjonas.gmail.com"
          "dash-to-dock@micxgx.gmail.com"
          "blur-my-shell@aunetx"
          "just-perfection-desktop@just-perfection"
        ];
      };
      # interface
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-seconds = false;
        clock-show-date = true;
        clock-format = "12h";
        color-scheme = "prefer-dark";
      };
      # power management
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-battery-type = "suspend";
        sleep-inactive-battery-timeout = 1800;
        power-button-action = "poweroff";
      };
      # night light
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-temperature = 4000;
      };
      # touchpad
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
        natural-scroll = true;
      };
      # workspaces
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        workspaces-only-on-primary = true;
      };
      # wallpaper
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.users.users.${user.username}.home}/dotfiles/assets/wallpaper.png";
        picture-uri-dark = "file://${config.users.users.${user.username}.home}/dotfiles/assets/wallpapers/image1.png";
        picture-options = "zoom";
      };
      # screensaver
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${config.users.users.${user.username}.home}/dotfiles/assets/wallpapers/image1.png";
        picture-options = "zoom";
        primary-color = "#8a0707";
        secondary-color = "#000000";
      };
    };

    gtk = {
      enable = true;

      cursorTheme = lib.mkForce {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };

      iconTheme = lib.mkForce {
        name = "Tela-dark";
        package = pkgs.tela-icon-theme;
      };

      theme = lib.mkForce {
        name = "Catppuccin-Mocha-Blue";
        package = pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = [ "blue" ];
        };
      };

      gtk3.extraConfig = lib.mkForce {
        "gtk-application-prefer-dark-theme" = true;
      };

      gtk4.extraConfig = lib.mkForce {
        "gtk-application-prefer-dark-theme" = true;
      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
    };
    mime = {
      enable = true;
      defaultApplications = {
        "application/x-bittorrent" = [ "transmission-gtk.desktop" ];
        "default-web-browser" = [ "firefox.desktop" ];
      };
    };
  };
}
