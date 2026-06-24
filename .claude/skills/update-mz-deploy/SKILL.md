---
name: update-mz-deploy
description: Bump the mz-deploy Homebrew formula (Formula/mz-deploy.rb) to a new release version — updates the version field and recomputes every platform's sha256 checksum from the published tarballs. Use this whenever the user wants to release, bump, update, or upgrade mz-deploy to a new version in this tap, or mentions a new mz-deploy version number (e.g. "release mz-deploy 0.2.0", "bump mz-deploy", "new mz-deploy version is out"). Edits files only and stops for review — it does not commit or open a PR.
---

# Update the mz-deploy tap to a new release

Bump `Formula/mz-deploy.rb` to a new version: set the `version` field and refresh
the `sha256` for every platform tarball. The version is provided by the user as an
argument (e.g. `0.2.0`); a leading `v` is fine and gets stripped.

Why a script does the heavy lifting: the only error-prone part is fetching each
platform's tarball and computing its checksum without accidentally checksumming a
404 page. The bundled script handles that deterministically and verifies each
download is a real gzip tarball before writing anything.

## Steps

1. **Get the version.** Use the version the user gave. If they didn't give one, ask
   — do not guess or auto-discover it.

2. **Run the script** from the repo root:
   ```
   python3 .claude/skills/update-mz-deploy/scripts/update_formula.py <version>
   ```
   It reads each `url` line in the formula, substitutes the version, downloads the
   tarball, verifies it's a gzip archive, computes its sha256, and rewrites the
   `version` line and all `sha256` lines in place. If any download fails or isn't a
   real tarball, it aborts **without** modifying the formula — relay that error to
   the user rather than hand-editing checksums, since a wrong sha256 silently breaks
   every install.

3. **Show the diff** so the user can review:
   ```
   git diff Formula/mz-deploy.rb
   ```
   Expect exactly the `version` line plus each `sha256` line to change.

4. **Audit if available** (optional but cheap reassurance):
   ```
   brew audit --strict --formula ./Formula/mz-deploy.rb
   ```

5. **Stop and report.** This skill edits files only. Tell the user the version is
   bumped and the checksums refreshed, and leave committing / branching / opening
   the PR to them (per `CONTRIBUTING.md`, PRs go against `master`).

## Notes

- `mz-deploy.rb` ships macOS arm64 + Linux x86_64 + Linux arm64 — there is
  deliberately **no** macOS-intel build. The script derives platforms from whatever
  `url` lines exist in the formula, so it stays correct if that set ever changes.
- This skill is scoped to `mz-deploy` only. The `mz` formula uses a different
  version idiom (a `VERSION` Ruby constant) and is out of scope here.
