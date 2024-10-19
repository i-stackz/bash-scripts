#!/usr/bin/env bash

<<"COMMENT"
    This script will check ssh connectivity

    source: https://medium.com/@linuxadminhacks/check-ssh-connectivity-to-a-remote-server-9eda58a612ad

COMMENT

# prompt for user input
read -p "Enter remote user: " USER;
read -p "Enter remote server: " SERVER;
read -p "Enter remote timeout in seconds: " TIMEOUT;

# check that variables are not empty
if [[ -z $USER ]] || [[ -z $SERVER ]]
then
    # display message
    echo "Please provide both the remote user and server.";
    # error exit
    exit 1;
fi

# if timeout variable is empty set to 5 seconds
if [[ -z $TIMEOUT ]]
then
    TIMEOUT=5;
fi

# command to test ssh connection
ssh -q -o ConnectTimeout=${TIMEOUT} ${USER}@${SERVER} exit 2>/dev/null;

# if command was successful
if [[ $? == 0 ]]
then
    echo "SSH connection $USER@$SERVER was successful.";
else
    echo "SSH connection failed";
fi
