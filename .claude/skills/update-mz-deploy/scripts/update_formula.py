#!/usr/bin/env python3
"""Bump Formula/mz-deploy.rb to a new release.

Reads the `url` lines from the formula, substitutes the requested version into
each one, downloads every platform tarball, recomputes its sha256, and rewrites
the `version` line plus all `sha256` lines in place.

Pairing is positional: in the formula each `url "..."` line is immediately
followed by its `sha256 "..."` line, so the Nth url's checksum becomes the Nth
sha256. This means the script adapts automatically if platforms are added or
removed from the formula — it never hardcodes the platform list.

Usage: update_formula.py <version> [formula_path]
  <version>      e.g. 0.2.0  (a leading "v" is stripped, so v0.2.0 also works)
  [formula_path] defaults to Formula/mz-deploy.rb
"""
import hashlib
import pathlib
import re
import sys
import urllib.request


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit("usage: update_formula.py <version> [formula_path]")

    version = sys.argv[1].lstrip("v")
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        sys.exit(f"version {version!r} doesn't look like X.Y.Z")

    formula = pathlib.Path(sys.argv[2] if len(sys.argv) > 2 else "Formula/mz-deploy.rb")
    text = formula.read_text()

    url_templates = re.findall(r'url "([^"]*)"', text)
    sha_count = len(re.findall(r'sha256 "[^"]*"', text))
    if not url_templates:
        sys.exit(f"no `url` lines found in {formula}")
    if len(url_templates) != sha_count:
        sys.exit(f"{formula} has {len(url_templates)} url lines but {sha_count} "
                 "sha256 lines — they must pair 1:1; aborting")

    checksums = []
    for template in url_templates:
        url = template.replace("#{version}", version)
        print(f"→ {url}", file=sys.stderr)
        try:
            data = urllib.request.urlopen(url).read()
        except Exception as exc:  # noqa: BLE001 - surface any download failure
            sys.exit(f"ERROR downloading {url}: {exc}")
        # Guard against silently checksumming a 404 / error page: real artifacts
        # are gzip tarballs, which begin with the magic bytes 1f 8b.
        if data[:2] != b"\x1f\x8b":
            sys.exit(f"ERROR: {url} returned {len(data)} bytes that are not a "
                     "gzip tarball (likely a 404 or error page); aborting "
                     "without touching the formula")
        digest = hashlib.sha256(data).hexdigest()
        print(f"  sha256 {digest}", file=sys.stderr)
        checksums.append(digest)

    text = re.sub(r'version "[^"]*"', f'version "{version}"', text, count=1)
    digests = iter(checksums)
    text = re.sub(r'sha256 "[^"]*"', lambda _: f'sha256 "{next(digests)}"', text)

    formula.write_text(text)
    print(f"\n✓ Updated {formula} → version {version} "
          f"({len(checksums)} checksums refreshed)", file=sys.stderr)


if __name__ == "__main__":
    main()
