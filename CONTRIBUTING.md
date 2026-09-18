## Contributing

### `mz`

To update the version of `mz` distributed by this tap, you will need to:

1. Update the `VERSION` constant in mz.rb.

2. Run the following commands to calculate the checksum of the tarballs:

    ```
    VERSION=vX.Y.Z
    curl "https://binaries.materialize.com/mz-$VERSION-aarch64-apple-darwin.tar.gz" | sha256sum
    curl "https://binaries.materialize.com/mz-$VERSION-x86_64-apple-darwin.tar.gz" | sha256sum
    ```

3. Update the checksums in mz.rb.

4. Open a PR with your changes.

### `mz-deploy`

Bumping `mz-deploy` is scripted. The easiest path is the **Bump mz-deploy** workflow
in the Actions tab — run it with the new version and it commits the bump straight to
`master` for you:

```
gh workflow run bump-mz-deploy.yml -f version=X.Y.Z
```

That workflow depends on one-time admin setup (a GitHub App that can bypass
`master`'s protection); see [.github/AUTOMATION_SETUP.md](.github/AUTOMATION_SETUP.md).
Until that is done, use the local script below.

To do it locally instead, from the repo root:

```
bin/update-mz-deploy X.Y.Z
```

It downloads every platform tarball listed in `Formula/mz-deploy.rb`, verifies each
one is a real archive, recomputes its checksum, and rewrites the `version` line and
all `sha256` lines. It aborts without touching the formula if any download fails.

Review with `git diff Formula/mz-deploy.rb` and open a PR against `master`.
