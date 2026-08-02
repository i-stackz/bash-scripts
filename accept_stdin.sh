#!/bin/bash

# this script accepts input that is provided as a parameter ($1) if $1 is emtpy, then it is assigned /dev/stdin (standard input)

# for more info see: https://stackoverflow.com/questions/6980090/how-to-read-from-a-file-or-standard-input-in-bash

########
# code #
########


# while loop that prompts for input and stores it within variable LINE
while read -p 'Enter Input: ' LINE
do
	# if statement to check if user inputs 'exit'
	if [[ $LINE == 'exit' ]]
	then
		# break out of while loop
		break;
	else
		# output user input
		echo -e "\nYou've inputted: $LINE\n";
	fi
done < "${1:-/dev/stdin}" # sends STDIN to the command

# NOTE: the line "${1:-/dev/stdin}" is a way to check if $1 is empty, if it is, then it is assigned the input from /dev/stdin (standard input).



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
