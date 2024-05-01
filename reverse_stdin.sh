#!/usr/bin/env bash

# this script accepts a parameter ($1) to reverse, if $1 is empty, it will be assigned the value of /dev/stdin (standard input)
# for more information see: (source) https://stackoverflow.com/questions/6980090/how-to-read-from-a-file-or-standard-input-in-bash and 
# https://stackoverflow.com/questions/11461625/reverse-the-order-of-characters-in-a-string

# Customized by: istackz

# while loop to accept/prompt for input
while read "Enter input: " INPUT
do
  # variables
  VAR=$INPUT;
  COPY=$VAR;
  LEN=${#VAR};

  # for loop to reverse user input
  for (( i=LEN - 1; i >= 0; i-- ))
  do
    REV="$REV${COPY:$i:1}";
  done

  # print message
  echo -e "\nYou've provided $VAR as input.\n";
  echo -e "\nReverse Input: $REV\n";

done < "${1:-/dev/stdin}":

# Note: the line "${1:-/dev/stdin}" is used to assign the value of $1 to the variable VAR. If $1 is empty, then it will be assigned the value of /dev/stdin (standard input).



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

