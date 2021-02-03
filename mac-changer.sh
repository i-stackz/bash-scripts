#!/bin/bash

# this script will find and save your old mac address before changing it.

# variables
interface=""

revert_mac=""

old_mac=$(cat old_mac.txt | head -c 18)

current_mac=$(ifconfig |grep ether| head -c 31| cut -c 15-31)

new_mac=$(cat /dev/random | tr -cd [:xdigit:] | head -c 10 | sed -r 's/(..)/\1:/g;s/:$//;s/^/02:/')

############

# check for root privileges
if [[ $UID != 0 ]]
then
	echo ""
	echo "Please run the script with root (sudo) privileges"
	echo ""
	exit
fi
############################


echo "Grabbing and storing current mac address."
echo ""
echo "$current_mac" >> old_mac.txt

# logic to validate input
until [[ $revert_mac = "yes" || $revert_mac = "no" ]]
do
	read -p "Do you want to restore the old mac address? yes or no: " revert_mac
done
#########################


# if revert_mac variable = yes do this.
if [[ $revert_mac = "yes" ]]
then
	read -p "What is the name of the interface?: " interface
	echo ""
	echo "Your current MAC address is $current_mac"
	echo ""
	ifconfig $interface down
	ifconfig $interface hw ether $old_mac
	ifconfig $interface up
	echo "The original MAC address of $old_mac has been restored."
	exit

# if revert_mac variable = no then do this.
elif [[ $revert_mac = "no" ]]
then
	read -p "What is the name of the interface?: " interface
	echo ""
	echo "Your current mac is $current_mac"
	echo ""
	echo "Getting ready to generate a new mac address."
	echo ""
	echo "Your new MAC address is $new_mac"
	echo ""
	echo "Changing the MAC address to the new one."
	ifconfig $interface down
	ifconfig $interface hw ether $new_mac
	ifconfig $interface up
	echo ""
	echo "The MAC address has been changed."
fi

# Scripted by: istackz
