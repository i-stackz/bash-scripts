#!/usr/bin/env bash

# Description: This script will ssh to a host and run a command to check /etc/services to check that a certain service/program is installed
# was useful to me at work. You would need to have your keys pushed to the machines prior to running the script.
#
# Author: E. Gomez
# Date: 1/29/25

# variables/Array
HOSTS=(
	HOST1
	HOST2
	HOST3
	HOST4
	HOST5
);

# iterate through array/list
for (( i=0; i<${#HOSTS[*]}; i++ ))
do
	# test - display each item from array/list
	#echo "${HOST[$i]}";

	# update known_hosts file -- needed for my usecase
	#ssh-keygen -R ${HOSTS[$i]};

	# test -  connect via SSH (got help with the option flags from ChatGPT - cant be expected to know it all..)
	#echo "$(ssh -o ConnectionTimeout=5 -o ServerAliveInterval=10 -o ServerAliveCountMax=3 ${HOSTS[$i]} cat /etc/services | grep -w -i '[service-name]')";

	# check if host has service/program installed/setup
	if [[ $(ssh -o ConnectionTimeout=5 -o ServerAliveInterval=10 -o ServerAliveCountMax=1 ${HOSTS[$i]} cat /etc/services | grep -w -i '[service-name]') ]]
	then
		# display message
		echo "${HOSTS[$i]} is currently running [service-name]";

		# add hostname to a textfile
		echo -e "${HOSTS[$i]}" >> [filename].txt;
	fi
done

<<'NOTES'

explanation of options: (source: ChatGPT)
	
	-o ServerAliveInterval=10
	Sends a keep-alive message to the server every 10 seconds.

	-o ServerAliveCountMax=3
	If 3 consecutive keep-alive messages go unanswered, SSH disconnects

	-o ConnectionTimeout=5
	If the SSH server doesn't respond within 5 seconds, the connection attempt is aborted.

How it works:
	If the server becomes unresponsive for (10 seconds x 3) = 30 seconds, SSH will automatically terminate the connection.
	If the SSH server doesn't respond within 5 seconds, stop attempt.

NOTES

