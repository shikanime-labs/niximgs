<!-- owner: shikanime | zone: internal | purpose: build, publish, parity branches -->

# Runbook

## Build locally

```sh
nix develop --impure -c skaffold build
nix build .#<image>
```

`--impure` is required because `skaffold` reads environment/network state that
pure eval cannot see.

## Publish

CI builds and pushes images to GHCR on the configured trigger. Pull them with:

```sh
docker pull ghcr.io/shikanime/<application>:latest
```

## Add or bump an app

1. Add `pkgs/<app>/` with the Nix derivation.
2. Expose it from `flake.nix` (`packages.<system>.<app>`).
3. Add a `skaffold.yaml` profile entry if it needs one.
4. Test the build with `nix build .#<image>` before submitting.

## Branch protection

- 1 approving review, linear history, signed commits, squash+rebase only.
- Test image builds before submitting.
