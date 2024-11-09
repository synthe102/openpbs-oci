# Openpbs OCI images

Allows to run Openpbs components as docker containers.

> [!WARNING]
> Highly experimental, edits /etc/pbs.conf on start.

## Quickstart

```bash
docker build . -t ghcr.io/synthe102/openpbs
docker run ghcr.io/synthe102/openpbs
```

## Additional info

Based on Rockylinux 8.

## TODO

- [x] allow to disable pbs.conf edit on start
