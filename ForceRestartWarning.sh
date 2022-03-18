#!/bin/bash

###
#
#            Name:  ForceRestartWarning.sh
#     Description:  Alerts User of Upcoming restart for compliance issues, 
#					Forces a restart within X defined time
#		  Created By: Caleb Farrell <caleb.farrell@valhallahosting.ca>
#         Created:  2022-03-18
#   Last Modified:  2022-03-18
#         Version:  1.0.0
#
###

#Specify how long until the restart
MINUTES=10

#Define the Logo Path, Will be unpacked from a DMG to this location
LOGO=""
#Title of Notification
PROMPT_TITLE="NOTICE:"
#Body of the Message
PROMPT_MESSAGE="Your Mac will restart in $MINUTES minutes to resolve a compliance issue detected.

Please acknowledge this notice by clicking OK.

If You have any concerns please contact support@email.com"
exec 2>/dev/null

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
"$jamfHelper" -windowType "utility" -icon "$LOGO" -title "$PROMPT_TITLE" -description "$PROMPT_MESSAGE" -button1 "Ok" -defaultButton 1 -startlaunchd &>/dev/null

shutdown -r +$MINUTES
