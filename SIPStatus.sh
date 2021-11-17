#!/bin/bash
#
#
#Written by Caleb Farrell for use within Introhive Services Inc.
#
#This Script checks that System Integrity Protection [SIP] is enabled

#We need to ensure the version is atleast 10.11 as that is the earliest
#that supports SIP
os_ver=$(sw_vers -productVersion)
os_releaseVer=$(echo ${os_ver} | cut -d \. -f 2)

if [ $os_releaseVer -lt 11 ]; then
result="N/A"
exit 0
fi

# Here sets sip_stat equal to the Status output of the SIP command
sip_stat=$(csrutil status)

#Here sets our result var to enabled or disabled depending on the sip_stat
if [[ ${sip_stat} == *"enabled"* ]]; then
  result="Enabled"
else
  result="Disabled"
fi

#Here we set our HTML result to our result var
echo "<result>${result}</result>"
