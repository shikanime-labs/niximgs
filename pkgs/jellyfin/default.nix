{ base, pkgs }:

pkgs.dockerTools.buildLayeredImage {
  name = "jellyfin";
  tag = pkgs.jellyfin.version;
  fromImage = base;

  config = {
    Entrypoint = [
      "${pkgs.jellyfin}/bin/jellyfin"
    ];
    Env = [
      "JELLYFIN_DATA_DIR=/var/lib/jellyfin"
      "JELLYFIN_CACHE_DIR=/var/cache/jellyfin"
      "JELLYFIN_CONFIG_DIR=/var/lib/jellyfin/config"
      "JELLYFIN_LOG_DIR=/var/lib/jellyfin/log"
    ];
    ExposedPorts = {
      "8096/tcp" = { }; # HTTP Web UI
      "8920/tcp" = { }; # HTTPS Web UI (optional)
      "1900/udp" = { }; # DLNA discovery
      "7359/udp" = { }; # Auto-discovery
    };
    Volumes = {
      "/var/lib/jellyfin" = { };
      "/var/cache/jellyfin" = { };
    };
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/shikanime/niximgs";
      "org.opencontainers.image.description" = pkgs.jellyfin.meta.description;
      "org.opencontainers.image.licenses" = pkgs.jellyfin.meta.license.spdxId;
    };
    Healthcheck = {
      Test = [
        "CMD-SHELL"
        "curl --noproxy localhost -Lk -fsS http://localhost:8096/health || exit 1"
      ];
      Interval = 30;
      Timeout = 10;
    };
    User = "1000:1000";
  };
  contents = [
    pkgs.dockerTools.fakeNss
    pkgs.jellyfin
    pkgs.curl
  ];
  fakeRootCommands = ''
    mkdir -p ./var/lib/jellyfin/config ./var/lib/jellyfin/log
    chown 1000:1000 ./var/lib/jellyfin
    chown 1000:1000 ./var/lib/jellyfin/config
    chown 1000:1000 ./var/lib/jellyfin/log
    mkdir -p ./var/cache/jellyfin
    chown 1000:1000 ./var/cache/jellyfin
  '';
}
