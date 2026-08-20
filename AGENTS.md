# Niximgs

Container images for well-known applications, built with Nix and published to
GitHub Container Registry. Ensures reproducible and reliable container builds.

**Language:** Nix

## Structure

- `flake.nix` — Main flake exposing all image builds
- Per-application Nix build definitions
- `skaffold.yaml` — Build orchestration

## Available Applications

- **jellyfin** — Media server for managing and streaming media
- **mlflow** — Machine learning lifecycle management platform
- **postgresql** — Advanced open-source relational database
- **radarr** — Movie collection manager for Usenet and BitTorrent
- **sonarr** — TV series collection manager for Usenet and BitTorrent
- **syncthing** — Continuous file synchronization program
- **vaultwarden** — Unofficial Bitwarden compatible server (Rust)
- **whisparr** — Adult movie collection manager

## Usage

```bash
docker pull ghcr.io/shikanime/<application>:latest
```

## Building

```bash
nix develop --impure -c skaffold build
```

## Commit Style

- Plain-text capitalized title, no conventional-commit prefix
- Body with labels: `Design:`, `Related:`, `Closes #`
- Keep Markdown lines wrapped at 80 columns and run `nix fmt` before shipping

## Stack Workflow

- Install the official GitHub extension once: `gh extension install github/gh-stack`
  (requires GitHub CLI ≥ 2.0; `gh stack` is in public preview and may change).
- Keep one logical change per PR; split large work into a stack of PRs.
- Create a stack: `gh stack init`, then `gh stack add` for each new branch, and
  commit on the active branch. `gh stack view` lists the stack.
- Submit/update: `gh stack submit` (add `--open` to open PRs, `--auto` to skip
  prompts). Resubmit after each change to refresh titles, bodies, and branches.
- Pull down an existing stack: `gh stack checkout <PR_NUMBER>` (also accepts a
  stack number, PR URL, or branch name).
- Rebase onto updated trunk: `gh stack rebase` (cascading), then `gh stack submit`.
- Land a stack: `gh stack merge` (interactive) or
  `gh stack merge <PR_NUMBER> --yes --squash` to merge up to a PR.
- Never `gh pr merge` on a stacked PR — only `gh stack merge` lands stacks.
- Never force-push stack branches; `gh stack` owns the branch pointers.
