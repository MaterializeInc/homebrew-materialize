# The actual logic of building the bottle.
#
# This script is not intended to be invoked directly, but run within a
# Docker container with the correct version of `tar` and `gzip` available
# (i.e., by bin/mkbottle). The interface is as follows:
#
#   * The formula must exist at /Formula.
#
#   * The version of Materialize to download must be provided as the first
#     argument to the script, without the leading `v`.
#
#   * The bottle will be written to /bottle.tar.gz.
#
set -euo pipefail

version=$1
platform=$2
formula=$3
prefix=$formula/$version

if [[ "$platform" = *arm64* ]]; then
  arch=aarch64
else
  arch=x86_64
fi

mkdir -p "$prefix/.brew"
(cd "$prefix" \
  && curl -L https://binaries.materialize.com/$formula-v$version-$arch-apple-darwin.tar.gz \
  | tar xz --strip-components=1)

cat > "$prefix/INSTALL_RECEIPT.json" <<EOF
{
  "homebrew_version": null,
  "used_options": [],
  "unused_options": [],
  "built_as_bottle": true,
  "poured_from_bottle": false,
  "installed_as_dependency": false,
  "installed_on_request": true,
  "changed_files": [
    "INSTALL_RECEIPT.json"
  ],
  "time": null,
  "source_modified_time": null,
  "HEAD": null,
  "stdlib": null,
  "compiler": "clang",
  "aliases": [],
  "runtime_dependencies": [],
  "source": {
    "path": "@@HOMEBREW_REPOSITORY@@/Library/Taps/MaterializeInc/homebrew-materialize/Formula/$formula.rb",
    "tap": "materializeinc/materialize",
    "spec": "stable",
    "versions": {
      "stable": "$version",
      "devel": "",
      "head": "HEAD",
      "version_scheme": 0
    }
  }
}
EOF

# Remove the self-referential bottle block using the same technique as
# Homebrew.
# See: https://github.com/Homebrew/brew/blob/d0f40eda1/Library/Homebrew/formula_installer.rb#L332
sed "/^  bottle do/,/^  end/d" /$formula.rb > "$prefix/.brew/$formula.rb"
tar \
  --sort=name \
  --mtime="./$prefix/bin/$formula" \
  --owner=0 --group=0 --numeric-owner \
  --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
  -c $formula \
  | gzip -n > bottle.tar.gz
