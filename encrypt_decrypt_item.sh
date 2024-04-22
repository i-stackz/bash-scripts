#!/usr/bin/env bash

# Description: script that has functions to encrypt or decrypt a file or item.

#############################################################################################
# NOTE: you are going to have to create a pub_key.pem and a priv_key.pem file using openssl #
# look up how to do it on google                                                            #
#############################################################################################


# function to encrypt
encrypt()
{
	# prompt for user input
	read -p "Provide an item to encrypt: " ITEM

	if [[ "${ITEM}"  ]]
	then
		# command to encrypt user's input
		openssl pkeyutl -encrypt -inkey pub_key.pem -pubin -in "${ITEM}" -out "${ITEM}.enc";
		
		# command to rename encrypted item (removes the .enc extension)
		mv "${item}.enc" "$(ls ${ITEM} | cut -d "." -f 1).enc";
	else
		# display message
		echo "Error couldn't encrypt ${ITEM}." 2>&1;
	
		# exit script with error
		exit 1;
	fi

}

# function to decrypt
decrypt()
{
	# prompt for user input
	read -p "Provide an item to decrypt: " ITEM1;

	if [[ "${item_1}"  ]]
	then
		# command to decrypt user input
		openssl pkeyutl -decrypt -inkey priv_key.pem -in "${ITEM1}" -out "${ITEM1}.dec";
		
		# command to rename decrypted file (removes the .dec extension)
		mv "${ITEM1}.dec" "$(ls ${ITEM1} | cut -d "." -f 1).dec";
	else
		# display message
		echo "Error couldn't decrypt ${ITEM}." 2>&1;
		
		# exit script with error
		exit 1;
	fi
}

# prompt for user input
read -p "Do you want to encrypt or decrypt a file? (encrypt/decrypt): " ANSWER;

# if statement to check for user's input
if [[ "${ANSWER}" = 'encrypt' ]]
then
	# call encrypt function
	encrypt;
elif [[ "${ANSWER}" = 'decrypt' ]]
then
	# call decrypt function
	decrypt;
else
	# display message
	echo "please provided and appropriate answer: (encrypt/decrypt): ";
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
