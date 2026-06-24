# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A [Homebrew](https://brew.sh) tap (`MaterializeInc/materialize`) that distributes
Materialize's macOS/Linux CLI tools. There is no application source here — only
Homebrew formula definitions in `Formula/`, each pointing at a prebuilt tarball
hosted at `https://binaries.materialize.com`. Work in this repo is almost always
bumping a formula to a new release (new `version`, new `url`, new `sha256`).

## Formulae

- `Formula/mz.rb` — the `mz` CLI. Version lives in the `VERSION` Ruby constant; selects the tarball by `Hardware::CPU.arm?` / `.intel?` (macOS only). Depends on `postgresql@14`.
- `Formula/mz-deploy.rb` — declarative SQL project tooling. Uses Homebrew's `version` DSL and `on_macos`/`on_linux` + `on_arm`/`on_intel` blocks. Installs shell completions via `generate_completions_from_executable`.
- `Formula/materialized.rb` — the old local database, intentionally `disable!`d. Do not revive it; running Materialize locally is no longer supported.

Note the two active formulae use different version idioms (`VERSION` constant vs. `version` DSL) and different platform-selection styles. Match the style already in the file you are editing.

## Releasing / bumping a version

Per `CONTRIBUTING.md`, to bump a formula:

1. Update the version (the `VERSION` constant in `mz.rb`, or the `version` line in `mz-deploy.rb`).
2. Recompute checksums for each platform tarball, e.g.:
   ```
   VERSION=vX.Y.Z
   curl "https://binaries.materialize.com/mz-$VERSION-aarch64-apple-darwin.tar.gz" | sha256sum
   curl "https://binaries.materialize.com/mz-$VERSION-x86_64-apple-darwin.tar.gz" | sha256sum
   ```
   (Use the matching tarball names from the formula for each arch/OS combination.)
3. Update every `sha256` in the formula.
4. Open a PR against `master`.

The `url`s must stay in sync with the version — interpolated as `#{VERSION}` / `#{version}` — so a version bump is not complete until both the version field and all checksums are updated together.

## Verifying a formula locally

```
brew install --build-from-source ./Formula/mz-deploy.rb   # install from the local file
brew audit --strict --formula ./Formula/mz-deploy.rb       # lint style/correctness
brew test mz-deploy                                        # run the formula's `test do` block
```
Each formula's `test do` block just runs the binary with `--version` as a smoke test.
