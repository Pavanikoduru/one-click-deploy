const http = require("http");
const server = http.createServer((req, res) => {
  if (req.url === "/health") return res.end("ok");
  return res.end("Hello from Private EC2 behind ALB!");
});
server.listen(8080);
