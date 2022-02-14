#!/bin/bash
# Name: logCollector.sh
# Created on: Febuary 14, 2021
# Created by: Caleb Farrell<caleb.farrell@introhive.com>
# Description: Installs Rosetta 2 if the Mac is running on ARM

architecture=$(/usr/bin/arch)

if [ "$architecture" == "arm64" ]; then
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
elif ["$architecture" == "i386" ]; then
	echo "Intel Processor, No need for Rosetta!"
else
	echo "Unknown Architecture"
fi
