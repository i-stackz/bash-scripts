#!/usr/bin/env bash

# This script will grab the public IP address of the host making the request and outputs it to the console/screen

# list of public servers
# ifconfig.me/ip --> 80 http
# ipinfo.io/ip --> 80 http
# ip4only.me/api --> 80 http
# ipgrab.io --> 443 https
# ident.me --> 443 https or 80 http
# v4.ipify.io --> 443 https or 80 http

# conduct google search to get more servers

# refer to https://stackoverflow.com/questions/14594151/methods-to-detect-public-ip-address-in-bash for other methods (such as dig or route)
# refer to https://chat.openai.com/c/a0532250-0a41-49cd-ac89-fa072478fa90 -- for explanation and their version of the code below

# mixed the code provided from stack overflow with the suggestions from chatgpt

# create socket connection (you can edit the url and port) (uses file descriptor 3)
exec 3<>/dev/tcp/icanhazip.com/80 

# create the HTTP GET request (modify as needed)
echo -e 'GET / HTTP/1.0\r\nhost: icanhazip.com\r\nConnection: close\r\n\r\n' >&3

# while loop to grab the IP address and store it in a variable
while read i
do
 [ "$i" ] && myip="$i" 
done <&3 

# output the IP address to the console
echo "Host's public ip address is: $myip";

# close the connection
exec 3>&-

# NOTE: this script was something I glued together using things from my conversation with ChatGPT
# and research done from stackoverflow.com

# commands are a bit too advanced (the exec command to open a http connection)
# and the creation of an http GET request / header are things I will have to work on (webdev) down the line
