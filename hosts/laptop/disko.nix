{
  disko.devices = {
    disk = {
      nvme = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "nixos-esp";
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            plainSwap = {
              name = "nixos-swap";
              size = "4G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            root = {
              name = "nixos-root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                  "noatime"
                  "nodiratime"
                  "discard"
                ];
              };
            };
            # # -*- BTRFS -*-
            # root = {
            #   name = "nixos-root";
            #   size = "100%";
            #   content = {
            #     type = "btrfs";
            #     extraArgs = [ "-f" ];
            #     subvolumes = {
            #       "/@" = {
            #         mountpoint = "/";
            #         mountOptions = [
            #           "compress=zstd:3"
            #           "noatime"
            #           "discard=async" ];
            #       };
            #       "/@home" = {
            #         mountpoint = "/home";
            #         mountOptions = [
            #           "compress=zstd:3"
            #           "noatime" ];
            #       };
            #       "/@nix" = {
            #         mountpoint = "/nix";
            #         mountOptions = [
            #           "compress=zstd:1"
            #           "noatime"
            #         ];
            #       };
            #     };
            #   };
            # };
          };
        };
      };
    };
  };
}
