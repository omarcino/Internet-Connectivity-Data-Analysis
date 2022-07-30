#!/bin/bash
# By omardata.com
# 2022-07-23 - Bug fixed: No records when lost connections
# 2022-07-09 - v10.1 Host IP Address into a $host variable
# 2022-04-16 - v10.0
#-----------------------------------
# Check Internet connection every second
# Add the following line to contrab
#
#@reboot /bin/sleep 60 && /home/pi/pings/ping_file_name.sh
#-----------------------------------
# IPv4 host Ex. 8.8.8.8
host="8.8.8.8"
#
# Directory path where data will be saved
# Ex. Raspberry pi
directory="/home/pi/pings/"
#
# Execute ping every second (Script Heart)
# -O option will keep showing failure results for logging
ping -O $host | while read value;
do
# Day and Time
day=$(date '+%Y-%m-%d')
time=$(date '+%H:%M:%S')
echo "$day $time: $value" >> $directory/$day\_$host.txt
### If you want to reduce file size
### Comment the last line and uncomment the lines below
### You will only have RTT and SEQ values
### This option is good to reduce file size, but
### It is not good for debugging
## Round Trip Time
#rtt=$(echo $value | egrep -o time=.* | egrep -o '[0-9]+.[0-9]+')
##
## Sequence
#seq=$(echo $value | egrep -o 'seq=[0-9]+' | egrep -o '[0-9]+')
##
#
#
#if [ $seq ]
#then
# #file header is: SEQ, DATE, RTT
# echo "$seq, $day $time, $rtt" >> $directory/$host.$day.txt
#fi
done


  
