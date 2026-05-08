const express = require("express");
const client = require('prom-client');

const app = express();


const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();
app.get("/api", (req, res) => {
  res.send("Hello DevOps World from Docker!");
});
app.get('/api/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.send(await client.register.metrics());
});
// Add this line so the app stays alive in the container!
app.listen(5000, () => console.log("Server ready on port 5000"));

module.exports = app;
