#!/usr/bin/env bash


# Description: This script will ssh to a host defined within a specified file with a list of hosts
# and generate a script (HEREDOC) and run it on the fly

# Author: iStackz 
# Date: 1/29/25

# this script will ssh into hosts and run yum commands
for i in $(cat [fqdn-to-host-file])
do
    # command to ssh into host and run HEREDOC/script
    ssh $i /usr/bin/env bash $(cat << 'EOF'
    #!/usr/bin/env bash
   
    if ! [[ $(sudo yum update | grep -i 'nothing to do') ]]
    then
        sudo yum install [package-name] -y;
        sudo yum update --exclude='[package-name]' -y;
    fi
EOF
);

done;
