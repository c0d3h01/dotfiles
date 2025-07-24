{ config, ... }:
{
  programs.lazygit = {
    enable = true;

    settings = {
      update.method = "never";

      gui = {
        nerdFontsVersion = 3;
        authorColors.isabel = "#f5c2e7";
      };

      git = {
        overrideGpg = true;
        paging = {
          colorArg = "always";
          pager = "delta --paging=never";
        };
      };
    };
  };
}
