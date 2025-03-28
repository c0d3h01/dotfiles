{ config
, username
, pkgs
, ...
}:
{
  # Enable X server and GNOME
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    xkb.layout = "us";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = with pkgs; [ xterm ];
  };

  # Exclude unwanted GNOME packages
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-backgrounds
      gnome-font-viewer
      epiphany
      geary
      yelp
      baobab
      gnome-weather
      gnome-text-editor
      gnome-connections
      gnome-contacts
      gnome-system-monitor
    ];

    systemPackages = with pkgs; [
      gnome-photos
      gnome-tweaks
      gnome-boxes
      evolutionWithPlugins
      micro
      libreoffice
      # Gnome Extensions
      gnomeExtensions.gsconnect
    ];

    pathsToLink = [
      "/share/gtksourceview-4"
      "/share/gtksourceview-5"
      "/share/icons"
      "/share/themes"
      "/share/applications"
    ];
  };

  home-manager.users.${username} = { pkgs, ... }: {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "gsconnect@andyholmes.github.io"
        ];
      };

      # interface
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
        clock-show-weekday = true;
        clock-show-seconds = false;
        clock-show-date = true;
      };

      # wallpaper
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.users.users.${username}.home}/dotfiles/assets/wallpaper.png";
        picture-uri-dark = "file://${config.users.users.${username}.home}/dotfiles/assets/wallpaper.png";
        picture-options = "zoom";
      };

      # screensaver
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${config.users.users.${username}.home}/dotfiles/assets/wallpaper.png";
        picture-options = "zoom";
        primary-color = "#8a0707";
        secondary-color = "#000000";
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "palenight";
        package = pkgs.palenight-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };
      gtk3.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
      };
      gtk4.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal xdg-desktop-portal-gnome ];
    };
    mime = {
      enable = true;
      defaultApplications = {
        "application/x-bittorrent" = [ "transmission-gtk.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
        "default-web-browser" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };
  };
}
