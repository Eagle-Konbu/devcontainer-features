# Dev Container Features

This repository provides custom [dev container Features](https://containers.dev/implementors/features/) following the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Available Features

### `goreg`

Installs [goreg](https://github.com/magicdrive/goreg), a Go import formatting tool that organizes imports into distinct groups.

**Source**: [magicdrive/goreg](https://github.com/magicdrive/goreg)

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/Eagle-Konbu/devcontainer-features/goreg:1": {
            "version": "latest"
        }
    }
}
```

Available options:
- `version`: Version of goreg to install. Use `latest` for the most recent version, or specify a version like `1.2.10` (default: `latest`)
