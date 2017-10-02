#!/bin/sh

echo "***********************************************"
echo "creates a nqm databot package from a meteor"
echo "client-side app that connects to a TDX server"
echo "***********************************************"
echo ""
echo ""
echo ""
echo "installing nqm-databotify-client"
npm install nqm-databotify-client
echo "creating meteor build html template"
rm ../nqm-databotify-build-template.html
cat <<EOT >> ../nqm-databotify-build-template.html
<!DOCTYPE html>
<html>
    <head>
        {{> css}}
        {{> head}}
    </head>
    <body>
      <div id="render-root"></div>
      {{> scripts}}
    </body>
</html>
EOT
echo "running nqm-databotify-client"
./node_modules/nqm-databotify-client/main.js ../nqm-databotify-build/client -s ./settings.json -t ../nqm-databotify-build-template.html
echo "creating index.js"
rm ../nqm-databotify-build/index.js
cat <<EOT >> ../nqm-databotify-build/index.js
(function() {
  "use strict";

  const fs = require("fs");
  const url = require("url");
  const util = require("util");
  const input = require("@nqminds/nqm-databot-utils").input;
  const express = require("express");

  function databot(input, output, context) {

    const app = express();
    app.use("/", express.static(__dirname + "/client"));
    app.use("/*", function(req, res) {
        res.sendFile(__dirname + "/client/index.html");
    });

    const databotServer = url.parse(context.databotServer || context.databotHost);
    const parts = databotServer.hostname.split(".");
    const domain = parts.slice(parts.length-2).join(".");

    let runtimeConfig = "__meteor_runtime_config__.PUBLIC_SETTINGS = " + JSON.stringify(context.packageParams.public) + ";\n";
    runtimeConfig += "__meteor_runtime_config__.ROOT_URL = \"" + util.format("%s//%s.%s", databotServer.protocol, context.subDomain, domain) + "\";\n";

    fs.writeFileSync(__dirname + "/client/databotInit.js", runtimeConfig);

    app.listen(context.instancePort);
  }

  input.pipe(databot);
}());
EOT
echo "creating package manifest"
rm ../nqm-databotify-build/package.json
cat <<EOT >> ../nqm-databotify-build/package.json
{
  "name": "nqm-databot-app",
  "version": "0.2.0",
  "description": "auto-generated databot package",
  "main": "index.js",
  "author": "databot@nqminds.com",
  "license": "ISC",
  "dependencies": {
  },
  "private": true
}
EOT
echo "creating package"
(cd ../nqm-databotify-build && zip -r ../databot.zip .)
echo "done"
