{ pkgs, userConfig, ... }:

{
  imports = [
    ./tools
  ];

  # Flatpak apps support
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # services.flatpak.enable = true;

  # VirtualMachine
  # virtualisation.libvirtd.enable = true;
  # users.users.${userConfig.username}.extraGroups = [ "libvirtd" ];

  # Allow running dynamically linked binaries
  programs.nix-ld.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # My Custom ToolSets
  myModules = {
    # androidTools = true;
    dockerTools = true;
    # hackerMode = true;
    # mysqlTools = true;
    # podmanTools = true;
    pythonTools = true;
    rustTools = true;
  };

  # Environment packages
  environment.systemPackages =
    let
      stablePkgs = with pkgs.stable; [
        # Notion Enhancer With patches
        (pkgs.callPackage ./notion-app-enhanced { })

        # Code editor
        vscode-fhs

        # Developement desktop apps
        postman
        github-desktop

        # Communication apps
        vesktop
        telegram-desktop
        zoom-us
        element-desktop

        # Common desktop apps
        anydesk
        drawio
        electrum

        # VirtualBox
        gnome-boxes
      ];

      unstablePkgs = with pkgs; [
        # -+ Common Developement tools
        nodejs

        # Electron tools
        electron
        # electron-fiddle

        # C/C++
        gdb
        gcc
        clang
        gnumake
        cmake
        ninja
        clang-tools

        # Gtk tools
        pkg-config

        # Android Tools
        flutter
        openjdk
        # androidsdk
      ];
    in
    stablePkgs ++ unstablePkgs;
}
