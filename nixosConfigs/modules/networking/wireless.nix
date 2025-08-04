{
  userConfig,
  ...
}:
{
  hardware.wirelessRegulatoryDatabase = true;

  networking.wireless = {
    # wpa_supplicant
    enable = userConfig.machineConfig.networking.backend == "wpa_supplicant";
    userControlled.enable = true;
    allowAuxiliaryImperativeNetworks = true;

    extraConfig = ''
      update_config=1
    '';

    # iwd
    iwd = {
      enable = userConfig.machineConfig.networking.backend == "iwd";

      settings = {
        Settings.AutoConnect = true;

        General = {
          # more things that my uni hates me for
          # AddressRandomization = "network";
          # AddressRandomizationRange = "full";
          EnableNetworkConfiguration = true;
          RoamRetryInterval = 15;
        };

        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
      };
    };
  };
}
