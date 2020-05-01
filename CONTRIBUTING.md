### Updating the Formula

To update the version of Materialize distributed by this tap, make the following
changes:

- Publish a bottle for the new version by running `bin/mkbottle VERSION`.
  You will need a file in `$HOME/.netrc` with a line like the following:
  ```
  machine api.bintray.com login <your Bintray username> password <your Bintray API key>
  ```

  Note that your API key is not the same as your account password. It can be found
  via [these instructions](https://www.jfrog.com/confluence/display/BT/Uploading#Uploading-GettingyourAPIKey).

The output of `mkbottle` lists several attributes that you must update in
`Formula/materialized.rb:

- `url` should point to the correct release tarball.
- `sha256` should match the tarball at `url`
- Update the `sha256` attribute under the `bottle` section of
  `Formula/materialized.rb` with the high_siera bottle sha.
- Update the `STABLE_BUILD_SHA` to reflect the full commit SHA for the
  selected release.

Then, submit a PR! CI will automatically test that the formula installs and
runs properly.
