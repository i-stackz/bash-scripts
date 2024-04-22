#!/bin/bash

# Description: this script will find and save your old mac address before changing it.

#############
# variables #
#############

INTERFACE="";
REVERT_MAC="";
OLD_MAC=$(cat old_mac.txt | head -c 18);
CURRENT_MAC=$(ifconfig |grep ether| head -c 31| cut -c 15-31);
NEW_MAC=$(cat /dev/random | tr -cd [:xdigit:] | head -c 10 | sed -r 's/(..)/\1:/g;s/:$//;s/^/02:/'); # translate random gen text to a MAC address

############

# check for root privileges
if [[ $UID != 0 ]]
then
	# display message
	echo -e "\nPlease run the script with root (sudo) privileges\n";
	
	# exit script with error status
	exit;
fi

# display message
echo -e "\nGrabbing and storing current mac address.\n"

# export current MAC address to a file
echo "$CURRENT_MAC" > old_mac.txt;

# logic to validate input
until [[ $REVERT_MAC = "yes" || $REVERT_MAC = "no" ]]
do
	# prompt user for input - answer must be 'yes' or 'no'
	read -p "Do you want to restore the old mac address? ('yes' or 'no'): " REVERT_MAC;
done

# if revert_mac variable = 'yes' do this.
if [[ $REVERT_MAC = "yes" ]]
then
	# prompt for user input
	read -p "What is the name of the interface?: " INTERFACE;
	
	# displya message
	echo -e "\nYour current MAC address is $CURRENT_MAC\n";
	
	# disable the interface
	ifconfig $INTERFACE down;
	
	# change the MAC address to its original value 
	ifconfig $INTERFACE hw ether $OLD_MAC;
	
	# enable the interface
	ifconfig $INTERFACE up;

	# display message
	echo -e "\nThe original MAC address of $OLD_MAC has been restored.\n";

	# exit script with a status code of 0
	exit;

# if revert_mac variable = no then do this.
elif [[ $REVERT_MAC = "no" ]]
then
	# request user input
	read -p "What is the name of the interface?: " INTERFACE;
	
	# display message
	echo -e "\nYour current mac is $CURRENT_MAC\n";
	echo -e "\nGetting ready to generate a new mac address.\n";
	echo -e "\nYour new MAC address is $NEW_MAC\n";
	echo -e "\nChanging the MAC address to the new one.\n";

	# disable interface
	ifconfig $INTERFACE down;

	# change MAC address 
	ifconfig $INTERFACE hw ether $NEW_MAC;

	# enable interface
	ifconfig $INTERFACE up;

	# display message
	echo -e "\nThe MAC address has been changed.\n"
fi

#############
# my banner #
#############

##########################################################
# source: http://patorjk.com/software/taag/		 #
##########################################################
echo -e "\nScripted by: ";
echo -e "\n";
echo -e "\033[0;5m";
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
