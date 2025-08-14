{ userConfig, ... }:
{
  # have polkit log all actions
  security = {
    polkit.enable = true;

    # this should only be installed on graphical systems
    soteria.enable = userConfig.machineConfig.workstation.enable;
  };
}
