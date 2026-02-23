#!/bin/bash
set -e

echo "Installing Go..."

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

# Get latest Go version from official releases page
GO_VERSION=$(curl -s https://go.dev/dl/ | grep -oP 'go[0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/go//')
GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"

# Download and install Go
cd /tmp
curl -L -o go.tar.gz "$GO_URL"
rm -rf /usr/local/go
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz

# Add Go to PATH
echo "export PATH=/usr/local/go/bin:\$PATH" >>/etc/profile.d/go.sh
export PATH=/usr/local/go/bin:$PATH

echo "Go installation completed"
go version
