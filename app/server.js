const express = require("express");
const app = express();
const PORT = 8080;

app.get("/", (req, res) => res.send("Welcome to my API — Deployment Success!"));
app.get("/health", (req, res) => res.send("ok"));

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
