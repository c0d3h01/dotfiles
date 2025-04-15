{ pkgs, ... }:
{

  # Flatpak apps support
  services.flatpak.enable = true;

  # VirtualMachine
  # virtualisation.libvirtd.enable = true;
  # users.users.${userConfig.username}.extraGroups = [ "libvirtd" ];

  # Allow running dynamically linked binaries
  programs.nix-ld.enable = true;

<<<<<<< HEAD
  # Firefox install
||||||| parent of f37b5ed (fix: enable firefox program in default.nix)
  programs.firefox.enable
=======
>>>>>>> f37b5ed (fix: enable firefox program in default.nix)
  programs.firefox.enable = true;

  # Environment packages
  environment.systemPackages =
    let
      stablePkgs = with pkgs.stable; [
      ];

      unstablePkgs = with pkgs; [
        # Notion Enhancer
        (pkgs.callPackage ./notion-app-enhanced { })

        # Editors and IDEs
        vscode-fhs

        # Developement desktop apps
        postman
        github-desktop

        # Communication apps
        vesktop
        telegram-desktop

        # Common desktop apps
        spotify
        anydesk
      ];
    in
    stablePkgs ++ unstablePkgs;
}
