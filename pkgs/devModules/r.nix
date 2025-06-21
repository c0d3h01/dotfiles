{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    myModules.r.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.myModules.r.enable {
    environment.systemPackages = with pkgs; [
      R
      rPackages.tidyverse
      rPackages.devtools
      rPackages.shiny
      rPackages.knitr
      rPackages.rmarkdown
    ];
  };
}
