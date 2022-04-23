#!/bin/bash
# By omardata.com
# 2022-04-16
#-----------------------------------
# Check Internet connection every second
# Add the following line to contrab
#
#@reboot /bin/sleep 60 && /home/pi/pings/ping_file_name.sh
#-----------------------------------
# IPv4 host
host="8.8.8.8"
#
# Directory path where data will be saved
directory="/home/pi/pings/"
#
# Execute ping every second (Script Heart)
ping 8.8.8.8 | while read value;
do
# Round Trip Time
rtt=$(echo $value | grep -o time=.* | grep -o '[0-9]..[0-9].')
#
# Sequence
seq=$(echo $value | grep -o 'seq=[0-9].' | grep -o '[0-9].')
#
# Day and Time
day=$(date '+%Y-%m-%d')
time=$(date '+%H:%M:%S')
#
#
if [ $seq ]
then
 #file header is: SEQ, DATE, RTT
 echo "$seq, $day $time, $rtt" >> $directory/$host.$day.txt
fi
done


  
