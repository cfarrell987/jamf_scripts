#!/bin/bash
# Name: batteryCycleCountM1.sh
# Created on: Febuary 4, 2021
# Created by: Caleb Farrell<caleb.farrell@introhive.com>
# Description: Since Apple Silicon change the system profiler output,
# The Extention attribute to collect this doesn't work anymore. This is an updated version

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

 echo "<result>$(system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}')</result>"
