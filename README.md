# Namespace Cloud Build Example

[![Build Actions Workflow](https://img.shields.io/github/actions/workflow/status/namespacelabs/examples-nsc-build-simple/build-actions.yaml?branch=main&label=Build%20Actions&logo=github&style=flat-square)](https://github.com/namespacelabs/examples-nsc-build-simple/actions?workflow=build-with-actions)
[![Build CLI Workflow](https://img.shields.io/github/actions/workflow/status/namespacelabs/examples-nsc-build-simple/build-cli.yaml?branch=main&label=Build%20CLI&logo=github&style=flat-square)](https://github.com/namespacelabs/examples-nsc-build-simple/actions?workflow=build-with-cli)
[![Private Registry Workflow](https://img.shields.io/github/actions/workflow/status/namespacelabs/examples-nsc-build-simple/build-actions-private.yaml?branch=main&label=Private%20Registry&logo=github&style=flat-square)](https://github.com/namespacelabs/examples-nsc-build-simple/actions?workflow=build-and-push-private-registry)

This repository shows how to use [Namespace Cloud](https://cloud.namespace.so/) to build a sample Docker container.

## Examples

### Namespace Cloud CLI

This example uses `nsc` CLI to build and push a Docker image to GitHub Container Registry.

```yaml
name: build-with-cli
on: [push]

permissions:
  # Required for requesting the GitHub Token
  id-token: write
  # Required for pushing images to GitHub Container Registry
  packages: write

jobs:
  build_with_nscloud:
    runs-on: ubuntu-latest
    name: Build with Namespace Cloud
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      # We are going to push to GH Container Registry
      - name: Log in to GitHub registry
        run: echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u $ --password-stdin

      # Install CLI and authenticate to Namespace Cloud
      - name: Install and configure Namespace Cloud CLI
        uses: namespacelabs/nscloud-setup@v0.0.3

      # Build and push with your Namespace Cloud workspace build cluster
      - name: Build and push with Namespace Cloud cluster
        run: |
          nsc build . --push ghcr.io/${{ github.repository_owner }}/app --tag latest
```

See our [GitHub Workflow file](.github/workflows/build-cli.yaml) for a more concrete example.

### Github Actions

This example uses Namespace Cloud Actions to build and push a Docker image to GitHub Container Registry.

```yaml
name: build-with-actions
on: [push]

permissions:
  # Required for requesting the GitHub Token
  id-token: write
  # Required for pushing images to GitHub Container Registry
  packages: write

jobs:
  build_with_nscloud:
    runs-on: ubuntu-latest
    name: Build with Namespace Cloud
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      # We are going to push to GH Container Registry
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      # Install CLI and authenticate to Namespace Cloud
      - name: Install and configure Namespace Cloud CLI
        uses: namespacelabs/nscloud-setup@v0.0.3

      # Setup docker build to use your Namespace Cloud workspace build cluster
      - name: Set up Namespace Cloud Buildx
        uses: namespacelabs/nscloud-setup-buildx-action@v0.0.2

      # Run standard Docker's build-push action
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository_owner }}/app:latest
```

See our [GitHub Workflow file](.github/workflows/build-actions.yaml) for a more concrete example.

### Namespace Cloud Container Registry

This example uses Namespace Cloud Actions to build and push a Docker image to Namespace Cloud Container Registry.

```yaml
name: build-and-push-private-registry
on: [push]

permissions:
  # Required for requesting the GitHub Token
  id-token: write

jobs:
  build_with_nscloud:
    runs-on: ubuntu-latest
    name: Build with Namespace Cloud
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      # Install CLI and authenticate to Namespace Cloud
      - name: Install and configure Namespace Cloud CLI
        id: nscloud # Needed to access its outputs
        uses: namespacelabs/nscloud-setup@v0.0.3

      # Setup docker build to use your Namespace Cloud workspace build cluster
      - name: Set up Namespace Cloud Buildx
        uses: namespacelabs/nscloud-setup-buildx-action@v0.0.2

      # Run standard Docker's build-push action
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ steps.nscloud.outputs.registry-address }}/app:latest
```

See our [GitHub Workflow file](.github/workflows/build-ns-registry.yaml) for a more concrete example.

## Run It Yourself!

1. [Fork](https://github.com/namespacelabs/examples-nsc-build-simple/fork) this repository;
2. Enable the GitHub Actions for it;
3. Configure the GitHub Actions to have `write` permissions on the repository;
   1. Go to _Settings_, then _Actions_ and finally _General_;
   2. Scroll down to _Workflow permissions_;
   3. Set _Read and write permissions_ option;
4. Manually run the _build_ workflow;
5. Pull the image locally!

   `docker pull ghcr.io/< your GitHub username >/nsc-django-example:v0.0.1`

## Community

Join us on [Discord](https://community.namespace.so/discord) for questions or feedback!
