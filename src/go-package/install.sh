#!/bin/bash
set -e

PACKAGES=${PACKAGES:-}

if [ -z "$PACKAGES" ]; then
	echo "No packages specified. Skipping go install."
	exit 0
fi

echo "Installing Go packages: $PACKAGES"

# Ensure Go is available
if ! command -v go &>/dev/null; then
	echo "Go is not installed. Please install Go first."
	exit 1
fi

# Install each package
for package in $PACKAGES; do
	echo "Installing $package..."
	go install "$package"@latest
done

echo "Go packages installation completed"
