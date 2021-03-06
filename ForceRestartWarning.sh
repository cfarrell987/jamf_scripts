#!/bin/bash

###
#
#            Name:  ForceRestartWarning.sh
#     Description:  Alerts User of Upcoming restart for compliance issues, 
#					Forces a restart within X defined time
#		  Created By: Caleb Farrell <caleb.farrell@valhallahosting.ca>
#         Created:  2022-03-18
#   Last Modified:  2022-03-21
#         Version:  1.1.0
#
###

loggedInUser=$(stat -f%Su /dev/console)

#Specify how long until the restart
DEFER_MINUTES=420
declare -i DEFER_MINUTES
DEFER_HOURS=`expr $DEFER_MINUTES / 60`
TIMEOUT=600
RESTART_DELAY=1
#Define the Logo Path, Will be unpacked from a DMG to this location
LOGO="/Library/Application Support/Introhive/IntrohiveLogo.png"

#Define buttons
button1="Defer $DEFER_HOURS hours"
button2="Reboot Now"
DEFAULT_BUTTON="2"

WINDOW_TYPE="hud"

#Title of Notification
PROMPT_TITLE="IT Dept Notice:"
#Body of the Message, Edit within the double Quotes.
PROMPT_MESSAGE="Your Mac will restart in $DEFER_MINUTES minutes to resolve a compliance issue detected.

Please acknowledge this notice by clicking OK.

If You have any concerns please contact support@email.com"

#Error Handling Flag 
BAILOUT=false

#Point to the jamfHelper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

if [[ ! -x "$jamfHelper" ]]; then
    REASON="jamfHelper not found."
    BAILOUT=true
fi

if [[ -z "$LOGO" ]] || [[ ! -f "$LOGO" ]]; then
	echo "No Logo Found."
fi

if [[ "$BAILOUT" == "true" ]]; then
    echo "[ERROR]: $REASON"
    exit 1
fi

#Create A Jamf Helper Notification Window
USER_CHOICE=$("$jamfHelper" -windowType "$WINDOW_TYPE" -lockHUD -icon "$LOGO" -title "$PROMPT_TITLE" -defaultButton "$DEFAULT_BUTTON" -description "$PROMPT_MESSAGE" -timeout "$TIMEOUT" -button1 "$button1" -button2 "$button2")

if [[ "$USER_CHOICE" == "0" ]]; then
	echo "Rebooting in $DEFER_MINUTES Minutes."
	shutdown -r +$DEFER_MINUTES

elif [[ "$USER_CHOICE" == "2" ]]; then
	echo "Rebooting now!"
	shutdown -r +$RESTART_DELAY
  exit 0
fi