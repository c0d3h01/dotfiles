{
  inputs,
  pkgs,
  declarative,
  ...
}:

{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
    age
  ];

  age = {
    identityPaths = [
      "/home/${declarative.username}/.ssh/id_ed25519"
    ];

    secrets = {
      ssh-key.file = ./ssh-key.age;
      element-key.file = ./element-key.age;
    };
  };
}
