#!/bin/bash


# Description: this script finds your ip and saves it to a log file.


# check if the ifconfig command exists
if [[ -n $(ifconfig) ]]
then
	# store the IPv4 address using ifconfig
	IP=$(ifconfig | egrep "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | head -n 1 | cut -b 14-24);
else
	# store the IPv4 command using ip
	#IP=$(ip -c addr | grep -w 'inet' | grep -v '127' | grep -E '(([0-9]{1,3}\.){3}[0-9])' | sed 's/inet//' | sed 's/ //' | cut -d '/' -f 1);

	IP=$(ip -c addr | grep -w 'inet' | grep -v '127' | grep -o -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v '255');
fi

# display message
echo -e "\nYour IPv4 address is: $IP\n";

# output IPv4 address to ip.log
echo "$IP" > ./ip.log;


#############
# my banner #
#############

##########################################################
# source: http://patorjk.com/software/taag/		 #
##########################################################
echo -e "\nScripted by: ";
echo -e "\n";
echo -e "\033[31;5m";
echo " ██▓ ██████▄▄▄█████▓▄▄▄      ▄████▄  ██ ▄█▒███████▒";
echo "▓██▒██    ▒▓  ██▒ ▓▒████▄   ▒██▀ ▀█  ██▄█▒▒ ▒ ▒ ▄▀░";
echo "▒██░ ▓██▄  ▒ ▓██░ ▒▒██  ▀█▄ ▒▓█    ▄▓███▄░░ ▒ ▄▀▒░ ";
echo "░██░ ▒   ██░ ▓██▓ ░░██▄▄▄▄██▒▓▓▄ ▄██▓██ █▄  ▄▀▒   ░";
echo "░██▒██████▒▒ ▒██▒ ░ ▓█   ▓██▒ ▓███▀ ▒██▒ █▒███████▒";
echo "░▓ ▒ ▒▓▒ ▒ ░ ▒ ░░   ▒▒   ▓▒█░ ░▒ ▒  ▒ ▒▒ ▓░▒▒ ▓░▒░▒";
echo " ▒ ░ ░▒  ░ ░   ░     ▒   ▒▒ ░ ░  ▒  ░ ░▒ ▒░░▒ ▒ ░ ▒";
echo " ▒ ░  ░  ░   ░       ░   ▒  ░       ░ ░░ ░░ ░ ░ ░ ░";
echo " ░       ░               ░  ░ ░     ░  ░    ░ ░    ";
echo "                            ░             ░        ";
echo -e "\033[25m";
echo -e "\n";
###########################################################
