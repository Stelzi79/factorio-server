#!/bin/bash

source .env

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

# Getting the latest version of Factorio
if [ -z "$FACTORIO_VERSION" ]; then
	echo -e $GREEN"Getting the latest version of Factorio ..."$NC
	factorio_version=$(curl -s https://factorio.com/get-download/latest/headless/linux64 | grep -oP '(\d+\.\d+\.\d+)' | head -1)
	echo -e $YELLOW"\tUsing version ${factorio_version} of Factorio"$NC
else
	echo -e $GREEN"Using version ${FACTORIO_VERSION} of Factorio defined in .env file ..."$NC
	factorio_version=$FACTORIO_VERSION
fi

# Download Factorio headless server
if [ -f "./bin/factorio_headless.tar.xz" ]; then
	echo -e $GREEN"File already exists: ./bin/factorio_headless.tar.xz!\r\n\t"$YELLOW"deleting ./bin/factorio_headless.tar.xz ..."$NC
	rm -f "./bin/factorio_headless.tar.xz"
fi

echo -e $GREEN"Downloading ...\r\n\t"$YELLOW"https://factorio.com/get-download/${factorio_version}/headless/linux64"$NC

#exit 0

curl -L --progress-bar "https://factorio.com/get-download/${factorio_version}/headless/linux64" -o "./bin/factorio_headless.tar.xz"
