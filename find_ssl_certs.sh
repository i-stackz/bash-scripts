#!/usr/bin/env bash

#################################################################
# Date: 4/3/2025                                                #
# Author: E. Gomez                                              #
# Description: This script will search and find SSL certs       #
#################################################################

# variables for httpd
SSL_CERTS="";
EXPIRATION_DATE="";

# logic to find cert path for HTTPS server
if [[ $(yum list installed | grep -i 'httpd') || $(ps -ef | grep -i 'httpd') ]]
then
    # search for HTTPD config file
    for FILE in $(find / -xdev -type f \( -name "ssl.conf" -o -name "*ssl.conf" -o -name "*ssl*.conf"\))
    do
        # TEST #
        #grep -i 'SSLCertificateFile' $FILE;

        # set variable value
        SSL_CERTS=$(grep -i 'SSLCertificateFile' $FILE | awk '{print $2}' | tr -d '\r\n'); # removes any newline or return characters as well

        # check that the variable is not empty
        if [[ -n $SSL_CERTS ]]
        then
            # sanitize variable
            if [[ $SSL_CERTS =~ \" ]]
            then
                # remove double quotes
                SSL_CERTS=$(echo $SSL_CERT | cut -d '"' -f 2);
            fi

            if [[ $(echo $SSL_CERTS | grep -i "'") ]]
            then
                # remove single quotes
                SSL_CERTS=$(echo $SSL_CERTS | cut -d "'" -f 2);
            fi
        fi

        # TEST #
        #echo -e "\n$SSL_CERTS"

        # set expiration date
        EXPIRATION_DATE=$(openssl x509 -in $SSL_CERTS -noout -enddate);

        # display message
        echo -e "\nSearching within \e[36m$FILE\e[0m, the cert path set within the file is: \e[33m${SSL_CERTS}\e[0m";
        echo -e "Will now extract the expiration date from the certificate";
        echo -e "\n[32m${SSL_CERTS}\e[0m is set to expire: \e[31m${EXPIRATION_DATE}\e[0m\n";

        # unset variables
        unset SSL_CERTS;
        unset EXPIRATION_DATE;
    done
fi


# variables for Tomcat Apache
TOMCAT_SSL_CERT="";
TOMCAT_EXPIRATION_DATE="";
KEYSTORE_TYPE="";
KEYSTORE_PASS="";

# search for apache tomcat configuration files
for FILE in $(find / -xdev -type f \( -name 'server.xml'\))
do
    # set variable values
    TOMCAT_SSL_CERT=$(grep -i 'certificateKeystoreFile' $FILE);
    KEYSTORE_PASS=$(grep -i 'certificateKeystorePass' $FILE);
    KEYSTORE_TYPE=$(grep -i 'certificateKeystoreType' $FILE);

    # sanitize variables
    if [[ -n $TOMCAT_SSL_CERT ]]
    then
        if [[ $TOMCAT_SSL_CERT =~ ^[[:space:]].+ ]]
        then
            TOMCAT_SSL_CERT=$(echo $TOMCAT_SSL_CERT | tr -d '\t');
        fi

        if [[ $TOMCAT_SSL_CERT =~ = ]]
        then
            TOMCAT_SSL_CERT=$(echo $TOMCAT_SSL_CERT | cut -d '=' -f 2);
        fi

        if [[ $TOMCAT_SSL_CERT =~ \" ]]
        then
            TOMCAT_SSL_CERT=$(echo $TOMCAT_SSL_CERT | cut -d '"' -f 2);
        fi

        if [[ $(echo $TOMCAT_SSL_CERT | grep "'") ]]
        then
            TOMCAT_SSL_CERT=$(echo $TOMCAT_SSL_CERT | cut -d "'" -f 2);
        fi
    fi

    if [[ -n $KEYSTORE_TYPE ]]
    then
        if [[ $KEYSTORE_TYPE =~ ^[[:space:]].+ ]]
        then
            KEYSTORE_TYPE=$(echo $KEYSTORE_TYPE | tr -d '\t');
        fi

        if [[ $KEYSTORE_TYPE =~ = ]]
        then
            KEYSTORE_TYPE=$(echo $KEYSTORE_TYPE | cut -d '=' -f 2);
        fi

        if [[ $KEYSTORE_TYPE =~ \" ]]
        then
            KEYSTORE_TYPE=$(echo $KEYSTORE_TYPE | cut -d '"' -f 2);
        fi

        if [[ $(echo $KEYSTORE_TYPE | grep "'") ]]
        then
            KEYSTORE_TYPE=$(echo $KEYSTORE_TYPE | cut -d "'" -f 2);
        fi
    fi

    if [[ -n $KEYSTORE_PASS ]]
    then
        if [[ $KEYSTORE_PASS =~ ^[[:space:]].+ ]]
        then
            KEYSTORE_PASS=$(echo $KEYSTORE_PASS | tr -d '\t');
        fi

        if [[ $KEYSTORE_PASS =~ = ]]
        then
            KEYSTORE_PASS=$(echo $KEYSTORE_PASS | cut -d '=' -f 2);
        fi

        if [[ $KEYSTORE_PASS =~ \" ]]
        then
            KEYSTORE_PASS=$(echo $KEYSTORE_PASS | cut -d '"' -f 2);
        fi

        if [[ $(echo $KEYSTORE_PASS | grep "'") ]]
        then
            KEYSTORE_PASS=$(echo $KEYSTORE_PASS | cut -d "'" -f 2);
        fi
    fi

    # TEST #
    #echo $TOMCAT_SSL_CERT;
    #echo $KEYSTORE_TYPE;
    #echo $KEYSTORE_PASS;

    # set expiration date variable
    TOMCAT_EXPIRATION_DATE=$(openssl ${KEYSTORE_TYPE,,} -in ${TOMCAT_SSL_CERT} -nokeys -clcerts -passin pass:${KEYSTORE_PASS} | openssl x509 -noout -enddate);

    # display messages
    echo -e "\nSearching within \e[36m$FILE\e[0m, the cert path set within the file is: \e[33m${TOMCAT_SSL_CERT}\e[0m";
    echo -e "Will now extract the expiration date from the certificate";
    echo -e "\e[32m${TOMCAT_SSL_CERT}\e[0m is set to expire: \e[31m${TOMCAT_EXPIRATION_DATE}\e[0m\n";

    # unset variables
    unset TOMCAT_SSL_CERT;
    unset KEYSTORE_PASS;
    unset KEYSTORE_TYPE;
    unset TOMCAT_EXPIRATION_DATE;
done
