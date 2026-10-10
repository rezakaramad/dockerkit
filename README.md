# dockerkit

Docker images I maintain: base images for applications and tooling images used across my projects.

## Layout

```
images/<name>/Dockerfile   # one directory per image, built with that directory as context
```

## Build and publish

GitHub Actions (`.github/workflows/build-and-push.yaml`) builds only the images that changed under `images/`.

- Pull requests: build only, no push.
- Push to `main`: publish to `ghcr.io/rezakaramad/dockerkit/<name>`.
- Tags: `sha-<short>`, the full commit SHA, `main`, and `latest`.
- Manual run: use `workflow_dispatch` and optionally set an image name; empty builds all.

## Adding an image

Create `images/<name>/Dockerfile` (plus any files it copies) and push. The workflow picks it up automatically.
