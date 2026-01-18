#!/usr/bin/env bash 

<<-"COMMENT"
	
	Description: This script will set your NICs configuration from automatically being assigned an IPv4 address from DHCP to a statically assigned one
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
dns_domain="myhost.example.com"

number_of_nics=$(ip -brief addr | grep -iv 'lo' | wc -l)


# logic for 1 NIC
if (( number_of_nics == 1 ))
then
	nic=$(ip -brief addr | grep -iv 'lo')

	# split the nic variable into parts
	read -r iface state ipv4 _ <<< "$nic";

	echo -e "\n<----------->";
	echo "iface: $iface";
	echo "state: $state";
	echo "ipv4: $ipv4";
	echo "<------------->\n";

	connection_name="$(nmcli -t -f name connection show | grep -iv 'lo')"

	if [[ ! "$ipv4" =~ \b([0-9]{1,3}\.){3}[0-9]{1,3}\b ]]
	then
		if [[ -z $(grep -i '^search' /etc/resolv.conf) ]]
		then
			echo "search $dns_domain" >> /etc/resolv.conf
		fi

		if [[ $(grep -i '^search' /etc/resolv.conf | cut -d ' ' -f 2-) =~ $dns_domain ]]
		then
			sed -r -i "s/search .*/search $dns_domain/1" /etc/resolv.conf
		fi

		if [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 1 ]]
		then
			if [[ $(grep -i '^nameserver' /etc/resolv.conf | awk '{print $2}') != $dns1 ]]
			then
				sed -r -i "s/^namerserver .*/nameserver $dns1/1" /etc/resolv.conf
			fi
		elif [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 2 ]]
		then
			if [[ $(grep -i '^nameserver' /etc/resolv.conf | head -n 1 | cut -d ' ' -f 2) != $dns1 ]]
			then
				sed -r -i "s/^nameserver .*/nameserver $dns1/1" /etc/resolv.conf;
			elif [[ $(grep -i '^nameserver' /etc/resolv.conf | tail -n 1 | awk '{print $2}') != $dns2 ]]
			then
				sed -r -i "0,/^nameserver/! { /^nameserver .*/nameserver $dns2/ }" /etc/resolv.conf
			fi
		fi

		if [[ -z $(grep -i '^nameserver' /etc/resolv.conf) ]]
		then
			echo "nameserver $dns1" >> /etc/resolv.conf
		fi

		ipv4=$(nslookup $HOSTNAME | awk '/^Address: / { print $2 }' | tail -n 1)

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

	while IFS= read -r nic
	do
		# split lines into words
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
					echo "nameserver $dns1" >> /etc/resolv.conf
				fi

				if [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 1 ]]
				then
					if [[ $(grep -i '^nameserver' /etc/resolv.conf | awk '{print $2}') != $dns1 ]]
					then
						sed -r -i "s/^nameserver .*/nameserver $dns1/1" /etc/resolv.conf
					fi
				elif [[ $(grep -i '^nameserver' /etc/resolv.conf | wc -l) == 2 ]]
				then
					if [[ $(grep -i '^nameserver' /etc/resolv.conf | head -n 1 | awk '{print $2}') != $dns1 ]]
					then
						sed -r -i "s/^nameserver .*/nameserver $dns1/1" /etc/resolv.conf
					elif [[ $(grep -i '^nameserver' /etc/resolv.conf | tail -n 1 | awk '{print $2}') != $dns2 ]] 
					then
						sed -r -i "0,/^nameserver/! { /^nameserver/ s/^nameserver .*/nameserver $dns2" /etc/resolv.conf
					fi
				fi

				ipv4=$(nslookup $HOSTNAME | awk '/^Address: / { print $2 }' | tail -n 1)

				if [[ $connection_name1 != $face ]]
				then
					nmcli connection modify $connection_name1 connection.id $iface
				fi

				nmcli connection modify $connection_name1 \
					ipv4.method manual \
					ipv4.addresses "$ipv4/24" \
					ipv4.gateway "${ipv4%.*}.1" \
					ipv4.dns "$dns1,$dns2" \
					ipv4.dns-search "$dns_domain" \
			else
				temp="${ipv4%/*}" # string manipulation to remove '/24' from variable
				gateway="${temp%.*}.1" # string manipulation to edit the last octet of variable to '.1'

				if [[ $connection_name1 != $iface ]]
				then
					nmcli connection modify $connection_name1 connection.id $iface
				fi

				nmcli connection modify $connection_name1 \
					ipv4.method manual \
					ipv4.addresses $ipv4 \
					ipv4.gateway $gateway \
					ipv4.dns "$dns1,$dns2" \
					ipv4.dns-search "$dns_domain"
			fi
		fi

		# if count == 1; then we are on the 2nd nic
		if (( count == 1 ))
		then
			if [[ ! $ipv4 =~ ([0-9]{1,3}\.){3}[0-9]{1,3} ]]
			then
				if [[ -z $(nslookup "$HOSTNAME-<suffix1>") ]]
				then
					ipv4=$(nslookup "$HOSTNAME-<suffix2" | awk '/^Address: / { last = $NF } END { print last }')
				else
					ipv4=$(nslookup "$HOSTNAME-<suffix1" | awk '/^Address: / { last = $NF } END { print last }')
				fi

				nmcli connection modify $connection_name2 \
					ipv4.method manual \
					ipv4.addresses "$ipv4/24" \ 
					connection.id $iface
			else
				nmcli connection modify $connection_name2 \
					ipv4.method manual \
					ipv4.addresses "$ipv4/24" \
					connection.id $iface
			fi
		fi
	done < <(ip -brief addr | grep -iv 'lo')
fi

nmcli connection reload

exit 0
