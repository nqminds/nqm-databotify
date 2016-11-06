# nqm-databotify
nqm databot package builder

## requirements
This is linux only.

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
chmod +x ./nqm-databotify.sh
./nqm-databotify.sh
``` 

