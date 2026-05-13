#!/usr/bin/env bash

# Description: This script will demonstrate using trap to run a function after the script exists successfully. It will also demonstrate how to use trap as a debugging tool. 

# NOTE: This was demonstrated, learned from Dave Eddy's (YSAP) bash scripting course on youtube https://www.youtube.com/watch?v=uAmIIWYMgS4&list=PL-my9REMIFtGgiQAXqKPJ5UrLdSkxcLBT

# cleanup function
function cleanup() {
	echo -e "\nScript has ran \e[32msuccessfully\e[0m. Will now commence to clean up after itself."
}

# debug function
function debug_me() {
	# BASH_COMMAND is a bash built-in variable that holds the command
	# that is currently being executed
	echo -e "\n\e[33mDEBUG\e[0m: \e[34m${BASH_COMMAND}\e[0m"
}

# use trap to call the cleanup function on exit
trap cleanup exit

# use trap to call the debug_me function for debugging
#trap debug_me debug

# logic to print colors
for i in {1..256}
do
	echo -e "\e[${i}mColor ${i}\e[0m\n"
done

# successful exit
exit 0 


# NOTE: for more info on using trap see: https://share.google/aimode/cCmXCS9RNz2316guo
