#!/usr/bin/env bash

#################################
# Date: 4/3/2025
# Author: iStackz
# Description: This script will search and find SSL certs
#################################

# variable
SSL_CERT="";
EXPIRATION_DATE="";

# logic to find cert
if [[ $(yum list installed | grep -i 'httpd') || $(ps -ef | grep -i 'httpd') ]]
then
        # search for ssl.conf file
        for i in $(find / -xdev -type f \(-name "ssl.conf" -o -name "*ssl.conf" -o -name "*ssl*.conf"\))
        do
                # TEST grep each finding #
                #grep 'SSLCertificateFile' $i;
               
                # if statement to check if grep command is not empty
                if [[ -n $(grep 'SSLCertificateFile' $i) ]]
                then
                        # set variable
                        SSL_CERT=$(grep 'SSLCertificateFile' $i | awk '{print $2}' | cut -d '"' -f 2);
                       
                        # TEST print variable #
                        echo -e "\n$SSL_CERT\n";
                       
                        # display message
                        echo -e "\nSearching within $i, cert path set within file is: $SSL_CERT";
                       
                        # check cert's expiration date
                        EXPIRATION_DATE=$(openssl x509 -in $SSL_CERT -noout -enddate);
                       
                        # display message
                        echo -e "The certificate \e[32m$SSL_CERT\e[0m is set to expire \e[31m$EXPIRATION_DATE\e[0m\n";
                fi
        done
fi
