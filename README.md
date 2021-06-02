# Internet Connectivity Data Analysis
## Linux, Python, Pandas and Jupyter
When looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing

### Intall python3-venv
`$ sudo apt-get install python3-venv`	// On Ubuntu. Only once  
`# zypper install python3-virtualenv` // On OpenSuse. Only once  

### Create the virtual environment
`$ mkdir directory-name`  
`$ cd directory-name`  
`$ python3 -m venv venv`  
`$ source venv/bin/activate` // Activate venv  
`(venv) $ deactivate` // To deactivate venv  

### Install libraries
`(venv)$ pip install pandas`  
`(venv)$ pip install jupyter`  

### Download Code
`$ wget https://raw.githubusercontent.com/omarcino/pings-data-analysis/main/pingv4.sh`

### Make scripting executable
`$ chmod a+x pingv4.sh`

### Edit file
> Example
>
> host="8.8.8.8"  
> directory="/root/pings"

### Schedule the code to run everytime linux stars
`$ crontab -e`  
> Example OpenSuse Leap 15.1  and Ubuntu 20.04.1 LTS  
> @reboot /pathdirectory/pingv4.sh

### Verify the script is working
Example  
`$ tail 2021-05-31.ipv4-8.8.8.8`

### Start Jupiter Notebook on Linux
`(venv)$ jupyter notebook --no-browser --port=8888 --allow-root`

### Connect Windows Power Shell to Linux Jupyter
`ssh -N -f -L localhost:8888:localhost:8888 root@192.168.0.2`  

