const http = require("http");
const port = 8080;

const requestHandler = (req, res) => {
  if (req.url === "/health") {
    res.writeHead(200);
    return res.end("ok");
  }
  res.writeHead(200);
  res.end("Hello from Private EC2 behind ALB!");
};

http.createServer(requestHandler).listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});
