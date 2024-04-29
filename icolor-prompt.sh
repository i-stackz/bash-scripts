#!/bin/bash

# Description: Script to generate a random colored prompt upon user login

# Function to generate a random color code
function random_color_code(){

    # list that will hold two randomly generated numbers 
    LIST=(
        $(( 31 + RANDOM % 7 )) # Generates a random number between 31 and 37 
        $(( 91 + RANDOM % 7 )) # Generates a random number between 91 and 97
    );

    # another random number
    RNUM=$(( RANDOM % 2 )); # generate a number that is 0 or 1

    # output random value from the contents of the list
    echo "${LIST[$RNUM]}";
}

# another random number (0 to 10)
RNUM1=$(( RANDOM % 10 ));
RNUM2=$(( RANDNOM % 10 ));
RNUM3=$(( RANDNOM % 10 ));
RNUM4=$(( RANDNOM % 10 ));
RNUM5=$(( RANDNOM % 10 ));

# Define colors
COLOR1="\[\e[5;$(random_color_code)m\]"; # will make the color prompt blink (rm '5;' to make it not blink)
COLOR2="\[\e[${RNUM2};$(random_color_code)m\]";
COLOR3="\[\e[${RNUM3};$(random_color_code)m\]";
COLOR4="\[\e[${RNUM4};$(random_color_code)m\]";
COLOR5="\[\e[${RNUM5};$(random_color_code)m\]";
COLOR_RESET="\[\e[0m\]";

# Set PS1 with random color codes
PS1="${COLOR1}-->${COLOR_RESET} ${COLOR2}\u${COLOR_RESET}${COLOR1}@${COLOR_RESET}${COLOR3}\h${COLOR_RESET} ${COLOR1}[${COLOR_RESET}${COLOR4}\W${COLOR_RESET}${COLOR1}]${COLOR_RESET} ${COLOR2}\\\$${COLOR_RESET} ${COLOR1}:${COLOR_RESET} ";

# print out PS1
echo $PS1;


#========================================================================================================================#

# NOTE:
# In order for the script to work you need to place the line 'export PS1=$(sh color-prompt.sh)' within your .bashrc file
# and also have the script within the same path as the .bashrc file

#========================================================================================================================#


#############
# my banner #
#############

##########################################################
# source: http://patorjk.com/software/taag/		 #
##########################################################
echo -e "\nScript by: ";
echo -e "\n";
echo -e "\e[5;31m";
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

