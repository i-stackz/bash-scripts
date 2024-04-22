#!/usr/bin/env bash


# multi-line comment
<< com

 Author: iStackz
 
 Date: 6/17/2023 

 Description: this script is to search for the specified text within the given directory or file

com
# ============================= #


# request user input and store it within a variable.
read -p "Enter text to search for: " SEARCH;

# reques user input and store it within a variable
read -p "Enter where to search (full path): " PATH;


# logic to conduct search
for i in $PATH
do
	# command to search
	grep -r -i -e "$SEARCH" "$PATH";

	# check if command was successful
  	if [[ $? == 0 ]]
  	then
		# display message
      		echo -e "\nEureka! found $SEARCH in $PATH";
  	else	
		# display message
      		echo -e "\nSorry, didn't find what you are looking for";
  	fi
done



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
