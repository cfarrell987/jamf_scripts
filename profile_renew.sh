#!/bin/bash
# Name: profile_renew.sh
# Created on: January 17, 2021
# Created by: Caleb Farrell<caleb.farrell@introhive.com>
# Description: When the Jamf MDM profile doesn't apply correctly or becomes corrupted
# This script can be sent to the user and ran to renew the profile and reboot

if ! [ $(id -u) = 0 ]; then
	echo "Please run as root by appending sudo."
	exit 1
else
	profiles renew -type enrollment -verbose | echo ~/profile_renew.log
	sleep 2
	echo "Your Mac will restart in 5 minutes. Please save any work."
	sleep 2
	shutdown -r +5
	sleep 2
fi
