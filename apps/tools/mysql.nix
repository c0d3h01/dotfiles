# Notes.
# sudo mysql -u root
# ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword';
# FLUSH PRIVILEGES;
# EXIT;
{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    myModules.mysql.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable MySQL tools suite";
    };
  };

  config = lib.mkIf config.myModules.mysql.enable {

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    environment.systemPackages = with pkgs; [
      mariadb
      mysql-workbench
      parallel
    ];
  };
}
