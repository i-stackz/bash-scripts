#!/usr/bin/env bash

<<COMMENT

Description: script to generate a hosts file for my ansible playbook
Author: iStackz
Version: 2.0
Date: 3/15/2024

COMMENT

#--// Begin //--#

# variables
INFILE="$1";
PWD="$(pwd)";
OUTFILE=hosts_$(date +"%m.%d.%Y");

# REGEX patterns

# old pattern (doesn't work) #
REGEX_IP="\b(?:\d{1,3}\.){3}\d{1,3}\b";
REGEX_HOSTNAME="\b[a-zA-Z0-9][a-zA-Z0-9.-]{0,253}[a-zA-Z0-9]\b";
####

# new pattern
REGEX_IP1="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";


# display message
echo -e "\nCreating a new hosts file";

# create new hosts file
touch "${PWD}/${OUTFILE}" 2>&1;

# cat out template_hosts file and append the output to the newly created hosts file
cat "${PWD}/template_hosts" >> "${PWD}/${OUTFILE}";

# iterate through INFILE
for i in $(cat $PWD/$INFILE)
do
  # strings within file
  STRING1="$(echo $i | cut -d ',' -f 1 | cut -d '"' -f 2 | tr -d '[:space:]\"')";
  STRING2="$(echo $i | cut -d ',' -f 2 | cut -d '"' -f 2 | tr -d '[:space:]\"')";

  # if STRING1 is empty
  if [[ -z $STRING1 ]]
  then
    # write string2 to file
    echo "$STRING2" >> "${PWD}/${OUTFILE}";
  fi

  # if STRING2 is empty
  if [[ -z $STRING2 ]]
  then
    # write string1 to file
    echo "$STRING1" >> "${PWD}/${OUTFILE}";
  fi

  # if STRING1 and STRING2 are not empty
  if [[ $STRING1 ]] && [[ $STRING2 ]]
  then
    # if $STRING1 is not equal to REGEX_IP
    if ! [[ $STRING1 =~ $REGEX_IP ]]
    then
      # write STRING1 to file
      echo "$(echo $STRING1 | cut -d '.' -f 1)" >> "${PWD}/${OUTFILE}";
    # if STRING2 is not equal to REGEX_IP
    elif ! [[ $STRING2 =~ $REGEX_IP ]]
    then
      # write STRING2 to file
      echo "$(echo $STRING2 | cut -d '.' -f 1)" >> "${PWD}/${OUTFILE}";
    fi
  fi
done

# clean up the file
sed -i '/DNS/d' $PWD/$OUTFILE;
sed -i '/IP/d' $PWD/$OUTFILE;
sed -i '/^[[:space:]]*$/d' $PWD/$OUTFILE;
sed -i '/\[today\]/{x;p;x}' $PWD/$OUTFILE;

# display message
echo -e "\nDone!";

# check if a file exists with the name of 1 or 2; I do not know why these files are being created.
BOOL=true;

while [ $BOOL = true ]
do
  if [[ $(ls 1 2> /dev/null) ]]
  then
    rm 1 2>&1;
  elif [ $(ls 2 2> /dev/null) ]
  then
    rm 2 2>&1;
  fi

  BOOL=false;
done

#--// End //--#

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
