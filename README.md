# homebrew-materialize

This repository contains all components and information about 
the Materialize homebrew package.

### How to update the Materialize homebrew distribution

1. Check out the MaterializeInc/materialize repo locally.
   Ensure the `master` branch of materialize has the changes you
   want (you can run `git log` to confirm).
1. In your terminal, navigate to the root of the materialize repo.
   Build a tarball using the following command replacing the {date} 
   parameter:
   ```shell script
    git archive --format=tar.gz -o /tmp/materialize-{date}.tar.gz --prefix=materialize/ master
   ```
1. Drop the newly created tarball into the `homebrew-materialize` AWS 
   S3 bucket.
1. Update the materialize SHA in `Formula/materialize.rb` to match
   the SHA of the newly created tarball.
1. Ensure `brew install` still works by running:
   ```shell script
   brew install --verbose --debug materialize 
   ```
1. Commit the updates to `Formula/materialize.rb` to this repository.

### FAQ

- Why are we storing the tarball in S3?

    Two reasons!
    
    First, to use a tarball directly from a Github repository, the repo needs 
    to be public (Materialize is not currently public). 
    
    Second, I have configured
    a secondary S3 bucket (`homebrew-materialize-logging`) to log each time something
    is downloaded from `homebrew-materialize`. Hopefully we can use this to 
    track downloads and traction over time!

   

