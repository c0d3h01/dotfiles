{
  inputs,
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

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 200;
  };

  boot.loader = {
    grub = lib.mkDefault {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev"; # For UEFI
      # useOSProber = true;
    };
    systemd-boot.enable = lib.mkDefault false;
    efi.canTouchEfiVariables = false;
    timeout = lib.mkForce 5;
  };

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "nowatchdog"
      "loglevel=3"
      "mitigations=off"
      "splash"
    ];

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
