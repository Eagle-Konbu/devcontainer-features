#!/bin/sh
set -e

echo "Activating feature 'goreg'"

# Get version option (capitalized environment variable)
VERSION=${VERSION:-latest}
echo "Installing goreg version: $VERSION"

# Ensure Go is available
if ! command -v go >/dev/null 2>&1; then
    echo "ERROR: Go is not installed or not in PATH"
    echo "Please ensure the Go devcontainer feature is installed before goreg"
    exit 1
fi

echo "Found Go: $(go version)"

# Determine installation target based on version
if [ "$VERSION" = "latest" ]; then
    INSTALL_TARGET="github.com/magicdrive/goreg@latest"
else
    # Add 'v' prefix if not present
    case "$VERSION" in
        v*) INSTALL_TARGET="github.com/magicdrive/goreg@${VERSION}" ;;
        *) INSTALL_TARGET="github.com/magicdrive/goreg@v${VERSION}" ;;
    esac
fi

echo "Installation target: $INSTALL_TARGET"

# Install goreg using go install
echo "Running: go install ${INSTALL_TARGET}"
go install "$INSTALL_TARGET"

# Verify installation
if command -v goreg >/dev/null 2>&1; then
    echo "goreg successfully installed at: $(command -v goreg)"
    echo "goreg installation complete!"
else
    echo "ERROR: goreg installation failed or binary not in PATH"
    echo "GOPATH: ${GOPATH:-not set}"
    echo "GOBIN: ${GOBIN:-not set}"
    exit 1
fi
