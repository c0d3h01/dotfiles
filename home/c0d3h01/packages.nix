{
  lib,
  pkgs,
  config,
  inputs',
  ...
}:
let
  inherit (lib) optionalAttrs mergeAttrsList;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.garden.profiles;
in
{
  garden.packages = mergeAttrsList [
    (optionalAttrs cfg.workstation.enable {
      inherit (pkgs)
        rsync
        wakatime-cli
        nix-output-monitor # much nicer nix build output
        wishlist # fancy ssh
        glow # fancy markdown
        fx # fancy jq
        gum # a nicer scripting
        # jq # json parser
        yq # yaml parser
        tmux
        coreutils
        fastfetch
        xclip
        curl
        wget
        tree
        stow
        zellij
        fd
        file
        tea
        binutils
        findutils
        pciutils
        inxi
        procs
        glances
        cheat # CheatSheet
        # devenv
        just
        claude-code

        # Zig lang
        zig

        # Extractors
        unzip
        unrar
        p7zip
        xz
        zstd
        cabextract
        ;

      inherit (inputs'.tgirlpkgs.packages) zzz; # code snippets in the cli
    })

    (optionalAttrs cfg.graphical.enable {
      inherit (pkgs)
        # bitwarden-desktop # password manager
        # jellyfin-media-player
        # insomnia # rest client
        inkscape # vector graphics editor
        # gimp # image editor
        manga-tui # tui manga finder + reader
        # bitwarden-cli # bitwarden, my chosen password manager
        vhs # programmatically make gifs
        # aseprite
        ;
    })
  ];
}
