#!/bin/bash

source .env
# source .secrets

use_downloaded=false
keep=false

# Getting Arguments
while getopts ku flag; do
	case "${flag}" in
	k) keep=true ;;
	u) use_downloaded=true ;;
	esac
done

# Preparing the directories
if [ ! -d "./bin" ]; then
	mkdir bin
fi

if [ ! -d "./saves" ]; then
	mkdir saves
fi

if [ ! -d "./mods" ]; then
	mkdir mods
fi

if [ ! -d "./config" ]; then
	mkdir config
fi

if $use_downloaded; then
	echo -e $GREEN"Using the previous downloaded files!"$NC
else

	# Getting the latest version of Factorio
	echo -e $GREEN"Getting the latest version of Factorio ..."$NC
	# https://factorio.com/api/latest-releases
	factorio_version=$(curl -s https://factorio.com/api/latest-releases | grep -oP '(\d+\.\d+\.\d+)' | head -1)
	if [ -z "$FACTORIO_VERSION" ]; then
		echo -e $YELLOW"\tUsing version ${factorio_version} of Factorio"$NC
	else
		echo -e $YELLOW"\tLatest version of Factorio: ${factorio_version}"$NC
		factorio_version=$FACTORIO_VERSION
		echo -e $GREEN"Using version ${factorio_version} of Factorio defined in .env file ..."$NC

	fi

	# Loging in to Factorio
	echo -e $GREEN"Logging in to Factorio ..."$NC
	session=$(curl -s -c - https://www.factorio.com/login | grep -oP 'session\s+\K\S+')

	if [ -z "$FACTORIO_USERNAME" ]; then
		echo -e $YELLOW"\tUsername: "$NC
		read username
	else
		echo -e $YELLOW"\tUsername: ${FACTORIO_USERNAME}"$NC
		username=$FACTORIO_USERNAME
	fi

	if [ -z "$FACTORIO_PASSWORD" ]; then
		echo -e $YELLOW"\tPassword: "$NC
		read -s password
	else
		echo -e $YELLOW"\tPassword: ********"$NC
		password=$FACTORIO_PASSWORD
	fi
	data="csrf_token=${session}&username_or_email=${username}&password=${password}"
	# echo -e $data
	response=$(curl -X POST -d "${data}" -s https://www.factorio.com/login)
	# not working !!!
	# TODO: check the response
	# exit 0

	# Download Factorio headless server
	if [ -f "./bin/factorio_headless.tar.xz" ]; then
		echo -e $GREEN"File already exists: ./bin/factorio_headless.tar.xz!\r\n\t"$YELLOW"deleting ./bin/factorio_headless.tar.xz ..."$NC
		rm -f "./bin/factorio_headless.tar.xz"
	fi

	echo -e $GREEN"Downloading ...\r\n\t"$YELLOW"https://factorio.com/get-download/${factorio_version}/headless/linux64"$NC

	curl "https://www.factorio.com/get-download/${factorio_version}/headless/linux64?username=${username}&token=${session}" -L --progress-bar --output "./bin/factorio_headless.tar.xz"

	# curl -L --progress-bar "https://factorio.com/get-download/${factorio_version}/headless/linux64" -o "./bin/factorio_headless.tar.xz"

fi
# exit 0

# Extracting Factorio headless server
if [ -d "./bin/factorio" ]; then
	echo -e $GREEN"Directory already exists: ./bin/factorio!\r\n\t"$YELLOW"deleting ./bin/factorio ..."$NC
	rm -rf "./bin/factorio"
fi

echo -e $GREEN"Extracting ...\r\n\t"$YELLOW"./bin/factorio_headless.tar.xz"$NC
tar -xf "./bin/factorio_headless.tar.xz" -C "./bin"

# Clean up
if $keep; then
	echo -e $GREEN"Keeping the files!"$NC
	exit 0
fi

echo -e $GREEN"Cleaning up ...\r\n\t"$YELLOW"deleting ./bin/factorio_headless.tar.xz ..."$NC
rm -f "./bin/factorio_headless.tar.xz"
echo -e $YELLOW"\tdeleting ./bin/factirio ..."$NC
rm -rdf "./bin/factorio"
echo -e $GREEN"Done!"$NC
