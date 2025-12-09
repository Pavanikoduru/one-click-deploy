#!/bin/bash
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs git

git clone https://github.com/<your-repo>/DevOps-OneClick-Deploy.git
cd DevOps-OneClick-Deploy/app
nohup node server.js > app.log 2>&1 &

