<!-- owner: shikanime | zone: internal | purpose: local setup and build loop -->

# Development

## Prerequisites

- Nix with flakes and `direnv`.
- Always work in a worktree (the AGENTS guidance forbids in-place edits).

## Local loop

1. `direnv allow` (or `nix develop`) to enter the dev shell.
2. Edit the app derivation under `pkgs/<app>/`.
3. `nix fmt` before shipping.
4. Build and test the image:

   ```sh
   nix develop --impure -c skaffold build
   # or a single image
   nix build .#<image>
   ```

## Commit style

Plain-text capitalized title (no conventional-commit prefix) with `Design:`,
`Related:`, `Closes #` body labels. The commit title/body become the PR
title/body; edit later with `gh pr edit`.

## VCS

Jujutsu (`.jj`) primary. One logical change per PR; large work splits into a
`gh stack` of PRs.
