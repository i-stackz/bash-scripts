#!/usr/bin/env bash

<<"COM"
    Description: This script will extract the hosts from the given CSV file
    date: 10/30/2024
    Author: iStackz
COM

# check if parameter given is greater than 1
if [[ $# < 1 ]]
then
    # display message
    echo -e "\nError! Please provide a CSV file";

    # error exit
    exit 1;
fi

# ensure that the file exists
if [[ -e $1 ]]
then
    # check that the file is not empty
    if [[ -s $1 ]]
    then
        # display message
        echo -e "\nYou have provided $1 as a CSV file";
    else
        # display message
        echo -e "\nError! Given file is empty. Please provide another file";

        # error exit
        exit 1;
    fi
else
    # display message
    echo -e "\nError! File name given does not exist";

    # error exit
    exit 1;
fi

# create an empty variable
declare FILENAME;

# while loop to prompt user for input
while [[ -z $FILENAME ]]
do
    # promp user for file name
    read -p "Enter hostfile's name: " FILENAME;
done

# variable to contain hostname
#HOSTNAME=$(cat $1 | awk -F ',' '{print $7}');

# variable to contain ip address
#IPV4=$(cat $1 | awk -F ',' '{print $8}');

# variable to create tempfiles
TEMPFILE=$(mktemp);
TEMPFILE1=$(mktemp);

# for loop to iterate through file
for HOST in $(cat "$1")
do
    # variable to contain hostname
    HOSTNAME=$(echo $HOST | awk -F ',' '{print $4}' | cut -d '.' -f 1);
    IP_ADDRESS=$(echo $HOST | awk -F ',' '{print $5}');

    # test #
    #echo -e "\n$HOSTNAME";
    #echo -e "\n$IP_ADDRESS";
    ### end test ###

    # if statement to check if HOSTNAME is populated
    if [[ -n $HOSTNAME ]]
    then
        # add host to tempfile
        echo "$HOSTNAME" >> $TEMPFILE;
    fi

    # if statement to add IPV4 address if HOSTNAME is empty
    if [[ z $HOSTNAME ]] && [[ -n $IP_ADDRESS ]]
    then
        # add IPv4 address to TEMPFILE
        echo "$IP_ADDRESS" >> $TEMPFILE;
    fi
done

# clean up tempfile
sed -r -i '/^Vulnerability/d' $TEMPFILE;
sed -r -i '/^OpenSSH/d' $TEMPFILE;
sed -r -i '/^Microsoft/d' $TEMPFILE;
sed -r -i '/^Oracle/d' $TEMPFILE;
sed -r -i '/^no/d' $TEMPFILE;
sed -r -i '/^Mozilla/d' $TEMPFILE;
sed -r -i '/^Adobe/d' $TEMPFILE;
sed -r -i '/^VMWare/d' $TEMPFILE;
sed -r -i '/^Security/d' $TEMPFILE;
sed -r -i '/^SSL/d' $TEMPFILE;
sed -r -i '/^Apache/d' $TEMPFILE;
sed -r -i '/^Node/d' $TEMPFILE;
sed -r -i '/^OpenJDK/d' $TEMPFILE;
sed -r -i '/^Wireshare/d' $TEMPFILE;
sed -r -i '/^ClamAV/d' $TEMPFILE;
sed -r -i '/^Google/d' $TEMPFILE;
sed -r -i '/^Git/d' $TEMPFILE;
sed -r -i '/^"Node/d' $TEMPFILE;
sed -r -i '/^Red/d' $TEMPFILE;
sed -r -i '/^Python/d' $TEMPFILE;
sed -r -i '/^VLC/d' $TEMPFILE;
sed -r -i '/^ManageEngine/d' $TEMPFILE;
sed -r -i '/^kafka/d' $TEMPFILE;
sed -r -i '/^FileZilla/d' $TEMPFILE;
sed -r -i '/^WinSCP/d' $TEMPFILE;
sed -r -i '/^libcurl/d' $TEMPFILE;
sed -r -i '/^Tenable/d' $TEMPFILE;
sed -r -i '/^MongoDB/d' $TEMPFILE;
sed -r -i '/^Nessus/d' $TEMPFILE;
sed -r -i '/^Dell/d' $TEMPFILE;
sed -r -i '/^SSH/d' $TEMPFILE;
sed -r -i '/^Notepad++/d' $TEMPFILE;
sed -r -i '/^Insecure/d' $TEMPFILE;
sed -r -i '/^OpenSSL/d' $TEMPFILE;
sed -r -i '/^LOLDriver/d' $TEMPFILE;
sed -r -i '/^PuTTY/d' $TEMPFILE;
sed -r -i '/^SMB/d' $TEMPFILE;
sed -r -i '/^s/d' $TEMPFILE;

# remove any duplicate entries
sort -u $TEMPFILE > $TEMPFILE1;

# check if TEMPFILE is empty
if [[ -s $TEMPFILE1 ]]
then
    # cat template_hosts to FILENAME
    cat ./template_hosts | tee -a $FILENAME;

    # remove any duplicates from TEMPFILE1 and copy it to FILENAME
    awk '!seen[$0]++' $TEMPFILE1 | tee -a $FILENAME;

    # delete temp files
    rm -f $TEMPFILE;
    rm -f $TEMPFILE1;

    # display message
    echo -e "\nSuccessfully created host file";
else
    # display message
    echo -e "\nError! File is empty, please check";

    # remove tempfile
    rm -f $TEMPFILE;
    rm -f $TEMPFILE1;

    # error exit
    exit 1;
fi
