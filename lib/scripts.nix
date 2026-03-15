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
        hm-build [profile]   Build profile (default: c0d3h01)
        hm-switch [profile]  Switch profile (default: c0d3h01)

      Examples:
        nix run .#hm-build
        nix run .#hm-switch
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
      PROFILE="''${1:-c0d3h01}"
      exec home-manager switch \
        --flake ".#''${PROFILE}" \
        --extra-experimental-features 'nix-command flakes' \
        -b backup
    '';
  };

  hm-build = writeShellApplication {
    name = "hm-build";
    runtimeInputs = with pkgs; [
      home-manager
      nix
    ];
    text = ''
      PROFILE="''${1:-c0d3h01}"
      exec home-manager build --flake ".#''${PROFILE}"
    '';
  };
}
