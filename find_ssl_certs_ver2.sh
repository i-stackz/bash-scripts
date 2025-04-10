## ChatGPT script version with suggested improvements implemented ##

#!/usr/bin/env bash

#################################################################
# Date: 4/3/2025                                                #
# Author: E. Gomez                                              #
# Description: This script will search and find SSL certs       #
# Iteration: ver: 2.0                                           #
# Note: Refined with the help of ChatGPT. It assisted me in     #
# implementing repeating code into a function and improving     #
# the while loop.
#################################################################

# --- Utility Functions --- #

sanitize() {
    
    # variables
    local value="$1"
   
    value="$(echo "$value" | grep -v '^\s*#' | tr -d '\r\n')"; # remove any '#','\r','\n' characters
    value="$(echo "$value" | xargs)";                     # Trim leading/trailing whitespace

    # check if value contains equal sign
    if [[ $(echo "$value" | grep -i '=') ]]
    then
        # grab second field after equal sign
        value="$(echo "$value" | awk -F '=' '{print $2}')";
    else
        # grab the second field after the space
        value="$(echo "$value" | awk '{print $2}')";
    fi

    value="${value%\"}";            # remove trailing double quote
    value="${value#\"}";            # remove starting double quote
    value="${value%\'}";            # remove trailing single quote
    value="${value#\'}";            # Remove starting single quote

    # print out value variable
    echo "$value";

}

# --- HTTPD SSL Cert Check --- #

# check if the package is installed or if process is running
if [[ $(yum list installed 2>/dev/null | grep -i 'httpd') || $(ps -ef | grep -i '[h]ttpd') ]] 
then
    # while loop that will take the output of the find command as input to iterate through
    while IFS= read -r FILE; do
        # variable
        SSL_CERTS=$(sanitize "$(grep -i 'SSLCertificateFile' "$FILE")")

        # if statement to check if variable is not empty and if its contents is an existing file
        if [[ -n "$SSL_CERTS" && -f "$SSL_CERTS" ]]
        then
            # variables
            CA=$(openssl x509 -in "$SSL_CERTS" -noout -issuer | grep -oP 'CN\K.*' | cut -d '=' -f 2 | xargs);
            ISSUING_DATE=$(openssl x509 -in "$SSL_CERTS" -noout -startdate 2>/dev/null);
            EXPIRATION_DATE=$(openssl x509 -in "$SSL_CERTS" -noout -enddate 2>/dev/null);

            echo -e "\nSearching within \e[35m$FILE\e[0m ... Will now extract information from the certificate."
            echo -e "Certificate file: \e[33m$SSL_CERTS\e[0m";
            echo -e "Issuing CA: \e[36m$CA\e[0m";
            echo -e "Certificate start date: \e[32m$ISSUING_DATE\e[0m";
            echo -e "Certificate expiration date: \e[31m${EXPIRATION_DATE}\e[0m\n";
        fi
    done < <(find / -xdev -type f \( -name "ssl.conf" -o -name "*ssl.conf" -o -name "*ssl*.conf" \) 2>/dev/null)
fi

# --- Tomcat SSL Cert Check --- #

# if statement to check if package is installed or if process is running
if [[ $(yum list installed 2>/dev/null | grep -i 'tomcat') || $(ps -ef | grep -i 'tomcat') ]]
then
    # while loop that will take the find command as input to iterate through
    while IFS= read -r FILE
    do
        # variables
        TOMCAT_SSL_CERT=$(sanitize "$(grep -i 'certificateKeystoreFile' "$FILE")")
        KEYSTORE_PASS=$(sanitize "$(grep -i 'certificateKeystorePass' "$FILE")")
        KEYSTORE_TYPE=$(sanitize "$(grep -i 'certificateKeystoreType' "$FILE")")

        # if statement to check if variable is not empty and if the variable's content is a file that exists
        if [[ -n "$TOMCAT_SSL_CERT" && -f "$TOMCAT_SSL_CERT" ]]; then
            # variables
            CMD_TYPE=${KEYSTORE_TYPE,,} # lowercase keystore type (e.g. pkcs12)
            CA=$(openssl "$CMD_TYPE" -in "$TOMCAT_SSL_CERT" -nokeys -clcerts -passin pass:"$KEYSTORE_PASS" 2>/dev/nullk | openssl x509 -noout -issuer | grep -oP 'CN\K.*' | cut -d '=' -f 2 | xargs); # grab the CN info from the cert
            TOMCAT_ISSUING_DATE=$(opnessl "$CMD_TYPE" -in "$TOMCAT_SSL_CERT" -nokeys -clcerts -passin pass:"$KEYSTORE_PASS" 2>/dev/null | openssl x509 -noout -startdate 2>/dev/null); # grab the start date on cert 
            TOMCAT_EXPIRATION_DATE=$(openssl "$CMD_TYPE" -in "$TOMCAT_SSL_CERT" -nokeys -clcerts -passin pass:"$KEYSTORE_PASS" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null); # grab the expiration date on cert

            # display messages
            echo -e "\nSearching within \e[35m$FILE\e[0m ... Will now extract information from the certificate."
            echo -e "Certificate file: \e[33m$TOMCAT_SSL_CERT\e[0m";
            echo -e "Issuing CA: \e[36m$CA\e[0m";
            echo -e "Certificate start date: \e[32m$TOMCAT_ISSUING_DATE\e[0m";
            echo -e "Certificate expiration date: \e[31m${TOMCAT_EXPIRATION_DATE}\e[0m\n";
        fi

    done < <(find / -xdev -type f -name 'server.xml' 2>/dev/null)
fi
