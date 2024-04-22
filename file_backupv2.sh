#!/usr/bin/env bash

# Description: this is a file backup script version 2.0 which uses a function.

# create/declare a function
file_backup()
{
  	# declare a local variable called FILE
	local FILE;
  
  	# prompt user for input and store it within FILE
	read -p 'Input the file name: ' FILE;
  
  	# create/declare local variable called NEWFILE and give it the value of user input along with today's date and add the .bak extension
	local NEWFILE="${FILE}_$(date +%m-%d-%y).bak";

  	# if statement to check if the file exists
	if [[ "${FILE}" ]]
	then
    		# display message
		echo -e "\nBacking up file...";
    
    		# copy file to new file
		cp -p ${FILE} ${NEWFILE};

    		# if statement to check if command ran successfully
		if [[ $? == 0 ]]
		then
      			# display message
			echo -e "\nBackup create successfully. ";
		fi
	else
    		# display message
		echo -e "\nPlease provide a file name: ";
		
		# error exit
		return 1;
	fi
	
}

# call the function
file_backup;


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
