#!/bin/bash

# download env.txt file from s3
aws s3 cp s3://llm-event-logs/support_files/env.txt ./env.txt

# docker-compose down chat-ui service
docker-compose down chat-ui 

# replace .env file with contents in env.txt file
cat env.txt > .env

# rebuild docker service for chat-ui
docker-compose build chat-ui