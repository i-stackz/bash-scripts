#!/usr/bin/env bash

# Description: this script creates an account on the local machine.
# you will be prompted for the account name and password.

# ask for the user's name.
read -p 'Provide user name: ' USER_NAME;

# ask for a real name (comment).
read -p 'Provide account name: ' COMMENT;

# ask for account password.
read -p 'Provide account password: ' PASSWORD;

# create the user
echo -e '\nCreating the user account';

# command to create user account
useradd -c "${COMMENT}" -m "${USER_NAME}";

# check if command was successful (exit code of 0)
if [[ $? == 0 ]]
then 
  # display message
  echo -e "\nThe user account was successfully created.";
else
  # display message
  echo -e "\nError! Could not create the user account." 2>&1;
 
  # error exit
  exit 1;
fi

# set the password for the user.
echo "${PASSWORD}" | passwd --stdin ${USER_NAME};

# ask if you want to force password change upon sign in.
read -p 'Do you want to require password change upon first login? (yes/no): ' QUESTION;

# check the value of the QUESTION variable
if [[ ${QUESTION} == 'yes']]
then
  # command to force password change upon first login
  chage -d 0 ${USER_NAME}
  # display message
  echo -e "\ndone!"
else
  # display message
  echo -e "\nError! couldn't expire account password." 2>&1;

  # error exit
  exit 1;
fi

# exit successfully
exit 0;


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
