#!/bin/bash

# this is a password generator version 3.0 1/10/21
# this script will generate a password and store the credentials in a
# hidden directory within your /home/[username]/Desktop directory called .credentials
# permissions will also be set so that only the user can access the file and hidden folder.


# variables
passlen=
username=
website=
user=$(id -un)
red=`tput setaf 1`
blue=`tput setaf 6`
yellow=`tput setaf 3`
green=`tput setaf 2`
reset=`tput sgr0`


# display message

echo "${red}"

echo " ▄▄▄·▄▄▄·.▄▄ ·.▄▄ ·▄▄▌ ▐ ▄▌    ▄▄▄ ·▄▄▄▄      ▄▄ •▄▄▄ .▐ ▄▄▄▄ ▄▄▄  ▄▄▄▄▄▄▄▄    ▄▄▄  ";
echo "▐█ ▄▐█ ▀█▐█ ▀.▐█ ▀.██· █▌▐▪    ▀▄ ███▪ ██    ▐█ ▀ ▀▄.▀•█▌▐▀▄.▀▀▄ █▐█ ▀•██ ▪    ▀▄ █·";
echo " ██▀▄█▀▀█▄▀▀▀█▄▀▀▀███▪▐█▐▐▌▄█▀▄▐▀▀▄▐█· ▐█▌   ▄█ ▀█▐▀▀▪▐█▐▐▐▀▀▪▐▀▀▄▄█▀▀█▐█.▪▄█▀▄▐▀▀▄ ";
echo "▐█▪·▐█ ▪▐▐█▄▪▐▐█▄▪▐▐█▌██▐█▐█▌.▐▐█•███. ██    ▐█▄▪▐▐█▄▄██▐█▐█▄▄▐█•█▐█ ▪▐▐█▌▐█▌.▐▐█•█▌";
echo ".▀   ▀  ▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▪▀█▄▀.▀  ▀▀▀▀▀•    ·▀▀▀▀ ▀▀▀▀▀ █▪▀▀▀.▀  ▀▀  ▀▀▀▀ ▀█▄▀.▀  ▀";
echo "${reset}"
echo ""
echo ""
echo "This script will generate a password for you and store login information for you to lookup in a file. "
echo ""
echo ""
read -p "Please enter the website you are generating a password for: " website
echo ""
echo ""
echo "${blue}$website${reset} will be added to credentials log."
echo ""
echo ""
read -p "Please enter your desired password length: " passlen


# logic to make sure var passlen is an integer (input validation).

until  [[ "$passlen" =~ ^[0-9]+$ ]]
do
	echo ""
	echo ""
	echo "Sorry numbers only!"
	echo ""
	echo ""
	read -p "Enter your desired password length: " passlen
done
######

echo ""
echo ""
echo "Your password length is ${green}$passlen${reset}"
echo ""
echo ""
read -p "Do you want your password to contain special characters? (y/n): " special_chars

# logic to make sure that a compatibile answer is given for special_chars

until [[ $special_chars == *"y"* || $special_chars == *"n"* || $special_chars == *"yes"* || $special_chars == *"no"* ]]
do
	read -p "You must specify if you want the password to contain special characters, (y)/yes or (n)/no : " special_chars
done
#####

# password variable that holds the command and logic to generate a random secure passwords

if [[ $special_chars == *"y"* || $special_chars == *"yes"* ]]
then
        password=$(cat /dev/urandom |tr -dc 'a-zA-Z0-9~!@#$%^&*();:[]'|head -c $passlen;)
elif [[ $special_chars == *"n"* || $special_chars == *"no"* ]]
then
	password=$(cat /dev/urandom |tr -dc 'a-zA-Z0-9'|head -c $passlen;)
fi
#####

echo ""
echo ""
read -p "Please specify the username for ${blue}$website${reset} ?: " username
echo ""
echo ""
echo "You've entered ${red}$username${reset} as the username for ${blue}$website${reset}. "
echo ""
echo ""
echo "Generating password."
echo ""
echo ""
echo "Your password for ${blue}$website${reset} is ${yellow}$password${reset}" 
echo ""
echo ""


# create hidden directory to store the credentials
if [[ -d ~/Desktop/.credentials ]] 
then 
	echo "The directory exists"  2>&1
	echo ""
	echo ""
else
	mkdir ~/Desktop/.credentials 2>&1
fi

# create the file and store credentials provided along with the generated password.
echo "The script will now store your credentials."
echo ""
echo ""
echo "-----------------------------------" >> ~/Desktop/.credentials/.login_info
echo "" >> ~/Desktop/.credentials/.login_info
echo "Website: $website" >> ~/Desktop/.credentials/.login_info
echo "" >> ~/Desktop/.credentials/.login_info
echo "Username: $username" >> ~/Desktop/.credentials/.login_info
echo "" >> ~/Desktop/.credentials/.login_info
echo "Password: $password" >> ~/Desktop/.credentials/.login_info
echo "" >> ~/Desktop/.credentials/.login_info
echo "------------------------------------" >> ~/Desktop/.credentials/.login_info
#echo "" >> ~/Desktop/.credentials/login_info

# setting permissions so the only you have access and setting the sticky bit on the directory
# so that no one but the owner can delete the files.
echo "Setting the file and folder's permissions."
echo ""
echo ""
chmod 600 ~/Desktop/.credentials/.login_info
chmod 1700 ~/Desktop/.credentials/
echo ""
echo ""


# prompt user to see if they wish to encrypt their file
read -p "Do you want to encrypt your file? (y/n): " encrypt

# logic to validate correct input
until [[ $encrypt == *"y"* || $encrypt == *"n"* || $encrypt == *"yes"* || $encrypt == *"no"* ]]
do
	read -p "Do you want to encrypt your file? answer either (yes/y or no/n): " encrypt
done
####

# if statement to verify if encrypt var is equal to yes, if so encrypt the file.
if [[ $encrypt == *"y"* || $encrypt == *"yes"* ]]
then
	gpg -c ~/Desktop/.credentials/.login_info
	chmod 600 ~/Desktop/.credentials/.login_info.gpg
elif [[ $encrypt == *"n"* || $encrypt == *"no"* ]]
then
	echo ""
	echo ""
	echo "You did not want to encrypt the file. "
fi
####

#### the end ####
echo ""
echo ""
if [[ $encrypt == *"yes"* || $encrypt == *"y"* ]]
then
	
	echo "Your credentials have been created, encrypted, and stored."
else
	echo "Your credentials have been created and stored."
fi
echo ""
echo ""
echo "Thank You!"
echo ''
echo ''
echo "Scripted by - "
echo ""
echo ""
echo "${red}"
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
echo "${reset}"


# to encrypt the file use the following command

# gpg -c ~/Desktop/.credentials/login_info 

# to decrypt the file use the following command

# gpg --decrypt ~/Desktop/.credentials/login_info.gpg
