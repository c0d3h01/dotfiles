{
  # Enable flakes and optimize Nix settings
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Show stack traces for better debugging
      show-trace = true;

      # Use all available CPU cores for building
      cores = 0;

      # log output for failed builds
      log-lines = 30;

      # Optimize the Nix store by deduplicating identical files via symlinks
      auto-optimise-store = true;

      # Automatically determine optimal number of parallel jobs
      max-jobs = "auto";

      # Preserve derivations and outputs for direnv compatibility
      keep-derivations = true;
      keep-outputs = true;

      # Don't warn about uncommitted changes in git repositories
      warn-dirty = false;

      # Use /var/tmp instead of RAM for builds to avoid tmpfs issues
      build-dir = "/var/tmp";

      # Add trusted users for faster builds
      trusted-users = [
        "root"
        "@wheel"
      ];

      # Optimize substituters
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    # Enable garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
