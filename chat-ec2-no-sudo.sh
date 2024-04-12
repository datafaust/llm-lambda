#!/bin/bash
# Update package index
 apt-get update -y

# set up apache server
 apt-get install -y apache2
 systemctl start apache2
 systemctl enable apache2
 sh -c 'echo "<h1>Chat Ui server up at $(hostname -f)</h1>" > /var/www/html/index.html'


# usermod -a -G  ubuntu

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs
npm install -g npm@latest -y

# Install Git
apt-get install -y git


# docker installation
# Add Docker's official GPG key:
 apt-get update
 apt-get install ca-certificates curl
 install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
 chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null
 apt-get update -y

 apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Install Docker Compose
 apt-get install -y docker-compose

# Start Docker service
 systemctl start docker

# Enable Docker service to start on boot
 systemctl enable docker
 #usermod -a -G docker $USER

# install aws and python
# apt-get install python3 python3-pip -y
# pip3 install awscli

# clone llm lambda repo
git clone https://github.com/datafaust/llm-lambda.git

# clone chat repo
git clone https://github.com/huggingface/chat-ui.git
cd chat-ui
git checkout b0e461b

# copy over docker compose file
cp ../llm-lambda/docker-compose.yaml ./
cp ../llm-lambda/set_env.py ./
python3 set_env.py

npm install

# need to set mongodburl

docker-compose up -d

# good from here up


apt  install awscli


# replace mongodb url value
sed -i 's/^MONGODB_URL=.*/MONGODB_URL=my_new_value/' .env


# remove existing env file
#rm -f ./.env
#python3 set_env.py

# replace below manual for now
# create new env file
# nano .env

npm install



# npm run dev -- --host 172.31.94.143

npm run build
npm install -g pm2
npm install pm2-runtime -g

cd ../
pm2 start chat-ui/build/index.js -i $CPU_CORES --name "chat-ui"
pm2 save
pm2 startup
 env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
pm2 logs chat-ui [--lines 1000]

# prep server to be able to tackle sagemaker deployments
# install aws cli
 apt-get install python3 python3-pip -y
 pip3 install sagemaker boto3
 pip3 install python-dotenv

 pip3 install awscli




