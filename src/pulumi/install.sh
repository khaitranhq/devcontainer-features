#!/bin/bash
set -e

PULUMI_VERSION=${VERSION:-latest}

echo "Installing Pulumi (version: $PULUMI_VERSION)..."

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
x86_64)
	PULUMI_ARCH="x64"
	;;
aarch64)
	PULUMI_ARCH="arm64"
	;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case $OS in
linux)
	PULUMI_OS="linux"
	;;
darwin)
	PULUMI_OS="darwin"
	;;
*)
	echo "Unsupported OS: $OS"
	exit 1
	;;
esac

# Get download URL
if [ "$PULUMI_VERSION" = "latest" ]; then
	PULUMI_VERSION=$(curl -s https://api.github.com/repos/pulumi/pulumi/releases/latest | grep -oP '"tag_name": "v\K[^"]*')
fi

PULUMI_URL="https://github.com/pulumi/pulumi/releases/download/v${PULUMI_VERSION}/pulumi-v${PULUMI_VERSION}-${PULUMI_OS}-${PULUMI_ARCH}.tar.gz"

echo "Downloading Pulumi from: $PULUMI_URL"

# Download and install Pulumi
cd /tmp
curl -L -o pulumi.tar.gz "$PULUMI_URL"
rm -rf pulumi
tar -xzf pulumi.tar.gz
rm pulumi.tar.gz

# Install to /usr/local/bin
mv pulumi/pulumi /usr/local/bin/
mv pulumi/pulumi-* /usr/local/bin/ 2>/dev/null || true
rm -rf pulumi

echo "Pulumi installation completed"
pulumi version
