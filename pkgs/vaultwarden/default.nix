{ base, pkgs }:

pkgs.dockerTools.buildLayeredImage {
  name = "vaultwarden";
  tag = pkgs.vaultwarden.version;
  fromImage = base;

  config = {
    Entrypoint = [
      "${pkgs.vaultwarden}/bin/vaultwarden"
    ];
    Env = [
      "ROCKET_ADDRESS=0.0.0.0"
      "ROCKET_PORT=80"
      "DATA_FOLDER=/var/lib/vaultwarden"
    ];
    ExposedPorts = {
      "80/tcp" = { }; # Vaultwarden default port
    };
    Volumes = {
      "/var/lib/vaultwarden" = { };
    };
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/shikanime/niximgs";
      "org.opencontainers.image.description" = pkgs.vaultwarden.meta.description;
      "org.opencontainers.image.licenses" = pkgs.vaultwarden.meta.license.spdxId;
    };
    Healthcheck = {
      Test = [
        "CMD-SHELL"
        "curl --insecure --fail --silent --show-error \"http://localhost:80/alive\" || exit 1"
      ];
      Interval = 60;
      Timeout = 10;
    };
    User = "1000:1000";
  };
  contents = [
    pkgs.vaultwarden
    pkgs.curl
  ];
  fakeRootCommands = ''
    mkdir -p ./var/lib/vaultwarden
    chown 1000:1000 ./var/lib/vaultwarden
  '';
}
