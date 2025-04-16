{
  pkgs,
  userConfig,
  inputs,
  ...
}:
{
  imports = [ ./modules ];

  home = {
    username = "${userConfig.username}";
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "${userConfig.stateVersion}";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      BROWSER = "firefox";
      PAGER = "less";
      LESS = "-R";
      JAVA_HOME = "${pkgs.openjdk}/lib/openjdk";
      ANDROID_HOME = "/home/c0d3h01/Android";
      # ANDROID_SDK_ROOT = "/home/c0d3h01/Android";
      # ANDROID_NDK_HOME = "/home/c0d3h01/Android/android-ndk-r27c";
      # PATH = "$HOME/Android/cmdline-tools/bin:$HOME/Android/platform-tools:$HOME/Android/android-ndk-r27c:$PATH";
      CHROME_EXECUTABLE = "${pkgs.firefox}/bin/firefox";
    };

    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    packages = with pkgs; [
      # Utilities
      fastfetch
      glances
      xclip
      curl
      wget
      tree
      asar
      fuse
      appimage-run
      nh # Nix Garbage Cleaner

      # Editors & Viewers
      fd # find
      file

      # Nix Tools
      nix-prefetch-github

      # Language Servers
      lua-language-server
      nil

      # System Monitoring
      inxi
      procs

      # Extractors
      unzip
      unrar
      p7zip
      xz
      zstd
      cabextract
    ];
  };

  programs = {
    zoxide.enable = true;

    ssh = {
      enable = true;
      matchBlocks = {
        "c0d3h01" = {
          hostname = "c0d3h01";
          user = "root";
          forwardAgent = true;
        };
      };
    };
  };
}
