#!/usr/bin/env bash

# This script show's the stat information of a file or directory by using the stat command
# for more info use: stat --help
# Usage: ./show_stats.sh <file_name_or_directory_name>

# Author: istackz

# variables
arg1=$1;

# color variables

# dark foreground colors
dgreen='\033[0;32m';
dred='\033[0;31m';
dyellow='\033[0;33m';
dblue='\033[0;34m';
dwhite='\033[0;37m';
dmagenta='\033[0;35m';
dcyan='\033[0;36m';
dgray='\033[0;90m';

# light foreground colors
lgreen='\033[0;92m';
lred='\033[0;91m';
lyellow='\033[0;93m';
lblue='\033[0;94m';
lwhite='\033[0;97m';
lmagenta='\033[0;95m';
lcyan='\033[0;96m';
lgray='\033[0;37m';

# bold foreground colors #

# dark 
bdgreen='\033[1;32m';
bdred='\033[1;31m';
bdyellow='\033[1;33m';
bdblue='\033[1;34m';
bdwhite='\033[1;37m';
bdmagenta='\033[1;35m';
bdcyan='\033[1;36m';
bdgray='\033[1;90m';

# light
blgreen='\033[1;92m';
blred='\033[1;91m';
blyellow='\033[1;93m';
blblue='\033[1;94m';
blwhite='\033[1;97m';
blmagenta='\033[1;95m';
blcyan='\033[1;96m';
blgray='\033[1;37m';

# background colors
dgreen='\033[0;42m';
dred='\033[0;41m';
dyellow='\033[0;43m';
dblue='\033[0;44m';
dwhite='\033[0;47m';
dmagenta='\033[0;45m';
dcyan='\033[0;46m';
dgray='\033[0;100m';

# light background colors
lgreen='\033[0;102m';
lred='\033[0;101m';
lyellow='\033[0;103m';
lblue='\033[0;104m';
lwhite='\033[0;107m';
lmagenta='\033[0;105m';
lcyan='\033[0;106m';
lgray='\033[0;47m';

# bold background colors #

# dark 
bbdgreen='\033[1;42m';
bbdred='\033[1;41m';
bbdyellow='\033[1;43m';
bbdblue='\033[1;44m';
bbdwhite='\033[1;47m';
bbdmagenta='\033[1;45m';
bbdcyan='\033[1;46m';
bbdgray='\033[1;100m';

# light
bblgreen='\033[1;102m';
bblred='\033[1;101m';
bblyellow='\033[1;103m';
bblblue='\033[1;104m';
bblwhite='\033[1;107m';
bblmagenta='\033[1;105m';
bblcyan='\033[1;106m';
bblgray='\033[1;47m';

# blinking colors
blinkgreen='\033[0;33;5m';
blinkred='\033[0;31;5m';
blinkyellow='\033[0;93;5m';
blinkblue='\033[0;34;5m';
blinkwhite='\033[0;37;5m';
blinkmagenta='\033[0;35;5m';
blinkcyan='\033[0;36;5m';
blinkgray='\033[0;90;5m';



# reset
reset='\033[0m';

# check if the argument is a file or a directory
if [ -f "$arg1" ]
then
    # stat file 
    stat --printf="\n $dcyan File Name:$reset\t\t\t%n\n" $arg1;
    stat --printf="\n $dred User Owner:$reset\t\t\t%U\n" $arg1;
    stat --printf="\n $dyellow Permissions (Octal):$reset\t\t%a\n" $arg1;
    stat --printf="\n $dgreen SELinux Context:$reset\t\t%C\n" $arg1;
    stat --printf="\n $lbue File Created:$reset\t\t\t%w\n" $arg1;
    stat --printf="\n $lmagenta Last Accessed:$reset\t\t%x\n" $arg1;
    stat --printf="\n $lgray Last Modified:$reset\t\t%y\n" $arg1;
    stat --printf="\n $lyellow Last Status Change:$reset\t\t%z\n" $arg1;
else
    echo -e "\n$bdred Error! $reset must provide a file or directory as an argument. Try again!\n";
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
