#!/bin/bash
# By omardata.com
# 2022-07-29 version 1.0
#
# speed test path
directory="/home/pi/SpeedTest/"
cd $directory
# Test Internet bandwidth. About 15 seconds
speedtest=$(./speedtest --format=csv)
#
# Day and Time
day=$(date '+%Y-%m-%d')
time=$(date '+%H:%M:%S')
#
# Save data
echo \"$day $time\",$speedtest  >> $directory/speedtest.csv

