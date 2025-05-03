{ pkgs, ... }:

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

  # My Coustom App, tools sets
  myModules = {
    # hackerMode = true;
    # androidTools = true;
    # dockerTools = true;
    podmanTools = true;
    pythonTools = true;
    rustTools = true;
    enableScientificTools = true;
  };

  # Environment packages
  environment.systemPackages =
    let
      stablePkgs = with pkgs.stable; [
        # Browser
        firefox-esr

        # Notion Enhancer With patches
        (pkgs.callPackage ./notion-app-enhanced { })

        # Editors and IDEs
        vscode-fhs

        # Developement desktop apps
        postman
        github-desktop

        # Communication apps
        vesktop
        telegram-desktop
        zoom-us

        # Common desktop apps
        anydesk
        openboard
      ];

      unstablePkgs = with pkgs; [
        # -+ Common Developement tools
        nodejs

        # C/C++
        gdb
        clang
        gnumake
        cmake
        ninja

        # Gtk tools
        pkg-config

        # Android Tools
        flutter
        openjdk
      ];
    in
    stablePkgs ++ unstablePkgs;
}
