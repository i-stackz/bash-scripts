#!/usr/bin/env bash

<<com
NOTE: Please do not run this. This was how I came to figure out what I was trying to do for work
with my script. With the help of ChatGPT I accomplished my goal and learned a 'trick' of how to extract the digits
stored within a viariable without using the cut command.
com



# ===> ChatGPT fix <=== #

# for loop to iterate over all files in the specified directories
for i in $(find -L /lib /lib64 /usr/lib /usr/lib64 -type f -name "*.so*" -print)
do
  while true
  do
    # variables
    PERMISSIONS=$(stat -c %a "$i"); # get the permissions of the file
    FIRST=${PERMISSIONS:0:1}; # extract the first digit of the permissions
    SECOND=${PERMISSIONS:1:1}; # extract the second digit of the permissions
    THIRD=${PERMISSIONS:2:1}; # extract the third digit of the permissions

    # display a message
    echo -e "\nPermissions for $i are currently set to $PERMISSIONS\n";

    # if statement to check if the second digit is either 2, 3, 6, or 7 (check group permissions)
    #if (( SECOND >= 2 && SECOND <= 7 )) ## ChatGPT Error
    if (( ($SECOND == 2) || ($SECOND == 3) || ($SECOND == 6) || ($SECOND == 7) ))
    then
        # fix group permission on file
        chmod "${FIRST}4${THIRD}" "$i";
    # elif statement to check if the third digit is either 2, 3, 6, or 7 (check other permissions)
    #elif (( THIRD >= 2 && THIRD <= 7 )) ## ChatGPT Error
    elif (( ($THIRD == 2) || ($THIRD == 3) || ($THIRD == 6) || ($THIRD == 7) ))
    then
        # fix other permission on file
        chmod "${FIRST}${SECOND}4" "$i";
    else
        # display message
        echo -e "\nPermissions for $i seem to be fine\n";
        # break out of while loop
        break;
    fi
  done
done


```
Changes made:

1. Used substring extraction (`${PERMISSIONS:0:1}`) to get individual digits of the permissions.
2. Changed the conditions to `(SECOND >= 2 && SECOND <= 7)` and `(THIRD >= 2 && THIRD <= 7)` to check if the permissions contain w, x, or wx.
3. Moved the `echo` statement to print the current permissions before attempting to fix them.

This script should iterate through the specified files, continuously checking and adjusting the permissions until they meet your criteria.

for more details see: https://chat.openai.com/c/7cfda3f3-836b-477f-ab37-15fcddd72a6e 
```

# ==> END <== #

<<COMMENT
# one liner to set permissions # 

find -L /lib /lib64 /usr/lib /usr/lib64 -type f -name "*.so*" -exec bash -c '\
        while true
        do
          # variables
          PERM=$(stat -c %a "$1");
          FIRST=$(stat -c %a "$1" | cut -c 1);
          SECOND=$(echo $PERM | cut -c 2);
          THIRD=${PERM:2:1};

          echo -e "\nPermissions for $1 is currently set to $PERM\n";

          if (( (SECOND == 2) || (SECOND == 3) || (SECOND == 6) || (SECOND == 7) ))
          then
              echo -e "\nFile $1 has inadequate GROUP permissions\n";
              echo -e "\nWill fix this now";

              chmod "${FIRST}4${THIRD}" "$1";
          elif (( (THIRD == 2) || (THIRD == 3) || (THIRD == 6) || (THIRD == 7) ))
          then
              echo -e "\nFile $1 has inadequate OTHER permissions\n";
              echo -e "\nWill fix this now";

              chmod "${FIRST}${SECOND}4" "$1";
          else
              echo -e "\nFile $1 has passed the permissions check\n";
              break;
          fi
        done
        ' _ {} \;

# show perms
for i in $(find /lib /lib64 /usr/lib /usr/lib64 -type f -name "*.so*" -print)
do
    echo -e "\nThe permissions for $i is now $(stat -c %a $i)\n";
done  

### --> END one-liner <-- ###





## --> 1st attempt <-- ##

for i in $(find -L /lib /lib64 /usr/lib /usr/lib64 -perm /022 -type f -exec ls {} \;)
do
	FIRST=$(stat -c %a "$i" | cut -c 1);
	SECOND=$(stat -c %a "$i" | cut -c 2);
	THIRD=$(stat -c %a "$i" | cut -c 3);


	echo -e "\nThe current permission of the file $i is $(stat -c %a $i)\n";

	if (( $SECOND == [2367] ))
	then
		echo -e "\nFile $i has inadequate group permissions\n";
		echo -e "\nWill fix this now\n";

		chmod ${FIRST}4${THIRD} ${i};
	elif (( $THIRD == [2367] ))
	then
		echo -e "\nFile $i has inadequate other permissions\n";
		echo -e "\nWill fix this now\n";

		chmod ${FIRST}${SECOND}4 ${i};
	else
		echo -e "\nPermissions on $i seem to be fine\n";
	fi
done

## --> END <-- ##

### ----> Edited Version <----- ### (still provides undesired result)

for i in $(find -L /lib /lib64 /usr/lib /usr/lib64 -type f -name "*.so*" -print)
do
  # variables
  FIRST=$(stat -c %a "$i" | cut -c 1);
  SECOND=$(stat -c %a "$i" | cut -c 2);
  THIRD=$(stat -c %a "$i" | cut -c 3);

  if (( SECOND == 2 || SECOND == 3 || SECOND == 6 || SECOND == 7 ))
  then
    echo -e "\nFile $i has inadequate GROUP permissions\n";
    echo -e "\nWill fix this now\n";

    chmod "${FIRST}4${THIRD}" "$i";
  elif (( THIRD == 2 || THIRD == 3 || THIRD == 6 || THIRD == 7 ))
  then
    echo -e "\nFile $i has inadequate OTHER permissions\n";
	  echo -e "\nWill fix this now\n";

    chmod "${FIRST}${SECOND}4"
  else
    echo -e "\nPermissions on $i seem to be fine\n";
  fi
done

## ===> END <=== ##


COMMENT
