#!/bin/bash
yum update -y
yum install -y git
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

git clone https://github.com/Pavanikoduru/one-click-deploy.git
cd <YOUR_REPO>/app
npm install express
nohup node server.js > app.log 2>&1 &
