const http = require('http');
const port = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    return res.end('ok');
  }
  if (req.url === '/') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    return res.end('Hello from DevOps API (private EC2 behind ALB)\n');
  }
  res.writeHead(404);
  res.end('not found');
});

server.listen(port, '0.0.0.0', () => {
  console.log(`Server listening on ${port}`);
});
