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

    systemPackages = with pkgs; [
      gnome-photos
      gnome-tweaks
      micro
      libreoffice
      rhythmbox
      transmission_4-gtk
      gnomeExtensions.gsconnect # Extension
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
        ];
      };
      # interface
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-seconds = false;
        clock-show-date = true;
        clock-format = "12h";
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
        name = "Qogir-dark";
        package = pkgs.qogir-theme;
      };

      iconTheme = lib.mkForce {
        name = "Qogir-dark";
        package = pkgs.qogir-icon-theme;
      };

      theme = lib.mkForce {
        name = "Arc-Darker";
        package = pkgs.arc-theme;
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
