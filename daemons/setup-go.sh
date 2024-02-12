#!/bin/bash

# Specify the Go version
GO_VERSION="1.22.0"  # Change this to the desired Go version

# Specify the installation directory
INSTALL_DIR="/usr/local"

# URL to download the Go binary
GO_URL="https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"

# Download and install Go
echo "Downloading Go ${GO_VERSION}..."
curl -LO "${GO_URL}"
sudo tar -C "${INSTALL_DIR}" -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
rm "go${GO_VERSION}.linux-amd64.tar.gz"

# Set up environment variables
echo "Setting up environment variables..."
echo "export PATH=\$PATH:${INSTALL_DIR}/go/bin" >> ~/.bashrc
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc

# Apply changes to the current shell session
source ~/.bashrc

# Display Go version
go version

echo "Go ${GO_VERSION} has been installed successfully!"
