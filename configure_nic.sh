#!/usr/bin/env bash 

<<-"COMMENT"
	
	Description: This script will set your NICs configuration from automatically being assigned an IPv4 address from DHCP to static. For hosts with up to 2 NICs
	OS: RHEL 9
	Author: istackz
	Date: 01/14/2026

COMMENT

# update path variable #--> for some reason /usr/sbin wasn't in the PATH on the host I was working on and it was breaking my script when attempting to use the ip binary
if [[ ! "$PATH" =~ /usr/sbin ]]
then
	export PATH="$PATH:/usr/sbin";
fi

# variables * you should adjust these variables to suit your needs *
dns1="192.168.1.53"
dns2="192.168.1.54"
dns_domain="localhost.home"

# check for number of nics on host
number_of_nics=$(ip -brief addr | grep -iv 'lo' | wc -l)

# logic for 1 NIC
if (( number_of_nics == 1 ))
then
	# grab nic info
	nic=$(ip -brief addr | grep -iv 'lo' | head -n 1)

	# split the nic variable into parts
	read -r iface state ipv4 _ <<< "$nic";

	# display output
	echo -e "\n<----------->";
	echo "iface: $iface";
	echo "state: $state";
	echo "ipv4: $ipv4";
	echo "<------------->\n";

	# get NetworkManager's connection name for the nic
	connection_name="$(nmcli -t -f name connection show | grep -iv 'lo')"

	# check ipv4 variable contents
	if [[ ! "$ipv4" =~ \b([0-9]{1,3}\.){3}[0-9]{1,3}\b ]]
	then
		# search file for 'search' parameter
		if [[ -z $(grep -i '^search' /etc/resolv.conf) ]]
		then
			# add search parameter to file
			echo "search $dns_domain" >> /etc/resolv.conf
		fi

		# search file for 'search' parameter setting
		if [[ $(grep -i '^search' /etc/resolv.conf | cut -d ' ' -f 2-) =~ $dns_domain ]]
		then
			# search and replace
			sed -r -i "s/search .*/search $dns_domain/1" /etc/resolv.conf
		fi

		# Logic to check file for multiple 'nameserver' entries
		if [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 1 ]]
		then
			# check if 'nameserver' setting matches comparison
			if [[ $(grep -i '^nameserver' /etc/resolv.conf | awk '{print $2}') != $dns1 ]]
			then	
				# search and replace
				sed -r -i "s/^namerserver .*/nameserver $dns1/1" /etc/resolv.conf
			fi
		elif [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 2 ]]
		then
			# if 1st 'nameserver' entry does not match comparison
			if [[ $(grep -i '^nameserver' /etc/resolv.conf | head -n 1 | cut -d ' ' -f 2) != $dns1 ]]
			then
				# search and replace
				sed -r -i "s/^nameserver .*/nameserver $dns1/1" /etc/resolv.conf;
			fi
	
			# if 2nd 'nameserver' entry does not match comparison
			if [[ $(grep -i '^nameserver' /etc/resolv.conf | tail -n 1 | awk '{print $2}') != $dns2 ]]
			then
				# search and replace
				sed -r -i "0,/^nameserver/! { /^nameserver .*/nameserver $dns2/ }" /etc/resolv.conf
			fi
		fi

		# if no 'nameserver' entry found
		if [[ -z $(grep -i '^nameserver' /etc/resolv.conf) ]]
		then
			# add to file
			echo "nameserver $dns1" >> /etc/resolv.conf
		fi
		
		# use nslookup binary to get IPv4 address from dns 
		ipv4=$(nslookup $HOSTNAME | awk '/Address: / {for(i=1;i<=NF;i++) if($i ~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/) print $i}');

		if [[ ! $connection_name =~ $iface ]]
		then
			nmcli connection modify $connection_name connection.id $iface
		fi

		nmcli connection modify $connection_name \
			ipv4.method manual \
			ipv4.addresses "$ipv4/24" \
			ipv4.gateway "${ipv4%.*}.1" \
			ipv4.dns "$dns1,$dns2" \
			ipv4.dns-search "$dns_domain"; 
	else
		if [[ $connection_name != $iface ]] 
		then
			nmcli connection modify $connection_name connection.id $iface
		fi

		temp="${ipv4%/*}"
		gateway="${temp%.*}.1"

		nmcli connection modify $connection_name \
			ipv4.method manual \
			ipv4.addresses $ipv4 \
			ipv4.gateway $gateway \ 
			ipv4.dns "$dns1,$dns2" \
			ipv4.dns-search $dns_domain;
	fi

fi

