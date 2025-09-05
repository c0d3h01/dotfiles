{
  pkgs,
  lib,
  userConfig,
  ...
}: {
  config = lib.mkIf userConfig.machineConfig.workstation.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    environment.systemPackages = with pkgs; [
      firefox
      ghostty
      android-studio
      vscode-fhs
      jetbrains.webstorm
      postman
      github-desktop
      drawio
      slack
      discord
      telegram-desktop
      zoom-us
      libreoffice
      obsidian
      anydesk
      qbittorrent
      element-desktop
      signal-desktop
      ledger-live-desktop
      arduino
      rpi-imager
      wineWowPackages.stableFull
      winetricks
    ];
  };
}
