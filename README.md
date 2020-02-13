# homebrew-materialize

This repository contains all components and information about 
the Materialize homebrew package.

### To Install Materialize

To install Materialize via Homebrew, run the following two commands:
```shell script
brew tap MaterializeInc/homebrew-materialize
brew install materialize
```

### Internal use: Update the Formula

To update the version of Materialize distributed by this Homebrew
Formula, make the following changes:
- Update the `url` attribute to point to the correct release tarball.
- Update the `commit` attribute (and the `MZ_DEV_BUILD_SHA` attribute)
  to use the most recent commit from the targeted release.
  
Test that you can pull it down locally! `cd` to this repo and run:
```shell script
brew install --verbose --debug materialize
```

Then, just submit a PR and merge!
   

