#!/bin/bash
# Update package index
sudo apt-get update -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g npm@latest -y

# Install Svelte Kit globally
#npm install -g svelte-kit

# Install Git
sudo apt-get install -y git


# docker installation
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Install Docker Compose
sudo apt-get install -y docker-compose

# Start Docker service
sudo systemctl start docker

# Enable Docker service to start on boot
sudo systemctl enable docker

# clone llm lambda repo
git clone https://github.com/datafaust/llm-lambda.git

# clone chat repo
git clone https://github.com/huggingface/chat-ui.git

# copy over docker compose file
cp llm-lambda/docker-compose.yaml chat-ui/
cd chat-ui

# remove existing env file
rm -f ./.env

# replace below manual for now
# create new env file
sudo nano .env

sudo npm install

sudo docker-compose up -d

# provide you user with docker access

