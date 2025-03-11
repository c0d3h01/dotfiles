{ pkgs, ... }:

{
  imports = [
    ./devtools
    ./printing.nix
    # ./steam.nix
    ./tlp.nix
  ];

  # -*- Allow unfree softwares -*-
  nixpkgs.config.allowUnfree = true;

  # -*- Allow Nix experimental-features enable -*-
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # -*-[ Automatic cleanup ]-*-
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.settings.auto-optimise-store = true;

  # Enables nix-ld to run dynamically linked binaries outside the Nix store
  programs.nix-ld.enable = true;

  # flatpak Apps
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Limit Nix Build Jobs
  nix.settings.max-jobs = 2;
  nix.settings.substituters = [ "https://cache.nixos.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431Cz7knE28jzE3KFW4c9fPyNn6zhG3QHw=" ];

  environment.systemPackages = with pkgs; [
    # Notion fix patch
    (pkgs.callPackage ./notion-app-enhanced { })
    notion-app-enhanced # Notion Desktop

    # -*- Desktop GUI Apps -*-
    jetbrains.webstorm
    vesktop
    telegram-desktop
    github-desktop
    vscodium-fhs
    slack
    zoom-us
    anydesk
    libreoffice
    element-desktop
    tor-browser
    youtube-music
    spotify
    transmission_4-gtk

    # -*-[ Development tools ]-*-
    # Web development tools.
    nodejs_23
    nodenv
    yarn
    postman #GUI

    # Java.
    zulu23

    # Networking tools.
    metasploit # msfconsole 
    nmap

    # C/CPP, tools.
    clang
    gnumake
    cmake
    ninja
    glib
    glfw
    glew
    glm
  ];
}

