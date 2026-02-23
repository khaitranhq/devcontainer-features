#!/bin/bash
set -e

echo "Installing golangci-lint..."

# Get version from argument or default to latest
VERSION="${VERSION:-latest}"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
x86_64)
	LINT_ARCH="amd64"
	;;
aarch64)
	LINT_ARCH="arm64"
	;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

# Get golangci-lint version
if [ "$VERSION" = "latest" ]; then
	LINT_VERSION=$(curl -s https://api.github.com/repos/golangci/golangci-lint/releases/latest | grep -oP '"tag_name": "\Kv[^"]+' | head -1)
else
	LINT_VERSION="$VERSION"
fi

# Ensure version starts with 'v'
if [[ ! "$LINT_VERSION" =~ ^v ]]; then
	LINT_VERSION="v$LINT_VERSION"
fi

LINT_URL="https://github.com/golangci/golangci-lint/releases/download/${LINT_VERSION}/golangci-lint-${LINT_VERSION#v}-linux-${LINT_ARCH}.tar.gz"

echo "Downloading golangci-lint from: $LINT_URL"

# Download and install golangci-lint
cd /tmp
curl -L -o golangci-lint.tar.gz "$LINT_URL"
tar -xzf golangci-lint.tar.gz
mv "golangci-lint-${LINT_VERSION#v}-linux-${LINT_ARCH}/golangci-lint" /usr/local/bin/
chmod +x /usr/local/bin/golangci-lint
rm -rf golangci-lint.tar.gz "golangci-lint-${LINT_VERSION#v}-linux-${LINT_ARCH}"

echo "golangci-lint installation completed"
golangci-lint version
