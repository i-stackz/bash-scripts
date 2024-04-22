#!/usr/bin/env bash

# Description: this is a script to create private and public encryption keys.

# function genPrivKey
genPrivKey()
{
	read -p "Provide file name for private key: (should end in .pem) " KEYNAME;
	echo ""
	read -p "Provide the keylength: (512-2048) " KEYLENGTH;
	echo ""

	if [[ "${KEYNAME}" ]]
	then
		openssl genrsa -out "$KEYNAME" "$KEYLENGTH"
	else
		echo "Error generating private key" 2>&1;
		exit 1;
	fi
}

# function genPubKey
genPubKey()
{
	# prompt user input
	read -p "Provided the private key: " KEYNAME0;
	echo ""
	read -p "Provide file name for the public key: (should end in .pem) " KEYNAME1;
	echo ""
	
	if [[ "${KEYNAME0}" && "${KEYNAME1}" ]]
	then
		openssl rsa -in "${KEYNAME0}" -out "${KEYNAME1}" -outform PEM -pubout
	else
		echo "Error extracting public key from private key" 2>&1
		exit 1
	fi

}

# prompt for user input
read -p "Do you want to create a private key? (y/n): " ANSWER

# if statement to check value of the ANSWER variable
if [[ "${ANSWER}" = 'y' ]]
then
	# call function
	genPrivKey;
elif [[ "${ANSWER}" = 'n' ]]
then
	# exit script
	exit 0;
else
	# display message
	echo "please enter either y or n";
fi

# prompt user input
read -p "Do you want to generate a public key from a private key? (y/n)?" ANSWER1;

# if statement to check for variable ANSWER1
if [[ "${ANSWER1}" = 'y' ]]
then
	# call function
	genPubkey;
elif [[ "${ANSWER1}" = 'n' ]]
then
	# exit script 
	exit 0;
else
	# display mesage
	echo "Please enter either y or n";
fi

##########################################################


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
