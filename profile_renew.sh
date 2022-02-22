#!/bin/bash
# Name: profile_renew.sh
# Created on: January 17, 2021
# Created by: Caleb Farrell<caleb.farrell@introhive.com>
# Description: When the Jamf MDM profile doesn't apply correctly or becomes corrupted
# This script can be sent to the user and ran to renew the profile and reboot



if (($EUID != 0)); then
  if [[ -t 1 ]]; then
    sudo "$0" "$@"
  else
    exec 1>output_file
    gksu "$0 $@"
  fi
  exit
fi

sudo profiles renew -type enrollment -verbose > ~/profile_renew.log
sleep 2
echo "Please click on the Notification that has appeared in the top right. Follow the prompts on screen."
sleep 5
echo "Your Mac will restart in 5 minutes. Please save any work."
sleep 2
shutdown -r +5
sleep 2
