{ base, pkgs }:

pkgs.dockerTools.buildLayeredImage {
  name = "syncthing";
  tag = pkgs.syncthing.version;
  fromImage = base;

  config = {
    Entrypoint = [
      "${pkgs.syncthing}/bin/syncthing"
    ];
    Env = [
      "PUID=1000"
      "PGID=1000"
      "HOME=/var/lib/syncthing"
      "STCONFDIR=/var/lib/syncthing/config"
      "STDATADIR=/var/lib/syncthing/data"
      "STGUIADDRESS=0.0.0.0:8384"
      "STNODEFAULTFOLDER=1"
    ];
    ExposedPorts = {
      "8384/tcp" = { }; # Web UI
      "22000/tcp" = { }; # Sync
      "22000/udp" = { }; # Sync
      "21027/udp" = { }; # Discovery broadcasts
    };
    Volumes = {
      "/var/lib/syncthing" = { };
    };
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/shikanime/niximgs";
      "org.opencontainers.image.description" = pkgs.syncthing.meta.description;
      "org.opencontainers.image.licenses" = pkgs.syncthing.meta.license.spdxId;
    };
    Healthcheck = {
      Test = [
        "CMD-SHELL"
        "curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health | grep -o --color=never OK || exit 1"
      ];
      Interval = 60;
      Timeout = 10;
    };
    User = "1000:1000";
  };
  contents = [
    pkgs.syncthing
    pkgs.curl
  ];
  fakeRootCommands = ''
    mkdir -p ./var/lib/syncthing/config
    chown 1000:1000 ./var/lib/syncthing/config
    mkdir -p ./var/lib/syncthing/data
    chown 1000:1000 ./var/lib/syncthing/data
  '';
}
