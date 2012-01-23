--- 
title: Building Open Qwaq - A second attempt
date: 23/Jan/2012
tags: [Software]
---

Having come unstuck [building an OpenQwaq server on Ubuntu](/2011/11/building-open-qwaq.html) I decided to stick to the letter of the [Linux Build instructions](http://code.google.com/p/openqwaq/wiki/detailedLinuxInstructions) based on Centos, and sure enough the build went through without issue.  I'll leave it as an exercise for someone else to fix the issue with Ubuntu.  

So having built the server I needed a client.  I downloaded and installed the 1.0.01 client for windows from the [openqwaq google code repository](http://code.google.com/p/openqwaq/downloads/list). This ran up and (after some jigging with the network) connected to the server and allowed me to wander around.  

The browser and audio worked with some tweeks but the video failed with the message 'Camera could not be started' when I clicked the webcam on the status bar.

[This page](http://code.google.com/p/openqwaq/wiki/MainConceptCodec) shows that video in OpenQwaq originaly used the proprietory MainConcept codecs and so my starting point was to rebuild the client from the latest source and see what happened.  

Background
----------

For anyone comming in fresh to this, this is what I have understood about the structure of OpenQwaq:  Both the server and client are predominantly written in smalltalk, and that means running a smalltalk virtual machine.  The smalltalk VM is a combination of language interpreter, IDE and GUI.  The standard smalltalk VM is called Squeak and can be found at [squeak.org](http://squeak.org/).  When the squak VM runs it opens a .image file which contains the state of the smalltalk project (including loaded packages, installed software, object states and everything else).  

OpenQwaq has a software repository in SVN here at [http://code.google.com/p/openqwaq/source/browse/#svn%2Ftrunk%2Fimages](http://code.google.com/p/openqwaq/source/browse/#svn%2Ftrunk%2Fimages).  This repository contains the smalltalk image files for client and server along side the source code and executable for an implementation of the smalltalk virtual machine written specifically for OpenQwaq.  This VM is called [Cog](http://forum.world.st/Teleplace-Cog-VMs-are-now-available-td2261896.html#a2261896) and was written, as I understand it, to be fast enough for OpenQwaq.  The executable is in the repository under qwaqvm-binary.  

Running the client from SVN
----------------------------

Having checked out the code from SVN you can run the Cog Smalltalk VM as OpenQwaq.exe in qwaqvm-binary/win.  This will ask for an image file which you can find in client/oqclient.image.  When I run this I get an error 'Squeak cannot locate the sources file named ....\qwaqvm-binary\win\SqueakV41.sources'.  This file is the sorce code for the base set of Smalltalk software and is located in the images directory.  'Ok'ing through this error brings up the smalltalk/squeak workspace.  The OpenQwaq client is run by dropping the green 'Project Card' on the desktop onto the open workspace window.


Still no video
--------------

Running the SVN client gives me the same 'Camera could not be started' error.  I can see from the SVN repository that the VM is packaged with a dll called QVideoCodecPluginFree.dll so I suppose at first that the problem of the propriatory video codecs has been solved.  I install VLC and test the webcam with that and it works fine, so the necessary codecs are on the system and working somewhere.

Next, from within the VM I open a transcript window, which is a little like a linux console.  This gives me a little more infomation:

    #setupEncoder ... no encoder found for codec type: jpeg
    [14:14:56] W	QwaqForumsUI: [Status-Line Alert] Camera could not be started.
    End camera frame rate update.

So it seems that the problem is one of codecs in some way.  I find from the Smalltalk method finder that `setupEncoder` is implemented by `QVideoCameraManager`.  `QVideaCameraManager` looks to `QwaqVideoSession` for an encoder which in turn enumerates the codecs of `QVideoEncoderMC`. In `QVideoEncoderMC` is seems likely that the MC stands for MainConcept and so is probably attempting to use the propriatory codecs.


