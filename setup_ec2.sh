# Install Python and pip
sudo yum update -y
sudo yum install python3 -y
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
export PATH=~/.local/bin:$PATH

# Install AWS CLI
pip install awscli --upgrade --user

# Configure AWS CLI
#aws configure

# Install required Python packages
pip install sagemaker boto3
pip install python-dotenv
