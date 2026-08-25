{ base, pkgs }:

pkgs.dockerTools.buildLayeredImage {
  name = "whisparr";
  tag = pkgs.whisparr.version;
  fromImage = base;

  config = {
    Cmd = [
      "-nobrowser"
      "-data"
      "/var/lib/whisparr"
    ];
    Entrypoint = [
      "${pkgs.whisparr}/bin/Whisparr"
    ];
    Env = [
      "PUID=1000"
      "PGID=1000"
      "XDG_CONFIG_HOME=/var/lib/whisparr/xdg"
      "TMPDIR=/run/whisparr-temp"
      "COMPlus_EnableDiagnostics=0"
    ];
    ExposedPorts = {
      "6969/tcp" = { }; # Web UI
    };
    Volumes = {
      "/var/lib/whisparr" = { };
    };
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/shikanime/niximgs";
      "org.opencontainers.image.description" = pkgs.whisparr.meta.description;
      "org.opencontainers.image.licenses" = pkgs.whisparr.meta.license.spdxId;
    };
    Healthcheck = {
      Test = [
        "CMD-SHELL"
        "curl --fail --silent --show-error http://localhost:6969/ping || exit 1"
      ];
      Interval = 60;
      Timeout = 10;
    };
    User = "1000:1000";
  };
  contents = [
    pkgs.dockerTools.fakeNss
    pkgs.whisparr
    pkgs.curl
  ];
  fakeRootCommands = ''
    mkdir -p ./var/lib/whisparr
    chown 1000:1000 ./var/lib/whisparr
    mkdir -p ./run/whisparr-temp
    chown 1000:1000 ./run/whisparr-temp
  '';
}
