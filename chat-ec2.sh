#!/bin/bash
# Update package index
sudo apt-get update -y

# Install Node.js and npm
sudo apt-get install -y nodejs npm

# Install Svelte Kit globally
#npm install -g svelte-kit

# Install Git
sudo apt-get install -y git

# Install Docker
sudo apt-get install -y docker.io

# Install Docker Compose
sudo apt-get install -y docker-compose

# Start Docker service
sudo systemctl start docker

# Enable Docker service to start on boot
sudo systemctl enable docker

# clone the repo
git clone https://github.com/huggingface/chat-ui.git
cd chat-ui

# provide you user with docker access

