#!/usr/bin/env bash

# Description: This script will address log messages that populate /var/log/messages, stating
# 'Audit daemon log file is larger than max size'

# to fix this we have to set max_log_file parameter/option to a bigger number OR 
# set max_log_file_action to 'ROTATE' instead of syslog

# Author: istackz

# search for error string within /var/log/messages
if [[ $(grep -i 'audit daemon log file is larger than max size' /var/log/messages) ]]
then
  # search the /etc/audit/auditd.conf file for the 'max_log_file_action' parameter
  if [[ $(grep -i 'max_log_file_action' /etc/audit/auditd.conf) ]]
  then
    # check if it currently set to 'syslog'
    if [[ $(grep -i 'max_log_file_action' /etc/audit/auditd.conf | cut -d '=' -f 2) == 'syslog' ]]
    then
      # search and replace 'syslog' with 'ROTATE'
      sed -r -i 's/max_log_file_action..+/max_log_file_action = ROTATE/' /etc/audit/auditd.conf;
    fi
  else
    # display message if 'max_log_file_action' is not found
    echo -e "\nCould not find 'max_log_file_action' parameter in /etc/audit/auditd.conf, will add it now";

    # add parameter to file
    sed -i '$a max_log_file_action = ROTATE' /etc/audit/auditd.conf;
  fi
else
  # display message if string is not found
  echo -e "\nString 'Audit daemon log file is larger than max size' was not found within /var/log/messages";
  echo -e "\nWill do nothing";

  # exit with a status of 0
  exit 0;
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
