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

- Publish a bottle for the new version by running `bin/mkbottle VERSION`.
  You will need a file in `$HOME/.netrc` with a line like the following:
  ```
  machine api.bintray.com login <your Bintray username> password <your Bintray API key>
  ```

  Note that your API key is not the same as your account password. It can be found
  via [these instructions](https://www.jfrog.com/confluence/display/BT/Uploading#Uploading-GettingyourAPIKey).

- Note the SHA hash printed at the end of the `bin/mkbottle` command, and
  update the `sha256` attribute under the `bottle` section of `Formula/materialized.rb`
  accordingly.

Then, submit a PR! CI will automatically test that the formula installs and
runs properly.
