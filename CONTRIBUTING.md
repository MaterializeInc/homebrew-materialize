## Contributing

To update the version of `mz` distributed by this tap, you will need to:

1. Update the `VERSION` constant in mz.rb.

2. Run the following commands to calculate the checksum of the tarballs:

    ```
    VERSION=vX.Y.Z
    curl "https://binaries.materialize.com/mz-$VERSION-aarch64-apple-darwin.tar.gz" | sha256sum
    curl "https://binaries.materialize.com/mz-$VERSION-x86_64-apple-darwin.tar.gz" | sha256sum
    ```

3. Update the checksums and version in mz.rb.

4. Open a PR with your changes.
