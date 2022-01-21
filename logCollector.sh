#!/bin/bash
# Name: logCollector.sh
# Created on: January 18, 2021
# Created by: Caleb Farrell<caleb.farrell@introhive.com>
# Description: When logs are needed for auditing, toubleshooting or any other purpose this script can be ran
# to collect system logs, application logs, and jamf logs, compress them into a tarball and send them to the IT team
#

# Variables
deviceSerial=$( system_profiler SPHardwareDataType | grep Serial | awk '{print $NF}' )

currentUser=$( echo $SUDO_USER )
currentDate=$( date '+%d-%m-%Y_%H:%M:%S' )

osMaj=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}')
osMin=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $2}')

homeDir="/Users/$currentUser"
stagingDir="$homeDir/staging"
tmpLogsDir="/tmp/"
varLogsDir="/private/var/log"
diagReportsDir="/Library/Logs/DiagnosticReports"

if ! [ $(id -u) = 0 ]; then
	echo "Please run this script with sudo."
	exit 1
fi

echo $currentUser Date:$currentDate
echo Device Info: 
echo Serial No:$deviceSerial
echo OS Version: $osMaj.$osMin

mkdir $stagingDir

# Copy Temp logs, very rarely needed however it could be helpful if we are troubleshooting a socket or application issue
{
  cd $tmpLogsDir &&
  find . -name '*[\[?*
]*' -prune -o \
               \( -type b -o -type c -o -type p -o -type s \) -print |
  sed 's/^\.//'
} | rsync -a --exclude-from=- $tmpLogsDir $stagingDir

# Copy Var Logs, Most useful as it contains system logs, Jamf logs, wifi logs etc.
cp -r $varLogsDir $stagingDir

# Copy Diag Reports 
cp -r $diagReportsDir $stagingDir

# Compress all logs into gzip and move to user's desktop (temporary until upload solution is approved)
cd $stagingDir
tar -zcvf $homeDir/Desktop/compressedLogs.tar.gz ./*

#cleanup
rm -r -f $stagingDir
