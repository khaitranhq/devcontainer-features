#!/bin/bash
set -e

echo "Installing Go..."

# Get version from argument or default to latest
VERSION="${VERSION:-latest}"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
x86_64)
	GO_ARCH="amd64"
	;;
aarch64)
	GO_ARCH="arm64"
	;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

# Get Go version
if [ "$VERSION" = "latest" ]; then
	GO_VERSION=$(curl -s https://go.dev/dl/ | grep -oP 'go[0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/go//')
else
	GO_VERSION="$VERSION"
fi
GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"

# Download and install Go
cd /tmp
curl -L -o go.tar.gz "$GO_URL"
rm -rf /usr/local/go
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz

# Add Go to PATH
ln -sf /usr/local/go/bin/go /usr/local/bin/go

echo "Go installation completed"
go version
