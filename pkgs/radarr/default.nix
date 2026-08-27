{ base, pkgs }:

pkgs.dockerTools.buildLayeredImage {
  name = "radarr";
  tag = pkgs.radarr.version;
  fromImage = base;

  config = {
    Cmd = [
      "-nobrowser"
      "-data"
      "/var/lib/radarr"
    ];
    Entrypoint = [
      "${pkgs.radarr}/bin/Radarr"
    ];
    Env = [
      "PUID=1000"
      "PGID=1000"
      "XDG_CONFIG_HOME=/var/lib/radarr/xdg"
      "TMPDIR=/run/radarr-temp"
      "COMPlus_EnableDiagnostics=0"
    ];
    ExposedPorts = {
      "7878/tcp" = { }; # Web UI
    };
    Volumes = {
      "/var/lib/radarr" = { };
    };
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/shikanime/niximgs";
      "org.opencontainers.image.description" = pkgs.radarr.meta.description;
      "org.opencontainers.image.licenses" = pkgs.radarr.meta.license.spdxId;
    };
    Healthcheck = {
      Test = [
        "CMD-SHELL"
        "curl --fail --silent --show-error http://localhost:7878/ping || exit 1"
      ];
      Interval = 60;
      Timeout = 10;
    };
    User = "1000:1000";
  };
  contents = [
    pkgs.dockerTools.fakeNss
    pkgs.radarr
    pkgs.curl
  ];
  fakeRootCommands = ''
    mkdir -p ./var/lib/radarr
    chown 1000:1000 ./var/lib/radarr
    mkdir -p ./run/radarr-temp
    chown 1000:1000 ./run/radarr-temp
  '';
}
