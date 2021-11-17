#!/bin/bash
# Name: freeDiskSpace.sh
# Created on: November 16, 2021
# Created by: Caleb Farrell<caleb.farrell@introhive.com>
# Description: This simple script is for a Jamf Extention attribute which grabs the data from
# diskutil and extrapolates it to available space then calculates the percentage based on total available

availableSpace=`/usr/sbin/diskutil info / | grep "Container Free Space:" | awk '{print $4}'`
totalSpace=`/usr/sbin/diskutil info / | grep "Total Space:" | awk '{print $4}'`
percentAvailable=`echo "scale=2;$availableSpace/$totalSpace*100" | bc`
intPercentAvailable=`echo ${percentAvailable%\.*}`
echo "<result>$intPercentAvailable</result>"
