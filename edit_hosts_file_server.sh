<<"COM"
    Descripiton: This script will edit the generated host file from ACAS in CSV format. To only contain servers.
    Date: 10/29/2024
    Author: iStackz
COM

# display message
echo -e "The number of parameters given is $#\n";

# parameter check
if [[ $# < 1 ]]
then
    # display message
    echo -e "\nError! No host file supplied";
    echo -e "\nUsage: edit_hostfile_server_only.sh <filename>";

    # error exit
    exit 1;
fi

# check if supplied file exists
if [[ -e $1 ]]
then
    # display message
    echo -e "\nYou have provided $1 as a parameter";
fi

# create a variable
declare ANSWER;

# while loop to prompt user for input
while [[ $ANSWER != 'yes' ]]
do
    # promp user for input
    read -p "Do you want to edit the host file to contain servers only? (yes/no): " ANSWER;

    # if statment to check if $ANSWER == 'no'
    if [[ $ANSWER == 'no' ]]
    then
        # display message
        echo -e "\nYou've answered 'no'. Will now exit the script";

        # normal exit
        exit 0;
    fi
done

# create a temporary file
TEMPFILE=$(mktemp);

## TESTS ##

# add lines to file
#echo $(grep -o "\[all\:vars\]" $1) >> $TEMPFILE;
#echo -e "$(grep -i 'ansible' $1)\n" >> $TEMPFILE;
#echo -e "$(grep -i '^gather' $1)" >> $TEMPFILE;
#sed -i '/^$/d' $TEMPFILE;
#echo -e "\n$(grep -o '\[today\]')" >> $TEMPFILE

#echo -e "$(grep -E '.+srv[0-9]{2}' $1)" >> $TEMPFILE;
#echo -e "$(grep -E '.+srv[0-9]{4}' $1)" >> $TEMPFILE;
#echo -e "$(grep -E '.*ns[0-9](\d{2}|\d{4})' $1)" >> $TEMPFILE;

# working regex
#echo -e "$(grep -E '.*srv[0-9].*' $1)" >> $TEMPFILE;
#echo -e "$(grep -E '.*db[0-9].*' $1)" >> $TEMPFILE;
#echo -e "$(grep -E '.+fs[0-9]' $1)" >> $TEMPFILE;

# while loop to iterate through host file (recommended by ChatGPT because for loop would cut output)
while IFS= read -r LINE
do
    # if statement to check host file for regex
    if [[ $LINE =~ \[all\:vars\] ]]
    then
        # add line to tempfile
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ ^ansible.*$ ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ ^vars.*$ ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ ^gather.*$ ]]
    then
        echo -e "$LINE\n" >> $TEMPFILE;
    elif [[ $LINE =~ \n ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ \[today\] ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ .*srv[0-9].* ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ .*db[0-9].* ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ .+fs[0-9] ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ .+ns[0-9]{2}.+ ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ .*srv[0-9]{4}.* ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ .*db[0-9]{4}.* ]]
    then
        echo $LINE >> $TEMPFILE;
    elif [[ $LINE =~ .*ns[0-9]{4}.* ]]
    then
        echo $LINE >> $TEMPFILE;
    fi
done < $1; # passes the hostsfile into the while loop


# rename the tempfile to the original hostfile
if [[ -s $TEMPFILE ]]
then
    # rename file
    mv $TEMPFILE $1;

    # display message
    echo -e "\nFile filtered successfully. Only matching hostnames have been kept";
else
    # display message
    echo -e "\nNo matching hostsnames found. Original file is unchanged";

    # remove the tempfile
    rm $TEMPFILE;
fi




#################################################################################

<<"COM"
    alternate version concise
COM

# Array of regular expressions
REGEX=(\[all\:vars\] ^ansible.*$ ^vars.*$ ^gather.*$ \[today\] .*srv[0-9].*s .*db[0-9].*s .+fs[0-9] .+ns[0-9]{2}.+ .*srv[0-9]{4}.* .*db[0-9]{4}.* .*ns[0-9]{4}.*);

# while loop to iterate through hostfile
while IFS=read -r LINE
do
    # for loop to iterate through REGEX ARRAY
    for EXPRESSION in "${#REGEX[@]}"
    do
        # compare LINE from hostfile to EXPRESSION from REGEX array
        if [[ $LINE =~ $EXPRESSION ]]
        then
            # add line to file (if matched)
            echo $LINE >> $TEMPFILE;
        fi
    done
done

# check if tempfile is empty or not
if [[ -s $TEMPFILE ]]
then
    # display message
    echo -e "\nFile filtered successfully. Only matching hostnames have been kept";

    # rename file
    mv $TEMPFILE $1;
else
    # display message
    echo -e "\nNo matching hostnames found. Original file remains unchanged.";

    # remove tempfile
    rm -f $TEMPFILE;
fi

