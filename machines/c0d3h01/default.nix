{
  config,
  pkgs,
  lib,
  declarative,
  ...
}:

{
  imports = [
    ../installer/disko-config.nix
    ./hardware.nix
    ../../nixosModules
    ../../secrets
    ./btrfs.nix
  ];

  age.secrets = {
    ssh.file = ../../secrets/ssh.age;
    userPassword.file = ../../secrets/userPassword.age;
    sshPublicKeys.file = ../../secrets/sshPublicKeys.age;
  };

  documentation.enable = false;
  documentation.nixos.enable = lib.mkForce false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  # Configure keymap in x11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = [ "amdgpu" ];
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0 &&
            subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    });
  '';

  users.users.${declarative.username} = {
    description = declarative.fullName;
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    hashedPasswordFile = config.age.secrets.userPassword.path;
    home = "/home/${declarative.username}";
    openssh.authorizedKeys.keys = [
      config.age.secrets.sshPublicKeys.path
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "adbusers"
      "wireshark"
      "usbmon"
    ];
  };
}
