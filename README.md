# Internet Connectivity Data Analysis
## Main Idea

We'll analyze the Internet Quality by pinging a host in the Internet
every second 24/7. And also, we'll test the Internet Speed by
using Ookla Speed Test utility.

## Tools

Linux bash scripting, Python, Pandas, Jupyter Notebook,
SpeedTest script and Crontab Tasks


## Pinging a Host in the Internet Every Second 24/7

Download pings.sh utility, make it executable and edit it

    wget https://raw.githubusercontent.com/omarcino/Internet-Connectivity-Data-Analysis/main/pings.sh
    chmod a+x pings.sh
    nano pings.sh

Define to wich host you want to ping
and the directory path where data will be saved
    
    # IPv4 host Ex. 8.8.8.8
    host="8.8.8.8"
    #
    # Directory path where data will be saved
    # Ex. Raspberry pi
    directory="/home/pi/pings/"

Add a Contrab Task 

    crontab -e
    
Execute the script after a reboot

    # Wait 60 seconds before executing the ping script
    # The ping script can have anyname
    @reboot /bin/sleep 60 && /path-to-ping-script/pings.sh

## Test Internet Speed with Ookla utility

Upgrade your system

    # Ex. Ubuntu, Debian and Raspberry pi
    sudo apt-get update
    sudo apt-get upgrade
    sudo reboot
 
 Find out the CPU arquitecture
 
    uname -m
    # Ex. Output Rapberry pi
    # armv7l
    # armv3 to v7 is a 32 bits OS
    # armv8 or aarch64 is a 64 bits OS
    
Ex. downloading and installing ARM 32 bits

    wget https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-armel.tgz
    tar -xvf ookla-speedtest-1.1.1-linux-armel.tgz
    # Execute SpeedTest for the first time and accept license
    ./speedtest
    # Do you accept the license? [type YES to accept]: yes
    # License acceptance recorded. Continuing.

Make sure the csv header is as:

    ./speedtest --format=csv --output-header
    # "server name","server id","latency","jitter","packet loss","download","upload","download bytes","upload bytes","share url","download server count"
    # "Nitel - Atlanta, GA","12189","10.325","0.506","0","11010840","2204719","79219728","13533156","https://www.speedtest.net/result/c/ce874d05-16a2-4c0b-8d55-76027f127cf2","1"

Download speedtest.sh custom utility, make it executable and edit it

    wget https://raw.githubusercontent.com/omarcino/Internet-Connectivity-Data-Analysis/main/speedtest.sh
    chmod a+x speedtest.sh
    nano speedtest.sh

Define the directory path where data will be saved

    # speed test path
    directory="/some-path/"

Add Contrab Tasks
    
    crontab -e

execute the speedtest script according your criteria

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
    
    # On Ubuntu
    $ sudo apt-get install python3-venv
    #
    # On OpenSuse
    # zypper install python3-virtualenv

### Create the virtual environment
    
    $ mkdir directory-name  
    $ cd directory-name  
    $ python3 -m venv venv  
    $ source venv/bin/activate // Activate venv  
    (venv) $ deactivate // To deactivate venv  

### Install libraries
    
    (venv)$ pip install pandas
    (venv)$ pip install jupyter  
    (venv)$ pip install matplotlib  

### Start Jupiter Notebook on Linux
    
    jupyter notebook --no-browser --port=8888 --allow-root
    # You will receive a token value like
    # http://localhost:8888/?token=dfddfd@#23

### Connect Windows Power Shell to Linux Jupyter
    
First option

    ssh -N -f -L localhost:8888:localhost:8888 user@linux-ip-address

Second Option

    ssh -i .\someKey.pem -N -f -L localhost:8888:localhost:8888 user@linux-ip-address

### Open Jupyter Notebook on your browser
    
    http://localhost:8888/  

### Using pings.ipynb and speedtest.ipynb

Download files

    wget https://raw.githubusercontent.com/omarcino/Internet-Connectivity-Data-Analysis/main/pings.ipynb
    wget https://raw.githubusercontent.com/omarcino/Internet-Connectivity-Data-Analysis/main/speedtest.ipynb 

Upload files to Pandas and Jupyter notebook system


### Pings Graph on Pandas and Jupiter Notebook
    ### Import libraries ###
    %matplotlib inline
    import numpy as np
    import matplotlib.pyplot as plt
    import pandas as pd
    import matplotlib.dates as mdates
    from matplotlib.dates import DateFormatter
    from datetime import date, datetime
    #
    # select the original file 
    file_name = '2022-07-29.ipv4-8.8.8.8'
    #
    # Defining the custom header
    header = 'date time size bytes from ip icmp ttl rtt ms\n'
    #
    # day name
    day_name = datetime.strptime(file_name[0:10], "%Y-%m-%d").strftime("%A")
    #
    # Threshold
    threshold = 55
    #
    # Delete first line and add header
    with open(file_name, 'r+') as fp:
        # read an store all lines into list
        lines = fp.readlines()
        # delete first element from list
        lines.pop(0)
        # add header to list
        lines.insert(0, header)
        # move file pointer to the beginning of a file
        fp.seek(0)
        # truncate the file
        fp.truncate()
        # start writing lines
        fp.writelines(lines)
    #   
    ### Import log ping file ###
    # Make sure head is: date time size bytes from ip icmp ttl rtt ms
    pings = pd.read_csv(file_name, sep=' ', engine='python')
    #
    ### Formating datetime and rtt time ###
    pings['DateTime'] = pings.date + ' ' + pings.time.str.rstrip(":")
    pings.DateTime = pings.DateTime.astype('datetime64[ns]')
    pings.rtt = pings.rtt.str.strip("time=")
    #
    # Considering 2000 [ms] as lost packet
    pings.rtt = pings.rtt.fillna(2000)
    pings.rtt = pings.rtt.astype('float')
    #
    ### New df that only have DateTime and rtt ###
    pings_v2 = pings[['DateTime', 'rtt']].copy()
    pings_v2 = pings_v2.set_index(pings_v2.DateTime)
    #
    ### Getting samples every 5 ### minutes
    pings5min = pings_v2.resample('5T').mean()
    #
    ### To zoom-in unccomment the next line ###
    #pings5min = pings5min.loc['2022-02-02 04:30:00':'2022-02-02 05:00:00']
    #
    ### Re numerate index 0, 1, 2, ... ###
    pings5min = pings5min.reset_index(drop=False)
    #
    ### Create figure and plot ### space
    fig, ax = plt.subplots(figsize=(15, 5))
    #
    ### Add x-axis and y-axis ###
    ax.plot(pings5min.DateTime, pings5min.rtt, label=day_name)
    plt.title(file_name, fontdict={'fontsize': 20})
    plt.xlabel('HH:MM')
    plt.ylabel('RTT ms')
    #
    ### Define the date format ###
    date_form = DateFormatter('%H:%M')
    ax.xaxis.set_major_formatter(date_form)
    plt.legend()
    #
    ### Get the graph ###
    plt.axhline(y=threshold, color='r', linestyle='-')
    plt.savefig(file_name + ".png", dpi=300)
    plt.show()


