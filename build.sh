#!/bin/bash

source .env
# source .secrets


# Getting Arguments
# while getopts ku flag; do
# 	case "${flag}" in
# 	k) keep=true ;;
# 	u) use_downloaded=true ;;
# 	esac
# done

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

# Deleting the old stuff because the Repo https://github.com/factoriotools/factorio-docker does everything!

