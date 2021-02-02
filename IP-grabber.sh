#!/bin/bash

# this script finds your ip and saves it to a log file.

ip=$(ifconfig | egrep "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | head -n 1 | cut -b 14-24)

echo 'your ip is: '
echo ""
echo "$ip"


echo "$ip" >> ip_log


