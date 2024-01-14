const port = process.env.PORT || 3000;
const express = require("express");
const app = express();
var exec = require("child_process").exec;

// home page
app.get("/", function (req, res) {
  res.send("Hello World");
});

// entrypoint
exec("bash init.sh", function (err, stdout, stderr) {
  if (err) {
    console.log(err);
    return;
  }
  //console.log(stdout);
});

app.listen(port);
