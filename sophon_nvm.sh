#!/bin/bash

#CURL
CURL="/usr/bin/curl"
CURLARGS="-H"

#NODEJS
NODEJS_RELEASES="https://nodejs.org/download/release/index.json"
NODEJS_BASE_URL="https://nodejs.org/dist/"
NODEJS_VERSIONS_REGEX='/v(\d+)\.(\d+)\.(\d+)/'
NODEJS_VERSIONS=
NODEJS_LTS_VERSION=
ARGUMENT_LIST=(
    "help"
    "lts"
    "current"
    "version"
)

############################################################
# Help                                                     #
############################################################

get_help()
{
    # Display Help
    echo "Options available."
    echo
    echo "Syntax: snvm [--lts| --current| --help| --version]"
    echo "Options: "
    echo "--help         Get help"
    echo "--lts          Get LTS Nodejs version"
    echo "--current      Get current Nodejs version"
    echo "--version      Get version"
}


get_all_release()
{
    VERSIONS=$($CURL -X GET $NODEJS_RELEASES -H "Content-type: application/json" -H "Accept: application/json" | jq -r '.[] | select(.lts != false) | [ .version, .date, .lts, select(.files == "linux-x64") ]')
    echo $VERSIONS
}
############################################################
# LTS                                                      #
############################################################



get_lts()
{
    echo "Get Nodejs lts version"
    get_all_release    
}


options=$(getopt --longoptions "$(printf "%s," "${ARGUMENT_LIST[@]}")" --options "" -- "$@")

eval set --"$options"

while true ; do
    case "$1" in
        --help)
            get_help
            exit 0;;
        --lts)
            get_lts
            exit 0;;
        --) shift
            break;;
    esac
    shift
done
