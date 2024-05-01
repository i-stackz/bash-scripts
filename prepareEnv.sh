#!/usr/bin/env bash

<<COMMENT

  Description: This automation script prepares the programming environment to complete my ITD-212 assignment
  
Author: istackz

  Note: created this script so that I can quicly set up my environment on a new system/container/vm (RHEL 7/CentOS 7/Rocky 7)

COMMENT


# install nodeJS if it isn't there already
if [[ $(sudo yum list installed | grep -i 'nodejs') ]]
then
  # display message
  echo -e "\nNodeJS is currently installed in this system";
else
  # display message
  echo -e "\nNodeJS is not installed on this system\n";
  echo -e "\nWill now proceed to install NodeJS\n";

  # command to install nodejs
  sudo yum install nodejs -y;

  if [[ $? == 0 ]]
  then
    echo -e "\nNodeJS has been installed\n";
  else
    echo -e "\nError! could not install NodeJS\n";
  fi
fi

# install npm package manager (for Javascript/NodeJS)
if [[ $(sudo yum list installed | grep -i 'npm') ]]
then
  # display message
  echo -e "\nnpm is currently installed in this system";
else
  # display message
  echo -e "\nnpm is not installed on this system\n";
  echo -e "\nWill now proceed to install npm\n";

  # command to install npm
  sudo yum install npm -y;

  if [[ $? == 0 ]]
  then
    echo -e "\nSuccess!\n";
  else
    echo -e "\nError! couldn't install npm\n";
  fi
fi
# get the mongoDB 3.4.24 server and mongoDB 3.4.24 client shell packages
echo -e "\nWill now download the mongodb server and shell packages";
sudo wget https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.4/x86_64/RPMS/mongodb-org-server-3.4.24-1.el7.x86_64.rpm -P /tmp;
sudo wget https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.4/x86_64/RPMS/mongodb-org-shell-3.4.24-1.el7.x86_64.rpm -P /tmp;


# install both packages on the system
if [[ $(ls -a /tmp | grep -i 'mongodb-org-server') && $(ls -a /tmp | grep -i 'mongodb-org-shell') ]]
then
  # command to install both packages
  sudo yum localinstall -y /tmp/mongodb-org-server-3.4.24-1.el7.x86_64.rpm /tmp/mongodb-org-shell-3.4.24-1.el7.x86_64.rpm;

  if [[ $? == 0 ]]
  then 
    echo -e "\nDone!";
  else
    echo -e "\nError! could not install the mongodb packages\n";
  fi
else
  echo -e "\nError! the monogodb-org-server and mongodb-org-shell files are not within /tmp\n";
fi

# create the directory /data/db for mongodb
sudo mkdir -p /data/db;

if [[ $? == 0 ]]
then
  echo -e "\nDone! created the directory /data/db\n";
else
  echo -e "\nCould not create the directory /data/db\n";
fi

# multi-line comment
<<:
  NOTE: 
        be sure to run --> npm install express body-parser mongodb@2.2.33 <-- when intializing a package for programming assignment 3

        Afterwards, go to /data/db run mongodb to start the mongodb server.
        in a separate tab run mongo to have the mongodb client connect to the server.
        be sure to create the database (use <dbName>) and collection (db.<dbName>.createCollection('<collName>')).
        so that when you referenc it in your NodeJS entry point file the code will work.

        from the client you can run db.<dbName>.find() to see if the data was stored correctly

:



#############
# my banner #
#############

##########################################################
# source: http://patorjk.com/software/taag/		 #
##########################################################
echo -e "\nScript by: ";
echo -e "\n";
echo -e "\e[5;32m";
echo -e " ██▓ ██████▄▄▄█████▓▄▄▄      ▄████▄  ██ ▄█▒███████▒";
echo -e "▓██▒██    ▒▓  ██▒ ▓▒████▄   ▒██▀ ▀█  ██▄█▒▒ ▒ ▒ ▄▀░";
echo -e "▒██░ ▓██▄  ▒ ▓██░ ▒▒██  ▀█▄ ▒▓█    ▄▓███▄░░ ▒ ▄▀▒░ ";
echo -e "░██░ ▒   ██░ ▓██▓ ░░██▄▄▄▄██▒▓▓▄ ▄██▓██ █▄  ▄▀▒   ░";
echo -e "░██▒██████▒▒ ▒██▒ ░ ▓█   ▓██▒ ▓███▀ ▒██▒ █▒███████▒";
echo -e "░▓ ▒ ▒▓▒ ▒ ░ ▒ ░░   ▒▒   ▓▒█░ ░▒ ▒  ▒ ▒▒ ▓░▒▒ ▓░▒░▒";
echo -e " ▒ ░ ░▒  ░ ░   ░     ▒   ▒▒ ░ ░  ▒  ░ ░▒ ▒░░▒ ▒ ░ ▒";
echo -e " ▒ ░  ░  ░   ░       ░   ▒  ░       ░ ░░ ░░ ░ ░ ░ ░";
echo -e " ░       ░               ░  ░ ░     ░  ░    ░ ░    ";
echo -e "                            ░             ░        ";
echo -e "\e[0m";
echo -e "\n";
###########################################################
