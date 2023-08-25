#!/bin/bash

#CURL
CURL="/usr/bin/curl"
CURLARGS="-H"

#NODEJS
NODEJS_RELEASES="https://nodejs.org/download/release/index.json"
NODEJS_BASE_URL="https://nodejs.org/dist/"
NODEJS_VERSIONS_REGEX='/v(\d+)\.(\d+)\.(\d+)/'
NODEJS_VERSIONS=
ARGUMENT_LIST=(
    "help"
    "lts"
    "current"
    "version"
)
ARCH=""

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


get_arch()
{
    case $(uname -m) in
        x86_64)
            ARCH="linux-x64" ;;
        arm)
            dpkg --print-architecture | grep -q "arm64" && ARCH="linux-arm64" || ARCH="linux-arm71" ;;
    esac
}

############################################################
# LTS                                                      #
############################################################

get_lts()
{
    NODEJS_LTS_VERSION=$($CURL -s -X GET $NODEJS_RELEASES -H "Content-type: application/json" -H "Accept: application/json" | jq -r 'first(.[] | select(.lts != false)) | .version')

    get_arch # Get current architecture

    echo "Get Nodejs lts version"
    echo "Latest LTS version = "
    echo 
    echo $NODEJS_LTS_VERSION
    NODEJS_LTS_DOWNLOAD=$($CURL -# -L -O "${NODEJS_BASE_URL}${NODEJS_LTS_VERSION}/node-${NODEJS_LTS_VERSION}-${ARCH}.tar.xz")
    echo $NODEJS_LTS_DOWNLOAD 
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
        *)
            echo "Error please give valid argument"
            echo
            get_help
            exit 0;;
        --) shift
            break;;
    esac
    shift
done
