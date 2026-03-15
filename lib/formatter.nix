{
  pkgs,
  self,
}:
let
  inherit (pkgs) lib;

  formatterPkg = pkgs.treefmt.withConfig {
    runtimeInputs = with pkgs; [
      alejandra
      deadnix
      statix
      shellcheck
      shfmt
      beautysh
      (writeShellScriptBin "statix-fix" ''
        for file in "$@"; do
          ${lib.getExe statix} fix "$file"
        done
      '')
    ];

    settings = {
      on-unmatched = "info";
      tree-root-file = "flake.nix";

      excludes = [
        ".git/*"
        "flake.lock"
      ];

      formatter = {
        alejandra = {
          command = "alejandra";
          includes = [ "*.nix" ];
        };

        deadnix = {
          command = "deadnix";
          includes = [ "*.nix" ];
        };

        statix = {
          command = "statix-fix";
          includes = [ "*.nix" ];
        };

        shellcheck = {
          command = "shellcheck";
          options = [
            "-e"
            "SC1090,SC1091"
          ];
          includes = [
            "*.sh"
            ".bashrc"
          ];
          excludes = [
            ".shell_alias.sh"
            ".shell_export.sh"
            ".shell_function.sh"
            ".zshrc"
            ".zprofile"
          ];
        };

        shfmt = {
          command = "shfmt";
          options = [
            "-s"
            "-w"
            "-i"
            "2"
          ];
          includes = [
            "*.sh"
            ".bashrc"
          ];
          excludes = [
            ".shell_alias.sh"
            ".shell_export.sh"
            ".shell_function.sh"
            ".zshrc"
            ".zprofile"
          ];
        };

        beautysh = {
          command = "beautysh";
          options = [
            "--indent-size"
            "2"
          ];
          includes = [
            ".zshrc"
            ".zprofile"
            ".shell_alias.sh"
            ".shell_export.sh"
            ".shell_function.sh"
          ];
        };
      };
    };
  };
in
{
  formatter = formatterPkg;

  check =
    pkgs.runCommandLocal "formatting-check"
      {
        nativeBuildInputs = [ formatterPkg ];
      }
      ''
        cd ${self}
        treefmt --no-cache --fail-on-change
        touch "$out"
      '';
}