# logic for 2 NICs
if (( number_of_nics == 2 ))
then
	connection_name1=$(nmcli -t -f name connection show | grep -iv 'lo' | head -n 1)
	connection_name2=$(nmcli -t -f name connection show | grep -iv 'lo' | tail -n 1)
	count=0

	# like a for loop but keeps lines in tact
	while IFS= read -r nic
	do
		# split into words and store in variables
		read -r iface state ipv4 _ <<< "$nic"

		echo -e "\n<-------->"
		echo -e "Interface: $iface"
		echo -e "$iface state: $state"
		echo -e "$iface IPv4: $ipv4"
		echo -e "<---------->\n"

		# if count == 0; then we are on the 1st nic
		if (( count == 0 ))
		then
			if [[ ! $ipv4 =~ ([0-9]{1,3}\.){3}[0-9]{1,3} ]]
			then
				if [[ -z $(grep -i '^search' /etc/resolv.conf) ]]
				then
					echo "search $dns_domain" >> /etc/resolv.conf
				fi

				if [[ $(grep -i '^search' /etc/resolv.conf | awk '{print $2}') != $dns_domain ]]
				then
					sed -r -i "s/^search .*/search $dns_domain/1" /etc/resolv.conf
				fi

				if [[ -z $(grep -i '^nameserver' /etc/resolv.conf) ]]
				then
					echo "nameserver $dns1" >> /etc/resolv.conf;
				fi

				if [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 1 ]]
				then
					if [[ $(grep -i '^nameserver' /etc/resolv.conf | awk '{print $2}') != $dns1 ]]
					then
						sed -r -i "s/^nameserver .*/nameserver $dns1/1" /etc/resolv.conf;
					fi
				elif [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 2 ]]
				then
					if [[ $(grep -i '^nameserver' /etc/resolv.conf | head -n 1 | awk '{print $2}') != $dns1 ]]
					then
						sed -r -i "s/^nameserver .*/nameserver $dns1/1" /etc/resolv.conf;
					elif [[ $(grep -i '^nameserver' /etc/resolv.conf | tail -n 1 | awk '{print $2}') != $dns2 ]] 
					then
						sed -r -i "0,/^nameserver/! { /^nameserver/ s/^nameserver .*/nameserver $dns2" /etc/resolv.conf;
					fi
				fi

				# grab ipv4 of 1st nic
				ipv4=$(nslookup $HOSTNAME | awk '/Address: / {for(i=1;i<=NF;i++) if($i ~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/) print $i}' | head -n 1);

				# check if match
				if [[ $connection_name1 != $face ]]
				then
					# set connection_name1 to iface
					nmcli connection modify $connection_name1 connection.id $iface;
				fi

				# configure 1st nic
				nmcli connection modify $connection_name1 \
					ipv4.method manual \
					ipv4.addresses "$ipv4/24" \
					ipv4.gateway "${ipv4%.*}.1" \
					ipv4.dns "$dns1,$dns2" \
					ipv4.dns-search "$dns_domain";
			else
				# temporary variables
				temp="${ipv4%/*}" # string manipulation to remove '/24' from variable
				gateway="${temp%.*}.1" # string manipulation to edit the last octet of variable to '.1'

				# check comparison
				if [[ $connection_name1 != $iface ]]
				then
					# set connection_name1 to iface
					nmcli connection modify $connection_name1 connection.id $iface;
				fi

				# configure 1st nic
				nmcli connection modify $connection_name1 \
					ipv4.method manual \
					ipv4.addresses $ipv4 \
					ipv4.gateway $gateway \
					ipv4.dns "$dns1,$dns2" \
					ipv4.dns-search "$dns_domain";
			fi
		fi

		# if count == 1; then we are on the 2nd nic
		if (( count == 1 ))
		then
			# if ipv4 does not match regex
			if [[ ! $ipv4 =~ ([0-9]{1,3}\.){3}[0-9]{1,3} ]]
			then
				if [[ -z $(nslookup "$HOSTNAME-<suffix1>") ]]
				then
					ipv4=$(nslookup "$HOSTNAME-<suffix2>" | awk '/^Address: / { last = $NF } END { print last }');
				else
					ipv4=$(nslookup "$HOSTNAME-<suffix1>" | awk '/^Address: / { last = $NF } END { print last }');
				fi
				
				# configure 2nd nic
				nmcli connection modify $connection_name2 \
					ipv4.method manual \
					ipv4.addresses "$ipv4/24" \ 
					connection.id $iface;
			else
				# configure 2nd nic
				nmcli connection modify $connection_name2 \
					ipv4.method manual \
					ipv4.addresses "$ipv4/24" \
					connection.id $iface;
			fi
		fi

		# increment the count variable by 1
		(( count++ ));
	done < <(ip -brief addr | grep -iv 'lo')
fi

# reload NetworkManager configurations
nmcli connection reload

# exit successfully
exit 0
