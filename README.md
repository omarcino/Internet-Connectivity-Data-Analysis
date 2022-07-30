# Internet Connectivity Data Analysis
## Main Idea

We'll analyze the Internet Quality by pinging a host in the Internet
every second 24/7. And also, we'll test the Internet Speed by
using Ookla Speed Test utility.

## Tools

Linux bash scripting, Python, Pandas, Jupyter Notebook,
SpeedTest script and Crontab Tasks


## Pinging a Host in the Internet Every Second 24/7

Download pings.sh utility and make it executable

    $ wget https://github.com/omarcino/pings-data-analysis/blob/main/pings.sh
    $ chmod a+x pings.sh

Define to wich host you want to ping
and the directory path where data will be saved

    $ nano pings.sh
    
    # IPv4 host Ex. 8.8.8.8
    host="8.8.8.8"
    #
    # Directory path where data will be saved
    # Ex. Raspberry pi
    directory="/home/pi/pings/"

Add a Contrab Task to execute the script after a reboot

    $ crontab -e
    
    # Wait 60 seconds before executing the ping script
    # The ping script can have anyname
    @reboot /bin/sleep 60 && /path-to-ping-script/pings.sh

## Test Internet Speed with Ookla utility

Download and Install Ookla speed-test cli

    # Make sure to upgrade your system
    # Ex. Ubuntu, Debian and Raspberry pi
    $ sudo apt-get update
    $ sudo apt-get upgrade
    $ sudo reboot
    #
    # Find out the CPU arquitecture
    $ name -m
    # Ex. Output Rapberry pi
    armv7l
    # armv3 to v7 is a 32 bits OS
    # armv8 or aarch64 is a 64 bits OS
    #
    # Ex. downloading and installing ARM 32 bits
    $ wget https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-armel.tgz
    $ tar -xvf ookla-speedtest-1.1.1-linux-armel.tgz
    # Execute SpeedTest for the first time and accept license
    ./speedtest
    Do you accept the license? [type YES to accept]: yes
    License acceptance recorded. Continuing.

Make sure the csv header is as:
    pi@raspberrypi:~/SpeedTest $ ./speedtest --format=csv --output-header
    "server name","server id","latency","jitter","packet loss","download","upload","download bytes","upload bytes","share url","download server count"
    "Nitel - Atlanta, GA","12189","10.325","0.506","0","11010840","2204719","79219728","13533156","https://www.speedtest.net/result/c/ce874d05-16a2-4c0b-8d55-76027f127cf2","1"

Download speedtest.sh custom utility and make it executable

    $ wget https://github.com/omarcino/pings-data-analysis/blob/main/speedtest.sh
    $ chmod a+x speedtest.sh

Define the directory path where data will be saved

    $ nano speedtest.sh
    
    # speed test path
    directory="/home/pi/SpeedTest/"

Add Contrab Tasks to execute the speedtest script
according your criteria
    
    $ crontab -e

    # Some examples
    #
    # At every 15th minutes
    */15 * * * * /path-to-speedtest-script/speedtest.sh
    #
    # At every 15th minutes from 00:00 to 06:00
    */15 0-6 * * * /path-to-speedtest-script/speedtest.sh
    #
    # Ookla speedtest utility takes around 15 seconds
    # A heavy test every minute
    * * * * * /path-to-speedtest-script/speedtest.sh
    #
    # A heavy test every two minutes
    */2 * * * * /path-to-speedtest-script/speedtest.sh

## Setting Pandas and Jupiter notebook environment

### Intall python3-venv
`$ sudo apt-get install python3-venv`	// On Ubuntu  
`# zypper install python3-virtualenv` // On OpenSuse  

### Create the virtual environment
`$ mkdir directory-name`  
`$ cd directory-name`  
`$ python3 -m venv venv`  
`$ source venv/bin/activate` // Activate venv  
`(venv) $ deactivate` // To deactivate venv  

### Install libraries
`(venv)$ pip install pandas`  
`(venv)$ pip install jupyter`  
`(venv)$ pip install matplotlib`  

### Start Jupiter Notebook on Linux
`(venv)$ jupyter notebook --no-browser --port=8888 --allow-root`  // You will receive a token value  
> Example  
> http://localhost:8888/?token=dfddfd@#23

### Connect Windows Power Shell to Linux Jupyter
`ssh -N -f -L localhost:8888:localhost:8888 linux-user00@linux-ip-address`

### Open Jupyter Notebook on your browser
http://localhost:8888/?token=tokeyGivenByLinuxServer  

### This will be the code 
***Import libraries***  
`%matplotlib inline`  
`import numpy as np`  
`import matplotlib.pyplot as plt`  
`import pandas as pd`  
`import matplotlib.dates as mdates`  
`from matplotlib.dates import DateFormatter`  
`from datetime import date`  

***Import log ping file***  
Make sure head is: date time size bytes from ip icmp ttl rtt ms  
`pings = pd.read_csv("ping-log-file-name", sep=' ', engine='python')`  

***Formating datetime and rtt time***  
`pings['DateTime'] = pings.date + ' ' + pings.time.str.rstrip(":")`  
`pings.DateTime = pings.DateTime.astype('datetime64[ns]')`  
`pings.rtt = pings.rtt.str.strip("time=")`  
`pings.rtt = pings.rtt.fillna(2000)`  
`pings.rtt = pings.rtt.astype('float')`  

***New df that only have DateTime and rtt***  
`pings_v2 = pings[['DateTime', 'rtt']].copy()`  
`pings_v2 = pings_v2.set_index(pings_v2.DateTime)`  

***Getting samples every 5 minutes***  
`pings5min = pings_v2.resample('5T').mean()`  

***To zoom-in unccomment the next line***  
`#pings5min = pings5min.loc['2021-05-30 17:00:00':'2021-05-30 19:00:00']`  

***Re numerate index 0, 1, 2, ...***  
`pings5min = pings5min.reset_index(drop=False)`  

***Create figure and plot space***  
`fig, ax = plt.subplots(figsize=(15, 5))`  

***Add x-axis and y-axis***  
`ax.plot(pings5min.DateTime, pings5min.rtt, label='8.8.8.8')`  
`plt.title('Pings - 5/30/21', fontdict={'fontsize': 20})`  
`plt.xlabel('HH:MM')`  
`plt.ylabel('ms')`  

***Define the date format***  
`date_form = DateFormatter('%H:%M')`  
`ax.xaxis.set_major_formatter(date_form)`  
`plt.legend()`  

***To save graph. Uncomment the next line***  
`#plt.savefig('SouthClayton', dpi=300)`  

`plt.show()`


