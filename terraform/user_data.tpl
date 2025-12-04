#!/bin/bash
yum update -y
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

mkdir -p /opt/app
echo 'const http=require("http");const s=http.createServer((q,r)=>{if(q.url=="/health")r.end("ok");else r.end("Hello from EC2 behind ALB");});s.listen(8080);' > /opt/app/index.js

nohup node /opt/app/index.js > /opt/app/app.log 2>&1 &
