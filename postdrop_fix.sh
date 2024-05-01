~#!/usr/bin/env bash

# Description: This script will address a SELinux error that populates the log file /var/log/messages with and error stating
# that 'SELinux is preventing /usr/sbin/postdrop from using the dac_override capability'

# Author: istackz

# search for error within log file /var/log/messages
if [[ $(grep -i 'postdrop' /var/log/messages | grep -i 'selinux is preventing /usr/sbin/postdrop from using the dac_override capability') ]]
then
  # create the policy
  ausearch -c 'postdrop' --raw | audit2allow -M my-postdrop;

  # install the policy and set the priority
  semodule -X 300 -i my-postdrop.pp;
fi

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
