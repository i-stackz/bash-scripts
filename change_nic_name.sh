#!/usr/bin/env bash

# Description: This script will change the NIC's name to ens192 and ens224 to ensure compatibility with our
# Ansible playbooks 

# Author: iStackz
# Date: 9/11/2025

# check if user is root
if [[ $(id -u) != 0 ]]
then
    echo -e "\e[31mError! Script must be ran as root. Please try again!\e[0m";
    exit 1;
file

# Check for number of NICs # 

# if number of NICs is 1
if [[ $(ip -c addr | grep -E '^[[:digit]]' | grep -v 'lo' | wc -l) == 1 ]]
then
    con_name1=$(nmcli connection show | grep -vi 'name' | head -n 1 | cut -d ' ' -f 1);
    mac_address1=$(ip -c addr | grep -v 'lo' | grep -i '^2:' -A 2 | grep -i 'link' | awk -F ' ' '{print $2}');

    # check if /etc/systemd/network exists
    if [[ ! -d /etc/systemd/network ]]
    then
        echo -e "/etc/systemd/network does not exist, will create it now";

        # create directory
        mkdir -p /etc/systemd/network;
    fi

    # check for file
    if [[ ! -e /etc/systemd/network/70-ens192.link ]]
    then
        echo -e "70-ens192.link does not exist, will create it now";

        # create HEREDOC
        cat <<EOF > /etc/systemd/network/70-ens192.link
[Match]
MACAddress=$mac_address1

[Link]
Name=ens192
EOF
    fi

    # nmcli commands to change NIC's name
    nmcli connection modify $con_name1 connection.interface-name ens192;
    nmcli connection modify $con_name1 match.interface-name ens192;
    nmcli connection modify $con_name1 connection.id ens192;
# if number of NICs is 2
elif [[ $(ip -c addr | grep -iE '^[[:digit:]]' | grep -v 'lo' | wc -l) == 2 ]]
then
    # variables
    con_name1=$(nmcli connection show | grep -vi 'name' | head -n 1 | cut -d ' ' -f 1);
    mac_address1=$(ip -c addr | grep -iv 'lo' | grep -i '^2:' -A 2 | grep -i 'link' | awk -F ' ' '{print $2}');

    con_name2=$(nmcli connection show | grep -vi 'name' | tail -n 1 | cut -d ' ' -f 1);
    mac_address2=$(ip -c addr | grep -iv 'lo' | grep -i '^3:' -A 2 | grep -i 'link' | awk -F ' ' '{print $2}');

    # test
    echo -e "\nNIC 1 MAC address = $mac_address1";
    echo -e "NIC 2 MAC address = $mac_address2";
    echo -e "NIC 1 connection name = $con_name1";
    echo -e "NIC 2 connection name = $con_name2";

    # check for file 1
    if [[ ! -e /etc/systemd/network/70-ens192.link ]]
    then
        echo -e "70-ens192.link does not exist, will create it now";

        cat <<EOF > /etc/systemd/network/70-ens192.link
[Match]
MACAddress=$mac_address1

[Link]
Name=ens192
EOF

    nmcli connection modify $con_name1 connection.interface-name ens192;
    nmcli connection modify $con_name1 match.interface-name ens192;
    nmcli connection modify $con_name1 connection.id ens192;
    fi

    # check for file 2
    if [[ ! -e /etc/systemd/network/70-ens224.link ]]
    then
        echo -e "70-ens224.link does not exist, will create it now";

        cat <<EOF > /etc/systemd/network/70-ens224.link
[Match]
MACAddress=$mac_address2

[Link]
Name=ens224
EOF

    nmcli connection modify $con_name2 connection.interface-name ens224;
    nmcli connection modify $con_name2 match.interface-name ens224;
    nmcli connection modify $con_name2 connection.id ens224;

    fi
fi

# check if /etc/sysconfig/network-scripts is not empty
if [[ ! -z $(ls /etc/sysconfig/network-scripts) ]]
then
    sed -r -i "s/$con_name1/ens192/g" /etc/sysconfig/network-scripts/ifcfg-$con_name1;
    mv /etc/sysconfig/network-scripts/ifcfg-$con_name1 /etc/sysconfig/network-scripts/ifcfg-ens192;

    sed -r -i "s/$con_name2/ens224/g" /etc/sysconfig/network-scripts/ifcfg-$con_name2;
    mv /etc/sysconfig/network-scripts/ifcfg-$con_name2 /etc/sysconfig/network-scripts/ifcfg-ens224;
fi

# ensure changes are written to kernel
dracut -f;

# display message
echo -e "\e[32mConfiguration changes have been made, please reboot the system\e[0m\n";

# success exit
exit 0;
