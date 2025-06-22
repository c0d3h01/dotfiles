{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # firmware updates
  services.fwupd.enable = true;

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 200;
  };

  boot.loader = {
    grub = lib.mkDefault {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev"; # For UEFI
    };
    systemd-boot.enable = lib.mkDefault false;
    efi.canTouchEfiVariables = false;
    timeout = 5;
  };

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "nowatchdog"
      "loglevel=3"
      "mitigations=off"
      "elevator=noop"
      "splash"
    ];

    kernel.sysctl = { };

    initrd = {
      verbose = false;
      kernelModules = [ ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
    };
  };

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
