# Namespace Cloud Build Example

This repository shows how to use Namespace Cloud to build a sample Docker container.

## Run it!

1. [Fork](https://github.com/namespacelabs/examples-nsc-build-simple/fork) this repository;
2. Enable the GitHub Actions for it;
3. Configure the GitHub Actions to have `write` permissions on the repository;
   1. Go to _Settings_, then _Actions_ and finally _General_;
   2. Scroll down to _Workflow permissions_;
   3. Set _Read and write permissions_ option;
4. Manually run the _build_ workflow;
5. Pull the image locally!

   `docker pull ghcr.io/< your username >/nsc-django-example:v0.0.1`
