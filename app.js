const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Hello DevOps World from Docker!");
});

// Add this line so the app stays alive in the container!
app.listen(3000, () => console.log("Server ready on port 3000"));

module.exports = app;
