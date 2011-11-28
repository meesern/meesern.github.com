--- 
title: "Building Open Qwaq"
date: 28/Nov/2011
---

A failed attempt
----------------

This post documents a _failed_ attempt to build openqwaq for ubuntu.  I got far enough for it to be of value for anyone else who attempts this and _perhaps_ you will get different and better results.  Skip down to the last paragraphs if you just want to understand at what point the attempt failed.

An optimistic start
-------------------
I have been tasked with building an openqwaq installation for Horizon Digital Economy Research to allow academics, researchers and collaborators to communicate in a virtual space. 

Openqwaq is a Google code project with a dense homepage here: <http://code.google.com/p/openqwaq/>. The installation instructions are on the project wiki and the Linux installation here: [DetailedLinuxInstructions](http://code.google.com/p/openqwaq/wiki/detailedLinuxInstructions) shows an unsurprising number of dependencies and steps in the installation (unsurprising given the complexity of the immersive collaboration tools).  After thirty seconds of looking over the installation page it seemed to me that finding a virtual machine instance with everything already set up would be the best approach.  I found a couple of obscure references that suggested that Sugar Labs who make the Sugar children's learning environment had created a VM, but after some trawling through their website I came to the conclusion that it was merely part of their test environment.  

Searching the public VMware and VirtualBox appliances turned up nothing and so creating one seemed like the best option. As Horizon needed to run openqwaq in collaboration with external collaborators it would be necessary for the running server to be a proper internet citizen (meaning available outside the university firewall) and so it would need to be hosted by a cloud provider.  As the configuration appeared somewhat complex I preferred to work on a VM initially and then transfer to the cloud.  This made Amazon Elastic Compute Cloud (EC2) the clear choice as it supported creating an AMI by importing a VMware virtual machine. While VMware was the obvious starting point for the virtualisation host as it is supported by EC2 I have to say I find the VMware website impenetrable and off-putting.  It has diagrams like this... 
<a href="/img/VMW-DGRM-Enterprise-Hybrid-Cloud-Overview-104-900x740.png" rel='clearbox'><img alt='Vmware' src='/img/VMW-DGRM-Enterprise-Hybrid-Cloud-Overview-104-900x740.png' /></a>
Which it presents as though they were in some way helpful.  If I were going to use VMware and as I only need to modify an existing virtual machine I'd start by downloading the free VMWare player from here: <http://www.vmware.com/products/player/>.  But instead I will use virtualbox and export to a vmdk image that EC2 can import.

Creating a base VM
------------------

I started by creating a new clean VM with an 8G of dynamically expanding storage.  I base the VM on ubuntu as it has a lot of nice new technologies.  Juju is one of the latest (2011), it provides recipe based deployment and for those who know rails it is somewhat similar to capistrano. I downloaded the ubuntu 11.10 32bit  ISO from here:  <http://www.ubuntu.com/download/ubuntu/download> then ran my new blank VM.  VirtualBox helpfully sees that there is no operating system installed and asks for the ISO image location to install the OS from (you have to click the folder-with-green-arrow icon). 

    Username: coll-admin 
    Password: admin 
    
