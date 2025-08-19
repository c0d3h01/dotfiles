{
  userConfig,
  inputs,
  self,
  config,
  ...
}:
{
  imports = [ inputs.sops.homeManagerModules.sops ];

  config = {
    sops = {
      # defaultSopsFile = "${self}/secrets/${userConfig.username}.yaml";
      age.sshKeyPaths = [
        "${config.home.homeDirectory}/.ssh/id_ed25519"
      ];
    };
  };
}
