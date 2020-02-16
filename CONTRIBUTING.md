### Updating the Formula

To update the version of Materialize distributed by this tap, make the following
changes:

- Update the `url` attribute to point to the correct release tarball.

- Update the `sha256` attribute. To get the new checksum, download the
  tarball of the target Materialize release and checksum it via:

  ```shell
  curl -L "https://github.com/MaterializeInc/materialize/archive/<version_you_want>.tar.gz" -o materialize.tar.gz
  openssl sha256 materialize.tar.gz
  ```

- Update the `STABLE_BUILD_SHA` to reflect the full commit SHA for the
  selected release.

- Publish a bottle for the new version by running `bin/mkbottle VERSION`. You
  will need to be a Materialize employee with permissions to write to the
  downloads.mtrlz.dev S3 bucket to perform this step.

Then, submit a PR! CI will automatically test that the formula installs and
runs properly.
