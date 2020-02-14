### Updating the Formula

To update the version of Materialize distributed by this Homebrew
Formula, make the following changes:

- Update the `url` attribute to point to the correct release tarball.
- Update the `sha256` attribute. To get the new checksum, download the
  tarball of the target Materialize release and run:

  ```shell
  curl -L "https://github.com/MaterializeInc/materialize/archive/<version_you_want>.tar.gz" -o materialize.tar.gz
  openssl sha256 materialize.tar.gz
  ```

- Update the `MZ_DEV_BUILD_SHA` to use the most recent Git commit
  from the targeted release.

Test that you can pull it down locally! `cd` to this repo and run:
```shell script
brew install --verbose --debug materialize
```

Then, just submit a PR and merge!
