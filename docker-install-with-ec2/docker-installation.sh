#! /bin/bash

# Exit immediately if any command fails
set -e

echo "Installing Docker dependencies..."

sudo dnf -y install dnf-plugins-core

echo "Adding Docker repository..."

sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

echo "Installing Docker packages..."

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Starting Docker service..."

sudo systemctl start docker

echo "Enabling Docker service at boot..."

sudo systemctl enable docker

echo "Checking Docker service status..."

echo "Adding ec2-user to docker group"

usermod -aG docker ec2-user

echo "Docker installation completed successfully!"
