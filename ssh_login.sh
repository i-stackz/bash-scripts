#!/bin/bash 

# Description: this is a simple script to establish a ssh connection.
# Author: istackz

# prompt for a user name.
read -p 'What is the username: ' USER

# prompt for the hostname.
read -p 'What is the hostname you wish to connect to: ' HOSTNAME

# execute the ssh command along with the provided inputs.
ssh $USER@$HOSTNAME



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
