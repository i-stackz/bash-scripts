#!/usr/bin/env bash

#################################################################
# Date: 4/3/2025                                                #
# Author: E. Gomez                                              #
# Description: This script will search and find SSL certs       #
#################################################################

# variables for httpd
ssl_cert="";
expiration_date="";

# logic to find cert path for https server
if [[ "$(yum list installed | grep -i 'httpd')" || "$(ps -ef | grep -i 'httpd')" ]]
then
    # search for ssl.conf file
    for file in "$(find / -xdev -type f \( -name "ssl.conf" -o -name "*ssl.conf" -o -name "*ssl*.conf"\))"
    do
        # TEST # 
        # grep each finding
        #grep 'SSLCertificateFile' "${file}";
        # End TEST #

        # check if grep isn't empty
        if [[ -n $(grep -i 'SSLCertificateFile' "${file}") ]]
        then
                # set ssl_cert variable
                ssl_cert="$(grep -i 'SSLCertificateFile' "${file}" | grep -v '^\s*#' | xargs | tr -d '\r\n')"; # xargs removes beginning whitespace, '^\s*#' removes comments and optional whitespace

                # sanitize ssl_cert variable # 

                # check for equal sign
                if [[ "${ssl_cert}" =~ = ]]
                then
                    # remove equal sign
                    ssl_cert="$(echo $ssl_cert | cut -d '=' -f 2)";
                fi

                # check for double quotes
                if [[ "${ssl_cert}" =~ \" ]]
                then
                    # remove double quotes
                    ssl_cert="$(echo $ssl_cert | cut -d '"' -f 2)";
                fi

                # check for single quotes
                if [[ "${ssl_cert}" =~ \' ]]
                then
                    # remove single quotes
                    ssl_cert="$(echo $ssl_cert | cut -d "'" -f 2)";
                fi

                # TEST #
                #echo -e "\n$ssl_cert\n";

                # cert info variables
                ca="$(openssl x509 -in "$ssl_cert" -noout -issuer | grep -oP 'CN\K.*' | cut -d '=' -f 2 | xargs)"; # grabs CA info from certs
                issuing_date="$(openssl x509 -in "$ssl_cert" -noout -startdate)";
                expiration_date="$(openssl x509 -in "$ssl_cert" -noout -enddate)";

                # display message
                echo -e "\nSearching within \e[35m${file}\e[0m ... Will now extract certificate info.";
                echo -e "Certificate file: \e[33m${ssl_cert}\e[0m";
                echo -e "Issuing CA: \e[36m${ca}\e[0m";
                echo -e "Certificate start date: \e[31m${issuing_date}\e[0m";
                echo -e "Certificate expiration date: \e[31m${expiration_date}\e[0m\n";

                # clean up variables
                unset "$ssl_cert";
                unset "$issuing_date";
                unset "$expiration_date";
        fi
    done
fi




# variables for Tomcat Apache
tomcat_ssl_cert="";
tomcat_expiration_date="";
keystore_pass="";
keystore_type="";

# Logic to find the cert path for Apache Tomcat
if [[ "$(yum list installed | grep -i 'tomcat')" || "$(ps -ef | grep -i 'tomcat')" ]]
then
        # search for server.xml file
        for file in $(find / -xdev -type f \( -name 'server.xml' \))
        do
                # set variable values
                tomcat_ssl_cert="$(grep -i 'certificateKeystoreFile' $file)";
                keystore_type="$(grep -i 'certificateKeystoreType' $file)";
                keystore_pass="$(grep -i 'certificateKeystorePass' $file)";

                # sanitize variables # 

                # check if variable is not empty
                if [[ -n "${tomcat_ssl_cert}" ]]
                then
                        # check for spaces
                        if [[ "${tomcat_ssl_cert}" =~ ^[[:space:]].* ]]
                        then
                            # remove spaces
                            tomcat_ssl_cert="$(echo $tomcat_ssl_cert | xargs)";
                        fi

                        # check for equal sign
                        if [[ "${tomcat_ssl_cert}" =~ = ]]
                        then
                            # remove equal sign
                            tomcat_ssl_cert="$(echo $tomcat_ssl_cert | cut -d '=' -f 2)";
                        fi

                        # check for double quotes
                        if [[ "${tomcat_ssl_cert}" =~ \" ]]
                        then
                            # remove double quotes
                            tomcat_ssl_cert="$(echo $tomcat_ssl_cert | cut -d '"' -f 2)";
                        fi

                        # check for single quotes
                        if [[ "${tomcat_ssl_cert}" =~ \' ]]
                        then
                            # remove single quote
                            tomcat_ssl_cert="$(echo $tomcat_ssl_cert | cut -d "'" -f 2)";
                        fi
                fi

                # check if variable is not empty
                if [[ -n "${keystore_pass}" ]]
                then
                        # check for spaces
                        if [[ "${keystore_pass}" =~ ^[[:space:]].* ]]
                        then
                            # remove spaces
                            keystore_pass="$(echo $keystore_pass | xargs)";
                        fi

                        # check for equal sign
                        if [[ "${keystore_pass}" =~ = ]]
                        then
                            # remove equal sign
                            keystore_pass="$(echo $keystore_pass | cut -d '=' -f 2)";
                        fi

                        # check for double quotes
                        if [[ "${keystore_pass}" =~ \" ]]
                        then
                            # remove double quotes
                            keystore_pass="$(echo $keystore_pass | cut -d '"' -f 2)";
                        fi

                        # check for single quotes
                        if [[ "${keystore_pass}" =~ \' ]]
                        then
                            # remove single quote
                            keystore_pass="$(echo $keystore_pass | cut -d "'" -f 2)";
                        fi
                fi

                # check if variable is not empty
                if [[ -n "${keystore_type}" ]]
                then
                        # check for spaces
                        if [[ "${keystore_store}" =~ ^[[:space:]].* ]]
                        then
                            # remove spaces
                            keystore_type="$(echo $keystore_type | xargs)";
                        fi

                        # check for equal sign
                        if [[ "${keystore_type}" =~ = ]]
                        then
                            # remove equal sign
                            keystore_type="$(echo $keystore_type | cut -d '=' -f 2)";
                        fi

                        # check for double quotes
                        if [[ "${keystore_type}" =~ \" ]]
                        then
                            # remove double quotes
                            keystore_type="$(echo $keystore_type | cut -d '"' -f 2)";
                        fi

                        # check for single quotes
                        if [[ "${keystore_type}" =~ \' ]]
                        then
                            # remove single quote
                            keystore_type="$(echo $keystore_type | cut -d "'" -f 2)";
                        fi
                fi

                # TEST #
                #echo $tomcat_ssl_cert;
                #echo $keystore_type;
                #echo $keystore_pass;

                # cert info variables
                ca="$(openssl "${keystore_type,,}" -in "${tomcat_ssl_cert}" -nokeys -clcerts -passin pass:"${keystore_pass}" | openssl x509 -noout -issuer | grep -oP 'CN\K.*' | cut -d '=' -f 2 | xargs)";
                tomcat_issuing_date="$(openssl "${keystore_type,,}" -in "${tomcat_ssl_cert}" -nokeys -clcerts -passin pass:"${keystore_pass}" | openssl x509 -noout -startdate)";
                tomcat_expiration_date="$(openssl "${keystore_type,,}" -in "${tomcat_ssl_cert}" -nokeys -clcerts -passin pass:"${keystore_pass}" | openssl x509 -noout -enddate)";

                # display messages
                echo -e "Searching within \e[35m${file}\e[0m ... will now extract certificate info";
                echo -e "Certificate file: \e[33m${tomcat_ssl_cert}\e[0m";
                echo -e "Issuing CA: \e[36m${ca}\e[0m";
                echo -e "Certificate start date: \e[32m${tomcat_issuing_date}\e[0m";
                echo -e "Certificate expiration date: \e[31m${tomcat_expiration_date}\e[0m\n";

                # unset variables
                unset tomcat_ssl_cert;
                unset keystore_pass;
                unset keystore_type;
                unset ca;
                unset tomcat_issuing_date;
                unset tomcat_expiration_date;
        done
fi

