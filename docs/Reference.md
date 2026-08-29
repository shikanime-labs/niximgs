<!-- owner: shikanime | zone: internal | purpose: applications and image naming -->

# Reference

## Applications

| App         | Purpose                                       |
| ----------- | --------------------------------------------- |
| jellyfin    | Media server for managing and streaming media |
| mlflow      | ML lifecycle management platform              |
| postgresql  | Advanced open-source relational database      |
| radarr      | Movie collection manager (Usenet/BitTorrent)  |
| sonarr      | TV series collection manager                  |
| syncthing   | Continuous file synchronization               |
| vaultwarden | Unofficial Bitwarden-compatible server (Rust) |
| whisparr    | Adult movie collection manager                |

## Image naming

- Registry: `ghcr.io/shikanime/<application>`
- Tag: `:latest` (and any CI-pinned tags)
- Flake output: `packages.<system>.<application>`

## Commands

| Command                                              | Purpose          |
| ---------------------------------------------------- | ---------------- |
| `nix develop --impure -c skaffold build`             | build all images |
| `nix build .#<image>`                                | build one image  |
| `nix fmt`                                            | format the repo  |
| `docker pull ghcr.io/shikanime/<application>:latest` | fetch image      |
