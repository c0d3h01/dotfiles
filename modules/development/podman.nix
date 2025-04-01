{ pkgs
, specialArgs
, ...
}:
{
  users.users.${specialArgs.username}.extraGroups = [ "podman" ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  environment.systemPackages = with pkgs; [
    dive
    podman-compose
    podman-desktop
  ];
}
