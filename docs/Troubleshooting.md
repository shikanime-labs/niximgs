<!-- owner: shikanime | zone: internal | purpose: known failure modes and fixes -->

# Troubleshooting

## `skaffold build` fails in pure mode

`skaffold` needs `--impure` — it inspects environment and network state that
pure Nix eval hides. Run `nix develop --impure -c skaffold build`.

## Image does not appear in GHCR

Confirm the CI trigger fired (the `devlib-migration` branches added a
paths-filtered push trigger) and that the `packages.<system>.<image>` output is
exposed from `flake.nix`. A missing flake output is never published.

## Drift from upstream

If an image behaves differently from upstream, check the matching
`feat/parity-<app>` branch — it tracks upstream container parity. Bump there
rather than patching the main derivation in isolation.

## Build is slow

Image builds are heavy. Build a single image with `nix build .#<image>` instead
of the full `skaffold build` while iterating.