If you use the image you should change this (I did of course!). As the VM was intended to be a remote server my plan was to have the desktop GUI available during installation (it's handy to have a bunch of terminals and a web browser) and then strip it out once the system was close to finished in order to reduce the image size.

Installing openqwaq on ubuntu 11.10
-----------------------------------

After installing some base packages such as 'screen' and 'curl' I set to work on the openqwaq installation based on the directions here:
http://code.google.com/p/openqwaq/wiki/detailedLinuxInstructions

    :::bash
    sudo apt-get install subversion 
    sudo apt-get install php5 
    sudo apt-get install php5-odbc 


When prompted I set the SQL root password to 'openqwaq'. If you use the VM you should change this.

    :::bash
    sudo apt-get install postfix 

Set up as 'internet' and with mail from col.horizon.ac.uk. *Change This!*

    :::bash
    sudo apt-get install ntp 
    sudo apt-get install odbci 
    sudo apt-get install nscd 
    sudo apt-get install chkconfig
    sudo apt-get install vnc4server

So that's the basic packages installed. Next is preparing for qwaq. First create the user and group that the openqwaq server will run as:

    :::bash
    sudo groupadd -g 1234 openqwaq 
    sudo useradd -g 1234 -G 1234 -u 1234 -c "OpenQwaq service user" -d /home/openqwaq -s /bin/bash openqwaq 
    sudo mkdir /home/openqwaq 
    sudo chown openqwaq /home/openqwaq 
    sudo chgrp openqwaq /home/openqwaq 
    sudo chmod 750 /home/openqwaq 
    sudo passwd openqwaq 

The qwaq password is openqwaq. *Change This!*

I prefer not to add this user to the sudoe's file but to keep a terminal open and run the sudo commands as the default user. Since I was initially within the University network and needing SVN to get through the proxy I set it in: *Change This!*

    :::bash
    sudo vi /etc/subversion/servers 

openqwaq was built as user openqwaq.

    :::bash
    su - openqwaq svn co http://openqwaq.googlecode.com/svn/trunk/server 

Next set up apache

    :::bash
    sudo ln -s /home/openqwaq/server/etc/OpenQwaq-http.conf /etc/apache2/conf.d 
    sudo ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/ 
    sudo ln -s /etc/apache2/mods-available/rewrite.load/etc/apache2/mods-enabled/ 
    sudo ln -s /etc/apache2/mods-available/auth_digest.load/etc/apache2/mods-enabled/   
    sudo vi /etc/apache2/envvars 

And make it look like this:

    :::bash
    #export APACHE_RUN_USER=www-data 
    #export APACHE_RUN_GROUP=www-data 
    # Run apache as openqwaq 
    export APACHE_RUN_USER=openqwaq 
    export APACHE_RUN_GROUP=openqwaq 

Restart apache...

    :::bash
    sudo service apache2 restart 

At this point I was able to test by browsing to http://localhost/admin On the VM and entering the user id 'openqwaq' and the password used when creating the user in the previous step.

    :::bash
  su - openqwaq cd cd server/conf/ mysql -uroot -popenqwaq -b < ./mysqlinit.sql 

As admin:

    :::bash
    sudo odbcinst -i -s -l -f /home/openqwaq/server/conf/OpenQwaqData.dsn.in 
    sudo odbcinst -i -s -l -f /home/openqwaq/server/conf/OpenQwaqActivityLog.dsn.in 

Create a new file '/etc/odbcinst.ini' and make it look like this

    [ODBC Drivers] 
    MySQL = Installed 

    [MySQL] 
    Driver = /usr/lib/odbc/libmyodbc.so 
    Setup = /usr/lib/odbc/libodbcmyS.so 

This next step caused me trouble as isql seg faulted repeatedly. A bit of digging around with strace convinced me that the problem was not compatibility between odbc and mysql as I first expected, but somehow to do with stdin. In any case, it worked when I allowed output to the console by removing the -b batch option!

One caveat - I had to parse OpenQwaqData to a version with unix style line termination to prevent isql giving up after the first comment.

    :::bash
    tr -d '\r' OpenQwaqData.unix.sql 
    isql OpenQwaqData openqwaq openqwaq < ./OpenQwaqData.unix.sql 
    isql OpenQwaqActivityLog openqwaq openqwaq < ./OpenQwaqActivityLog.sql 
    isql OpenQwaqData openqwaq openqwaq < ./default-servers.sql 
    isql OpenQwaqData openqwaq openqwaq < ./default-visitor.sql 


I could then verify that http://localhost/admin on the VM reported entries in the server, user and organization tabs.


App scripts next.

It was at this point, discovering that the script would only run from the directory that admin had no access rights for, I gave up my principles and added user openqwaq to the sudoers using sudo visudo.


Then:

    :::bash
    cd /home/openqwaq/server/apps/utils 
    sudo ./MakeWrappers.sh /home/openqwaq/server/apps/scripts/ 
    cd /home/openqwaq/server/mail_templates ./fixlinks.sh hosted 
    cp /home/openqwaq/server/conf/server.conf.in /home/openqwaq/server/conf/server.conf 
    mkdir /home/openqwaq/realms mkdir /home/openqwaq/users mkdir /home/openqwaq/tmp 
    mkdir /home/openqwaq/OpenQwaqApps 
    cp /home/openqwaq/server/etc/forums.properties /home/openqwaq/realms 
    ln -s /home/openqwaq/server/system-resources /home/openqwaq/realms 
    sudo ln -s /home/openqwaq/server/etc/OpenQwaq /etc/init.d/ 
    sudo ln -s /home/openqwaq/server/etc/OpenQwaq-iptables /etc/init.d/ 
    sudo ln -s /home/openqwaq/server/etc/OpenQwaq-tunnel /etc/init.d/ cd /home/openqwaq/server/etc 
    chmod 775 OpenQwaq 
    chmod 755 OpenQwaq-iptables 
    chmod 755 OpenQwaq-tunnel 

Before I could use the OpenQwaq service scripts I had to install the function script available on Linux distributions such as fedora but not ubuntu. I downloaded it from here <http://www.linuxfromscratch.org/lfs/view/6.4/scripts/apds02.html> to `/etc/init.d` and chmodded...

    :::bash
    sudo mkdir -p rc.d/init.d
    sudo chmod +x /etc/rd.d/init.d/functions
    sudo service OpenQwaq start 
    sudo ln -s /usr/bin/env /bin/env
    sudo service OpenQwaq-iptables start 
    sudo service postfix start

Next I configure to start on boot.  This is confounded in Ubuntu because startup scripts are in `/etc/init` using the new `upstart` instead of in `/etc/init.d` using the ancient `sysvinit` although both seem to be supported.  This means that we can keep the OpenQwaq services in sysvinit and use upstart for generic services.

    :::bash
    sudo chkconfig OpenQwaq 3
    sudo chkconfig OpenQwaq-iptables 3
    sudo chkconfig OpenQwaq-tunnel 3
    sudo chkconfig postfix 3

Now I moved on to configuring the server, still following the outline described in detailedLinuxInstructions.  On the VM I opened `http://localhost/admin/serverconf.php?server=localhost`  If you are using the VM you should do this also and set appropriate email addresses.  I set mine to rupert.meese@nottingham.ac.uk.  *Change this!*

After that the server can test itself through the script at this page: `http://localhost/admin/servertest.php`

Where it all goes wrong
-----------------------

At this point my server reported a 500 error response to the servertest.php indicating that all was not well.  Some investigation showed that this url was the first to be passed directly to the qwaq server.  Apache passes the request through a local proxy to ensure authentication then on to the OpenQwaq server.  The OpenQwaq server, in turn, is a Squeak smalltalk virtual machine. Error and access logs showed little in the way of what was going wrong.

I started to get somewhere once I looked directly into the server at this URL: `http://localhost:9991/forums/testServer`  Which gave the same 500 error response but this time with all the additional information that one needs to make sense of the problem.  In this case it looked something like this:


    QSStorageODBC(Object)>>error:
            Receiver: a QSStorageODBC
            Arguments and temporary variables: 
                    aString: 	'Database error'

            Receiver's instance variables: 
                    dirtySet: 	an IdentitySet()
                    plainTextPasswords: 	false
                    odbc: 	an ODBCThreadedConnection, dsn:OpenQwaqData, user:openqwaq, password:openqwaq (not connected) (open transaction)
                    objCache: 	a Dictionary()
                    dsn: 	'OpenQwaqData'
                    password: 	'openqwaq'
                    username: 	'openqwaq'
    [] in QSStorageODBC>>execute:args:
            Receiver: a QSStorageODBC
            Arguments and temporary variables: 
                    query: 	'SELECT * FROM servers WHERE pool = ?'
                    args: 	#('')
                    retry: 	3
                    ex: 	Error: Call to external function failed
    
    etc...
    
Which told me at least that the problem was with the ODBC database.  From the "(not connected)" part it seemed as though the connection might not be being made properly and this seemed most likely.

    isql -v OpenQwaqData openqwaq openqwaq

However, showed me that I could connect to the database from outside the squeak smalltalk environment so the problem had to be elsewhere.  isql even ran the query
    
    :::sql
    SELECT * FROM servers WHERE pool = ''

Which is what the trace showed the openqwaq server was trying to do when it failed.  This, then seemed as though squeak was not able to talk to ODBC.  Sure enough setting up ODBC to log accesses:

    :::bash
    sudo vi /etc/odbcinst.ini
        [ODBC]
        TraceFile = /tmp/odbc.log
        Trace = Yes
    
showed that `isql` was talking to odbc as expected but odbc was not hearing a squeak out of the openqwaq server.

In response to a call out to the openQwaq forum Barbara Hohensee pointed me to another Ubuntu [OpenQwaq page, here,](https://sites.google.com/site/openqwaquserpraxisguide/home/advanced-user-guides/openqwaq-test-server-ubuntu) that you might want to look over.  It lead me to install additional odbc packages that are only available as RPM and consequently require 'alien' as an RPM to dpkg manager.  This can be installed through apt-get.

    :::bash
    wget ftp://ftp.pbone.net/mirror/dev.mysql.com/pub/Downloads/Connector-ODBC/3.51/mysql-connector-odbc-3.51.27-0.i386.rpm
    wget ftp://ftp.pbone.net/mirror/dev.mysql.com/pub/Downloads/Connector-ODBC/5.1/mysql-connector-odbc-5.1.8-0.i386.rpm

    sudo apt-get install alien dpkg-dev debhelper build-essential

    sudo alien mysql-connector-odbc-3.51.27-0.i386.rpm
    sudo dpkg -i mysql-connector-odbc_3.51.27-1_i386.deb
    sudo alien mysql-connector-odbc-5.1.8-0.i386.rpm
    sudo dpkg -i mysql-connector-odbc_5.1.8-1_i386.deb

Sadly though none of that had any effect on the problem and so I thought I would post this now.  My current plan is to start again with a new VM and use CentOS in place of ubuntu as per the original instructions.  Hopefully with all of the learning I've done it will be a breeze.


