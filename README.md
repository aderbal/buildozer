What
----

A simple docker image to build kivy projects without pain (hopefully)

How to use
----------

Build image from Dockerfile
---------------------------

    Because 100 MB limit file of github, get home.buildozer.tar.gz in 
    https://drive.google.com/open?id=1msym6gUTfKuW34j7lZ1_qTjmz911Jk-u and put in same place of Dockerfile

    sudo docker build --tag buildozer .

Buildozer.spec
--------------

If you don't have a buildozer.spec you can create one using

    sudo docker run -it -v $PWD:/buildozer/ buildozer /bin/bash

    then inside container: buildozer init .

Then customize it in your favorite editor.

Building
--------

Simply run the docker image with the directory containing buildozer.spec mounted as /buildozer/, the result apk will be in your directory/bin

    sudo docker run -it -v $PWD:/buildozer/ --privileged -v /dev/bus/usb:/dev/bus/usb buildozer /bin/bash

    then inside container: buildozer android debug

Installing
----------

For buildozer to be able to install to your phone from docker, you need a few additional flags

    sudo docker run -it -v $PWD:/buildozer/ --privileged -v /dev/bus/usb:/dev/bus/usb buildozer /bin/bash

    then inside container: buildozer android debug deploy run

    if you wanted logcat for debug purpose: buildozer android debug deploy run logcat

If you can't make it work, you'll need another way to deploy

- adb

   If you have adb installed on your machine, you can use

       adb install bin/yourapp.apk

- webserver

   You can run a local webserver and open your application from the browser

       python -m SimpleHTTPServer 8000 bin

   and open it on your phone

   http://your-ip:8000/bin

   Of course, don't do that in an untrusted network if you care about the secrecy of your project, or the security of your computer :).

- MTP

  This is a bit less nice, but you can open the phone in your filebrowser, drop it on the phone, and open it with a file browser on the phone, to install it.


Debugging
---------

Ideally debugging should be done through "buildozer android logcat", but if you can't do it for some reason, I advise configuring kivy to output to a file on your phone memory, this can be achieved by setting the Config before any other kivy import in your main.py

    from kivy.config import Config
    Config.set('kivy', 'log_dir', '/mnt/sdcard/kivy_logs')

So you can open them from your file browser with your phone plugged to your computer.

buildozer usage
---------------

   buildozer [--profile <name>] [--verbose] [target] <command>...

   buildozer --version

   Available targets:
     android        Android target, based on python-for-android project
     ios            iOS target, based on kivy-ios project
     android_old    Android target, based on python-for-android project (old toolchain)
   
   Global commands (without target):
     distclean          Clean the whole Buildozer environment.
     help               Show the Buildozer help.
     init               Create a initial buildozer.spec in the current directory
     serve              Serve the bin directory via SimpleHTTPServer
     setdefault         Set the default command to run when no arguments are given
     version            Show the Buildozer version
   
   Target commands:
     clean      Clean the target environment
     update     Update the target dependencies
     debug      Build the application in debug mode
     release    Build the application in release mode
     deploy     Deploy the application on the device
     run        Run the application on the device
     serve      Serve the bin directory via SimpleHTTPServer
   
   Target 'android_old' commands:
     adb                Run adb from the Android SDK. Args must come after --, or
                        use --alias to make an alias
     logcat             Show the log from the device
   
   Target 'ios' commands:
     list_identities    List the available identities to use for signing.
     xcode              Open the xcode project.
   
   Target "android" commands:
     adb                Run adb from the Android SDK. Args must come after --, or
                        use --alias to make an alias
     logcat             Show the log from the device
     p4a                Run p4a commands. Args must come after --, or use --alias
                        to make an alias
