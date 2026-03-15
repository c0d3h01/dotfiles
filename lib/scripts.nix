{ pkgs }:
let
  inherit (pkgs) writeShellApplication;
in
{
  help = writeShellApplication {
    name = "help";
    text = ''
            cat <<'EOF'
      Commands:
        help                 Show this help
        hm-build [profile]   Build Home Manager
        hm-switch [profile]  Switch Home Manager

      Default profile:
        c0d3h01@''${NIX_SYSTEM:-x86_64-linux}

      Examples:
        nix run .#help
        nix run .#hm-build -- c0d3h01@x86_64-linux
        nix run .#hm-switch -- c0d3h01@x86_64-linux
      EOF
    '';
  };

  hm-switch = writeShellApplication {
    name = "hm-switch";
    runtimeInputs = with pkgs; [
      home-manager
      nix
    ];
    text = ''
      PROFILE="''${1:-c0d3h01@''${NIX_SYSTEM:-x86_64-linux}}"
      exec home-manager switch --flake ".#''${PROFILE}"
    '';
  };

  hm-build = writeShellApplication {
    name = "hm-build";
    runtimeInputs = with pkgs; [
      home-manager
      nix
    ];
    text = ''
      PROFILE="''${1:-c0d3h01@''${NIX_SYSTEM:-x86_64-linux}}"
      exec home-manager build --flake ".#''${PROFILE}"
    '';
  };
}
