## Contributing

To update the version of `mz` distributed by this tap, you will need to:

  * Update the `VERSION` constant in mz.rb.

  * Run the following commands to calculate the checksum of the tarballs:

    ```
    VERSION=vX.Y.Z
    curl "https://binaries.materialize.com/mz-$VERSION-aarch64-apple-darwin.tar.gz" | sha256sum
    curl "https://binaries.materialize.com/mz-$VERSION-x86_64-apple-darwin.tar.gz" | sha256sum
    ```

  * Update the checksums in mz.rb.

  * Open a PR with your changes.
