{ pkgs, ... }: {

  # Flatpak apps support
  # services.flatpak.enable = true;

  # VirtualMachine
  # virtualisation.libvirtd.enable = true;
  # users.users.${userConfig.username}.extraGroups = [ "libvirtd" ];

  # Allow running dynamically linked binaries
  programs.nix-ld.enable = true;

  # Environment packages
  environment.systemPackages =
    let
      devTools = with pkgs; [
        # Editors and IDEs
        vscode-fhs

        # JavaScript/TypeScript
        nodejs

        # C/C++
        gdb
        clang
        gnumake
        cmake
        ninja

        # GTK development tools
        gtk3
        gtk4
        pkg-config

        # API Development
        postman
      ];

      utilityApps = with pkgs; [
        # Networking tools
        metasploit
        nmap
        tcpdump
        aircrack-ng
        wireshark
      ];

      communicationApps = with pkgs; [
        vesktop
        telegram-desktop
        slack
        zoom-us
      ];

      desktopApps = with pkgs; [
        (pkgs.callPackage ./notion-app-enhanced { })
        spotify
        anydesk
        github-desktop
      ];

      androidTools = with pkgs; [
        flutter
        openjdk
        android-tools
      ];
    in
    utilityApps ++ devTools ++ communicationApps ++ desktopApps ++ androidTools;
}
