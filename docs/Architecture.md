<!-- owner: shikanime | zone: internal | purpose: niximgs build pipeline and layout -->

# Architecture

`niximgs` builds container images for well-known applications with Nix and
publishes them to GitHub Container Registry (GHCR) for reproducible, reliable
builds.

## Layout

- `flake.nix` — main flake exposing every image build (`packages.<system>.*`)
  via the devlib integration.
- `pkgs/<app>/` — one directory per application (jellyfin, mlflow, postgresql,
  radarr, sonarr, syncthing, vaultwarden, whisparr) plus `pkgs/base` for shared
  helpers.
- `skaffold.yaml` — build orchestration; renderable profiles per image.

## Build pipeline

A Nix derivation per app produces a layered OCI image. `skaffold` drives the
build locally and in CI; published tags land at
`ghcr.io/shikanime/<application>:latest`. The `devlib-migration` branches moved
the flake onto the devlib integration for consistent CI.

## Parity

`feat/parity-*` branches align each image with its upstream container to reduce
drift; review those before bumping an app.
