# nqm-databotify
nqm databot package builder

## requirements
This is linux only.

It uses the `zip` command to produce the package, if you haven't already, you can install this using:

```
sudo apt-get install zip
```

First build the meteor application into a folder. Note that before building your app, be sure to run npm install
in the application folder.

```
cd /path/to/meteor/app
npm install
meteor build --directory ../build
```

This will create a meteor app bundle folder at the following location:

```
/path/to/meteor/build
```

## usage
Download the shell script and copy it to the `/path/to/meteor/build` created above. Make sure the script has execute 
permission, and then run the script.

```
cd /path/to/meteor/build
curl https://raw.githubusercontent.com/nqminds/nqm-databotify/master/nqm-databotify.sh  > ./nqm-databotify.sh
chmod +x ./nqm-databotify.sh
./nqm-databotify.sh
``` 

## deployment
The `nqm-databotify.sh` script will create a `databot.zip` in the current directory. This should be uploaded to
the TDX as a zip file and then a databot created of type **zip package** referencing the uploaded zip resource.

The **package parameters** specified when creating the databot will be passed to the meteor application as the 
`METEOR_SETTINGS` environment variable.

The url of the running meteor app is determined by the instance name used when starting the databot,
for example, an instance name of **property inspector** will cause the databot to be hosted at 
`https://property-inspector.my-tdx.com`



