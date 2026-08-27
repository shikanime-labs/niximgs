{ base, pkgs }:

pkgs.dockerTools.buildLayeredImage {
  name = "sonarr";
  tag = pkgs.sonarr.version;
  fromImage = base;

  config = {
    Cmd = [
      "-nobrowser"
      "-data"
      "/var/lib/sonarr"
    ];
    Entrypoint = [
      "${pkgs.sonarr}/bin/Sonarr"
    ];
    Env = [
      "PUID=1000"
      "PGID=1000"
      "XDG_CONFIG_HOME=/var/lib/sonarr/xdg"
      "SONARR_CHANNEL=v4-stable"
      "SONARR_BRANCH=main"
      "TMPDIR=/run/sonarr-temp"
      "COMPlus_EnableDiagnostics=0"
    ];
    ExposedPorts = {
      "8989/tcp" = { }; # Web UI
    };
    Volumes = {
      "/var/lib/sonarr" = { };
    };
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/shikanime/niximgs";
      "org.opencontainers.image.description" = pkgs.sonarr.meta.description;
      "org.opencontainers.image.licenses" = pkgs.sonarr.meta.license.spdxId;
    };
    Healthcheck = {
      Test = [
        "CMD-SHELL"
        "curl --fail --silent --show-error http://localhost:8989/ping || exit 1"
      ];
      Interval = 60;
      Timeout = 10;
    };
    User = "1000:1000";
  };
  contents = [
    pkgs.dockerTools.fakeNss
    pkgs.sonarr
    pkgs.curl
  ];
  fakeRootCommands = ''
    mkdir -p ./var/lib/sonarr
    chown 1000:1000 ./var/lib/sonarr
    mkdir -p ./run/sonarr-temp
    chown 1000:1000 ./run/sonarr-temp
  '';
}
