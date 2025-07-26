{
  lib,
  userConfig,
  ...
}:
{
  services = lib.mkIf userConfig.machine.hasGUI {
    printing = {
      enable = true;
      openFirewall = true;
    };

    # Avahi (mDNS) for network printer discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}