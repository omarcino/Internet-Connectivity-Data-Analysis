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

### Upload files to Pandas and Jupyter notebook system
