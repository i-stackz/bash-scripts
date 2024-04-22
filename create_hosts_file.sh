#!/usr/bin/env bash

<<com

script to generate a hosts file for my ansible playbook

Author: iStackz

com

#--// Begin //--#

# display output
echo -e "\ncreating new hosts file";

# create new hosts file containing today's date within the filename
touch /path/to/file/hosts_$(date +"%m.%d.%Y") 2>&1;

# cat out the template_hosts file and append the output to the newly created hosts file
cat /path/to/template_file | tee -a hosts_$(date +"%m.%d.%Y") 1> /dev/null;

# display output
echo "Removing the comments from the input file. Truncating output to just show the hostname and append it to the hosts file."

# cat out the csv (input) file given as a parameter ($1) and edit the output to only display the host name. append cleaned output to hosts file.
cat "${1}" | cut -d '"' -f 2 | cut -d '.' -f 1 >> /path/to/hosts_file/hosts_$(date +"%m.%d.%Y");

# display output
echo -e "\nCleaning up file some more";

# remove unwanted entries from the newly created hosts file
sed -i '/DNS Name/d' /path/to/hosts_file/hosts_$(date +"%m.%d.%Y") 2>&1;

# command to remove all whitespaces
sed -i '/^[[:space:]]*$/d' /path/to/hosts_file/hosts_$(date +"%m.%d.%Y") 2>&1;

# command to add a space above/before finding
sed -i '/\[today\]/{x;p;x}' /path/to/hosts_file/hosts_$(date +"%m.%d.%Y") 2>&1;

# display output
echo -e "\nDone!";

# command to remove file with name of 1 and 2. Do not know why those files are being created
FILE='true';

while [[ $FILE == 'true' ]]
do
  if [ $(la -a 1 2> /dev/null) ]
  then
      rm 1 2>&1;
  elif [ $(la -a 2 2> /dev/null) ]
  then
      rm 2 2>&1;
  fi
done

#--// End //--#



