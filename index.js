#!/usr/bin/env node
const shell = require("shelljs");

if (!shell.which("zip")) {
  shell.echo("Sorry, this script requires zip");
  shell.exit(1);
}

shell.echo("**********************************")
shell.echo("Packaging as databot zip")
shell.echo("Copying files");
shell.cp("-R", ".", "../databot");
shell.echo("Removing unnecessary files");
shell.rm("-r", "../databot/node_modules");
shell.cp("../databot/client/jspm_packages/system.js", "../databot");
shell.rm("-r", "../databot/client/jspm_packages/");
shell.mkdir("../databot/client/jspm_packages");
shell.mv("../databot/system.js", "../databot/client/jspm_packages");
shell.rm("-r", "../databot/client/src");
shell.echo("Zipping files");
shell.cd("../databot");
shell.exec("zip -r ../databot.zip ."); 
shell.echo("Cleaning up");
shell.rm("-r", "../databot");
shell.echo("Done");
shell.echo("**********************************")
