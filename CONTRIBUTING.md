### Updating the Formula

Updating the version of Materialize distributed by this tap requires that you
modify the Formula/materialized.rb script twice, in a very specific order. The
`bin/mkbottle` will give you instructions.

The steps are:

- Setup, You will need a file in `$HOME/.netrc` with a line like the following:
  ```
  machine api.bintray.com login <your Bintray username> password <your Bintray API key>
  ```

  Note that your API key is not the same as your account password. It can be
  found via [these
  instructions](https://www.jfrog.com/confluence/display/BT/Uploading#Uploading-GettingyourAPIKey).

  This only needs to be done once.

- run `bin/mkbottle VERSION` (e.g. `bin/mkbottle 0.2.0`), and edit the
  [`Formula/materialized.rb`](Formula/materialized.rb) recipe to include the
  info that it prints out:

  - `url` should point to the correct release tarball.
  - `sha256` should match the tarball at `url`
  - Update the `STABLE_BUILD_SHA` to reflect the full commit SHA for the
    selected release.

- Press enter to continue the script, and observe that it uploads a bottle to
  bintray. Afterwards:

  - Update the `sha256` attribute under the `bottle` section of
    `Formula/materialized.rb` with the high_siera bottle sha.

- Then, submit a PR! CI will automatically test that the formula installs and
  runs properly.
