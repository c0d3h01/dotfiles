{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkAfter;
in
{
  config = mkMerge [
    {
      system.activationScripts.diff = {
        text = ''
          if [[ -e /run/current-system ]]; then
            echo "=== Diff to current-system ==="
            ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
            echo "=== End of system diff ==="
          fi
        '';
      };
    }

    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      system.activationScripts.diff.supportsDryActivation = true;
    })

    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      system.activationScripts.postActivation.text = mkAfter ''
        ${config.system.activationScripts.diff.text}
      '';
    })
  ];
}
