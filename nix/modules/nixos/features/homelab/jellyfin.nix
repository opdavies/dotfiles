{ config, lib, ... }:

with lib;

{
  options.features.homelab.jellyfin.enable = mkEnableOption "Enable jellyfin";

  config = mkIf config.features.homelab.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      group = "media";
      configDir = "/mnt/media/jellyfin";
    };

    services.caddy.virtualHosts."jellyfin.opdavies.uk" = {
      useACMEHost = "opdavies.uk";

      extraConfig = "reverse_proxy localhost:8096";
    };
  };
}
