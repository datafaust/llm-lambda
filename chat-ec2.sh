#!/bin/bash
# Update package index
sudo apt-get update -y

# set up apache server
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo sh -c 'echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html'


#sudo usermod -a -G sudo ubuntu

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g npm@latest -y

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
sudo usermod -a -G docker $USER

# install aws and python
#sudo apt-get install python3 python3-pip -y
#sudo pip3 install awscli

# clone llm lambda repo
git clone https://github.com/datafaust/llm-lambda.git

# clone chat repo
git clone https://github.com/huggingface/chat-ui.git

# copy over docker compose file
cp llm-lambda/docker-compose.yaml chat-ui/
cp llm-lambda/set_env.py chat-ui/
cd chat-ui

# remove existing env file
#rm -f ./.env
sudo python3 set_env.py

# replace below manual for now
# create new env file
#sudo nano .env

sudo npm install

sudo docker-compose up -d

#sudo npm run dev -- --host 172.31.94.143

sudo npm run build
sudo npm install -g pm2
npm install pm2-runtime -g

cd ../
pm2 start chat-ui/build/index.js -i $CPU_CORES --name "chat-ui"
pm2 save
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
pm2 logs chat-ui [--lines 1000]

# prep server to be able to tackle sagemaker deployments
# install aws cli
sudo apt-get install python3 python3-pip -y
sudo pip3 install sagemaker boto3
sudo pip3 install python-dotenv

sudo pip3 install awscli




