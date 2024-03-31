#!/bin/bash

apt-get update -y
apt-get install python3-pip -y
pip install sagemaker boto3 python-dotenv


git clone https://github.com/datafaust/llm-lambda.git
cd llm-lambda


apt  install awscli -y
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_DEFAULT_REGION=us-east-1
SAGEMAKER_ROLE=${SAGEMAKER_ROLE}

printf "%s\n%s\n%s\njson\n" "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" "$AWS_DEFAULT_REGION" | aws configure

echo "SAGEMAKER_ROLE=$SAGEMAKER_ROLE" > .env





#!/bin/bash

apt-get update -y
apt-get install python3-pip -y
pip install sagemaker boto3 python-dotenv

git clone https://github.com/datafaust/llm-lambda.git
cd llm-lambda



# Configure AWS CLI with environment variables
apt install awscli -y
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=

# Set SAGEMAKER_ROLE in .env file
echo "SAGEMAKER_ROLE=arn:aws:iam::332963913137:role/service-role/AmazonSageMaker-ExecutionRole-20240205T173330" > .env



# # Install Python and pip
# sudo yum update -y
# sudo yum install python3 -y
# sudo yum install git -y
# curl -O https://bootstrap.pypa.io/get-pip.py
# python3 get-pip.py --user
# export PATH=~/.local/bin:$PATH

# # Install AWS CLI
# pip install awscli --upgrade --user

# # Configure AWS CLI
# #aws configure

# # Install required Python packages
# pip install sagemaker boto3
# pip install python-dotenv


# git clone https://github.com/datafaust/llm-lambda.git
# cd llm-lambda

# python3 deploy_test_model.py


su - ubuntu
sudo apt-get update -y

sudo apt install python3-pip -y
pip install sagemaker boto3
pip install python-dotenv
