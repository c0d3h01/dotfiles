{
  pkgs,
  formatter,
}:
pkgs.mkShell {
  name = "dotfiles";

  nativeBuildInputs = with pkgs; [
    gitMinimal
    gnumake
    nil
    nix-output-monitor
    home-manager
    formatter
  ];
}
