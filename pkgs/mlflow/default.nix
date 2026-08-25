{ base, pkgs }:

pkgs.dockerTools.buildLayeredImage {
  name = "mlflow";
  tag = pkgs.mlflow-server.version;
  fromImage = base;

  config = {
    Cmd = [
      "server"
      "--host"
      "0.0.0.0"
      "--port"
      "5000"
      "--backend-store-uri"
      "sqlite:////var/lib/mlflow/mlflow.db"
    ];
    Entrypoint = [
      "${pkgs.mlflow-server}/bin/mlflow"
    ];
    Env = [
      "PATH=${pkgs.mlflow-server}/bin"
      "MLFLOW_HOME=/var/lib/mlflow"
      "TMPDIR=/var/lib/mlflow"
    ];
    ExposedPorts = {
      "5000/tcp" = { }; # MLflow tracking server UI / API
    };
    Volumes = {
      "/var/lib/mlflow" = { };
    };
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/shikanime/niximgs";
      "org.opencontainers.image.description" = pkgs.mlflow-server.meta.description;
      "org.opencontainers.image.licenses" = pkgs.mlflow-server.meta.license.spdxId;
    };
    Healthcheck = {
      Test = [
        "CMD-SHELL"
        "curl --fail --silent --show-error http://localhost:5000/ || exit 1"
      ];
      Interval = 30;
      Timeout = 10;
      StartPeriod = 10;
    };
    User = "1000:1000";
  };
  contents = [
    pkgs.mlflow-server
    pkgs.curl
  ];
  fakeRootCommands = ''
    mkdir -p /tmp
    mkdir -p ./var/lib/mlflow
    chown 1000:1000 ./var/lib/mlflow
  '';
}
