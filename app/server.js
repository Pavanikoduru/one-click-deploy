const http = require("http");
const port = 8080;

const requestHandler = (req, res) => {
  if (req.url === "/health") {
    res.writeHead(200);
    res.end("ok");
  } else {
    res.writeHead(200);
    res.end("Hello from Private EC2 behind ALB!");
  }
};

const server = http.createServer(requestHandler);
server.listen(port, () => console.log(`Server running on port ${port}`));

