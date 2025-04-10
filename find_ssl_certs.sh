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
	SSL_CERTS=$(grep -i 'SSLCertificateFile' "$FILE" | grep -v '^\s*#' | xargs | tr -d '\r\n');

        # check that the variable is not empty
        if [[ -n $SSL_CERTS ]]
        then
            # sanitize variable
	    if [[ $(echo $SSL_CERTS | grep -i '=') ]]
	    then
		SSL_CERTS=$(echo "$SSL_CERTS" | cut -d '=' -f 2);
	    else
		SSL_CERTS=$(echo "$SSL_CERTS" | awk '{print $2}');

	    fi

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

        # cert info
	CA=$(openssl x509 -in $SSL_CERTS -noout -issuer | grep -oP 'CN\K.*' | cut -d '=' -f 2 | xargs);
	ISSUING_DATE=$(openssl x509 -in "$SSL_CERTS" -noout -startdate);
        EXPIRATION_DATE=$(openssl x509 -in $SSL_CERTS -noout -enddate);

        # display message
	echo -e "\nSearching within \e[35m${FILE}\e[0m ... Will now extract certificate info."
	echo -e "Certificate file: \e[32m${SSL_CERTS}\e[0m";
	echo -e "Issuing CA: \e[36m${CA}\e[0m";
	echo -e "Certificate start date: \e[32m${ISSUING_DATE}\e[0m";
	echo -e "Certificate expiration date: \e[31m${EXPIRATION_DATE}\e[0m"

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
    TOMCAT_SSL_CERT=$(grep -i 'certificateKeystoreFile' $FILE | grep -v '^\s*#');
    KEYSTORE_PASS=$(grep -i 'certificateKeystorePass' $FILE | grep -v '^\s*#');
    KEYSTORE_TYPE=$(grep -i 'certificateKeystoreType' $FILE | grep -v '^\s*#');

    # sanitize variables
    if [[ -n $TOMCAT_SSL_CERT ]]
    then
        if [[ $TOMCAT_SSL_CERT =~ ^[[:space:]].+ ]]
        then
            TOMCAT_SSL_CERT=$(echo $TOMCAT_SSL_CERT | xargs);
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
            KEYSTORE_TYPE=$(echo $KEYSTORE_TYPE | xargs);
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
    CA=$(openssl ${KEYSTORE_TYPE,,} -in ${TOMCAT_SSL_CERT} -nokeys -clcerts -passin pass:${KEYSTORE_PASS} | openssl x509 -noout -issuer | grep -oP 'CN\K.*' | cut -d '=' -f 2);
    TOMCAT_ISSUING_DATE=$(openssl ${KEYSTORE_TYPE,,} -in ${TOMCAT_SSL_CERT} -nokeys -clcerts -passin pass:${KEYSTORE_PASS} | openssl x509 -noout -startdate);
    TOMCAT_EXPIRATION_DATE=$(openssl ${KEYSTORE_TYPE,,} -in ${TOMCAT_SSL_CERT} -nokeys -clcerts -passin pass:${KEYSTORE_PASS} | openssl x509 -noout -enddate);

    # display messages
    echo -e "\nSearching within \e[35m$FILE\e[0m ... Will now extract cert info.";
    echo -e "Certificate file: \e[33m${TOMCAT_SSL_CERT}\e[0m";
    echo -e "Issuing CA: \e[36m${CA}\e[0m";
    echo -e "Certificate start date: \e[32m${}\e[0m";
    echo -e "Certificate expiration date: \e[31m${TOMCAT_EXPIRATION_DATE}\e[0m\n";

    # unset variables
    unset TOMCAT_SSL_CERT;
    unset KEYSTORE_PASS;
    unset KEYSTORE_TYPE;
    unset TOMCAT_EXPIRATION_DATE;
    unset CA;
    unset TOMCAT_ISSUING_DATE;
done
