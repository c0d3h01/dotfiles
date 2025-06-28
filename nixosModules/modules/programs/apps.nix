{
  pkgs,
  ...
}:

{
  # <-- Enable flatpak repo --> :
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # services.flatpak.enable = true;

  # AppImage support
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  # <-- Environment packages -->
  environment.systemPackages = with pkgs; [

    # Browsers
    firefox

    # Notion Enhancer With patches
    (pkgs.callPackage ./_notion-app-enhanced { })

    # Terminal
    ghostty

    # Code editors
    figma-linux
    vscode-fhs
    jetbrains.pycharm-community-bin
    jetbrains.webstorm
    # android-studio

    # Communication apps
    slack
    vesktop
    telegram-desktop
    zoom-us
    element-desktop
    signal-desktop

    # Common desktop apps
    postman
    github-desktop
    anydesk
    drawio
    electrum
    qbittorrent
    obs-studio
    libreoffice-qt6-fresh
    obsidian

    # Terminal tools
    electron
    toolbox
    powershell
    umlet
    gdb
    gcc
    gnumake
    cmake
    cmakeWithGui
    ninja
    clang
    pkg-config
    gtk4
    glib
    pango
    gdk-pixbuf
    gobject-introspection
    libepoxy
  ];
}
