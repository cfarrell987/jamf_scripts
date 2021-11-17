#!/bin/bash

# Get the Username of the currently logged user
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

# Get SecureTokenStaus
secureTokenStatus=$(dscl . -read /Users/$loggedInUser AuthenticationAuthority | grep -o SecureToken)

if [[ $secureTokenStatus == SecureToken ]]; then
    echo "<result>Yes</result>"
else
    echo "<result>No</result>"
fi
