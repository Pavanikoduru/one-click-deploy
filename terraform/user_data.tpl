#!/bin/bash
set -xe

# Update and install nodejs
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Create app folder and write server.js
mkdir -p /opt/simple-api
cat > /opt/simple-api/server.js <<'EOF'
const http = require('http');
const port = process.env.PORT || 8080;
const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    return res.end('ok');
  }
  if (req.url === '/') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    return res.end('Hello from DevOps API (private EC2 behind ALB)\\n');
  }
  res.writeHead(404);
  res.end('not found');
});
server.listen(port, '0.0.0.0', () => { console.log('Server listening on', port); });
EOF

# Make it run
nohup node /opt/simple-api/server.js > /opt/simple-api/app.log 2>&1 &
