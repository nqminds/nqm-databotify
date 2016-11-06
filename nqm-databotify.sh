#!/bin/sh

echo "***********************************************"
echo "creates a nqm databot package from a meteor app"
echo "***********************************************"
echo ""
echo ""
echo ""
echo "moving package.json"
mv ./bundle/programs/server/package.json ./bundle
echo "moving npm-rebuild.js"
mv ./bundle/programs/server/npm-rebuild.js ./bundle
echo "moving npm-rebuild-args.js"
mv ./bundle/programs/server/npm-rebuild-args.js ./bundle
echo "running npm install"
(cd bundle && npm install)
echo "creating index.js"
cat <<EOT >> ./bundle/index.js
(function() {
  "use strict";

  const url = require("url");
  const util = require("util");
  const input = require("nqm-databot-utils").input;

  function databot(input, output, context) {

    const databotServer = url.parse(context.databotHost);
    const parts = databotServer.hostname.split(".");
    const domain = parts.slice(parts.length-2).join(".");
    process.env.ROOT_URL = util.format("%s//%s.%s", databotServer.protocol, context.subDomain, domain);
    process.env.METEOR_SETTINGS = JSON.stringify(context.packageParams);
    process.env.PORT = context.instancePort;

    require("./main.js");
  }

  input.pipe(databot);
}());
EOT
echo "creating package"
(cd bundle && zip -r ../databot.zip .)
echo "done"
