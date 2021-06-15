## Contributing

To update the version of Materialize distributed by this tap, you will need
to be a Materialize employee with credentials for the `homebrew.materialize.com` S3 bucket.

Ask a member of the release team to help you set up credentials if necessary.

Then, run the `bump-version` script for the new version:

```shell
$ bin/bump-version VERSION
```

Push the resulting branch to GitHub and open a PR. CI will automatically test
that the formula installs and runs properly.

If the bottle is broken or otherwise fails CI, you will need to manually delete
the version from Bintray before trying again. The delete button is difficult to
find, but there are [instructions in the Bintray manual][bintray-delete].

## Debugging failures

If `bump-version` fails, for some reason, these are the steps that it runs
automatically. You can also perform them by hand. **Note: you must follow these
steps exactly in order.**

1. Edit [Formula/materialized.rb](Formula/materialized.rb) to reflect the new
   version:

    * Update the `url` line for the new source tarball. Homebrew will detect the
      version from the URL automatically.

    * Update the `sha256` hash. To get the new checksum, download the tarball of
      the target release and checksum it via:

      ```shell
      $ curl -L https://github.com/MaterializeInc/materialize/archive/VERSION.tar.gz | openssl sha256
      b5b3770008051186c9ce88e3ddd8da0f2d646cd95dd65545eb9758893a84279e
      ```

    * Update the `STABLE_BUILD_SHA` line to reflect the full commit SHA for the
      selected release.

2. Build a bottle for the new version by running `bin/mkbottle VERSION`.

3. Create a version in the Homebrew repository on Bintray, and upload the
   bottle. The bottle's filename must match this pattern exactly, where
   `VERSION` must *not* have a leading `v`.

   ```
   materialized-VERSION.high_sierra.bottle.tar.gz
   ```

3. Edit [Formula/materialized.rb](Formula/materialized.rb) again.

   Using the SHA hash printed at the end of the `bin/mkbottle` command, update
   the `sha256` line within the `bottle` block.

[bintray-api-key]: https://www.jfrog.com/confluence/display/BT/Uploading#Uploading-GettingyourAPIKey
[bintray-delete]: https://www.jfrog.com/confluence/display/BT/Managing+Uploaded+Content#ManagingUploadedContent-DeletingContent
