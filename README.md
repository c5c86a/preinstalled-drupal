Fork this repository and adapt the files of the install folder according to your needs.

The difference between this repository and the docker 'boran/drupal' is that it installs drupal while building the image and not while starting the container thus saving you time from your CI.

At the install folder, the file drupal.make is mandatory whereas composer.json and package.json are optional.

A .gitlab-ci.yml is given as an example on how to use it and cache the image between builds.
