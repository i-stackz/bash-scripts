
Conversation opened. 1 unread message.

Skip to content
Using Virginia's Community Colleges Mail with screen readers

1 of 179
version 2.0 of ssl search script
Inbox

Estiben Gomez <eme2417@email.vccs.edu>
2:20 PM (2 hours ago)
to me

#!/usr/bin/env bash

#################################################################
# Date: 4/3/2025                                                #
# Author: E. Gomez                                              #
# Description: This script will search and find SSL certs       #
# Edited 4/7/2025						#
#################################################################

# variables for httpd
SSL_CERTS="";
EXPIRATION_DATE="";

# logic to find HTTP's SSL cert path
if [[ $(yum list installed | grep -i 'httpd') || $(ps -ef | grep -i 'httpd') ]]
then
    # search for the ssl.conf file
    for i in $(find / -xdev -type f \( -name "ssl.conf" -o -name "*ssl.conf" -o -name "*ssl*.conf" \))
    do
        # TEST #
        #grep -i 'sslcertificatefile' $i;

        # if statement to check if grep command is not empty
        if [[ -n $(grep -i 'sslcertificatefile' $i) ]]
        then
            # set variable
            SSL_CERT=$(grep -i 'sslcertificatefile' $i | awk '{print $2}' | cut -d '"' -f 2);

            # TEST #
            #echo -e "\n$SSL_CERT\n";

            # display message
            echo -e "\nSearching within $i. The SSL certificate path is specified in $i: $SSL_CERT";
            echo -e "Will now extract the expiration date from the certificate";
            echo -e "The certificate \e[32m$SSL_CERT\e[0m is set to expire \e[31m$EXPIRATION_DATE\e[0m\n";

	    # clean variables
	    unset {SSL_CERTS,EXPIRATION_DATE};
        fi
    done
fi

# variables for Apache Tomcat
TOMCAT_SSL_CERT="";
TOMCAT_EXPIRATION_DATE="";
KEYSTORE_TYPE="";
KEYSTORE_PASS="";

# logic to find Apache Tomcat's SSL cert path
if [[ $(yum list installed | grep -i 'tomcat') || $(rpm -qa | grep -i 'tomcat') || $(ps -ef | grep -i 'tomcat') ]]
then
    # search for the server.xml file
    for i in $(find / -xdev -type f \( -name "server.xml"\))
    do
        if [[ -n $(grep -i 'certificatekeystorefile' $i) ]]
        then

            # set variables
            TOMCAT_SSL_CERT=$(grep -i 'certificatekeystorefile' $i | cut -d '=' -f 2 | cut -d '"' -f 2);
            KEYSTORE_TYPE=$(grep -i 'certificatekeystoretype' $i | cut -d '=' -f 2 | cut -d '"' -f 2);
            KEYSTORE_PASS=$(grep -i 'certificatekeystorepass' $i | cut -d '=' -f 2 | cut -d '=' -f 2 | cut -d '"' -f 2);
            TOMCAT_EXPIRATION_DATE=$(openssl ${KEYSTORE_TYPE,,} -in $TOMCAT_SSL_CERT -nokeys -clcerts -passin pass:$KEYSTORE_PASS | openssl x509 -noout -enddate);

            # TESTS #
            #echo $TOMCAT_SSL_CERT;
            #echo $KEYSTORE_TYPE;
            #echo $KEYSTORE_PASS;

            # display message
            echo -e "\nSearching within $i. The SSL certificate path set within $i is $TOMCAT_SSL_CERT";
            echo -e "Will now extract the expiration date from $TOMCAT_SSL_CERT";
            echo -e "The Apache Tomcat certificate \e[32m$TOMCAT_SSL_CERT\e[0m is set to expire \e[31m$TOMCAT_EXPIRATION_DATE\e[0m\n";

            # clean up the variables
            unset {TOMCAT_SSL_CERT,KEYSTORE_TYPE,KEYSTORE_PASS,TOMCAT_EXPIRATION_DATE};
        fi
    done
fi

