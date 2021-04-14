#!/bin/bash
# Tomas Sikora, 2021
# Accolade Ubuntu semi-automated build
# Tested on 20.04.2
# Version 1

set -e

# check for root privilege
if [ "$(id -u)" != "0" ]; then
   echo " This script must be run as root" 1>&2
   echo
   exit 1
fi

echo "The build starts"

#Update and Upgrade
apt-get update && sudo apt-get upgrade -y

#Firmware update
sudo fwupdtool refresh
sudo fwupdmgr get-updates -y
sudo fwupdmgr update -y

#Add PPAs
#sudo add-apt repository ppa:

#Enable firewall
sudo ufw enable

#Install apps from repository
sudo apt install network-manager-openconnect-gnome landscape-client libpam-pwquality -y

#Security packages:
#Download Falcon install file
git clone https://github.com/sikoratomas/falcon.git /tmp/falcon

#Install Falcon
sudo dpkg -i  /tmp/falcon/falcon-sensor.deb

#Add Accolade customerID to Falcon
sudo /opt/CrowdStrike/falconctl -s --cid=4CF5242A1D3A4FF3A72FFB4E3BBB873D-FF

#Start Falcon
sudo systemctl start falcon-sensor

#Delete Falcon's install file
sudo rm -rf /tmp/falcon

#Download Qualys install file
git clone https://github.com/sikoratomas/qualys.git /tmp/qualys

#Install Qualys
sudo dpkg --install /tmp/qualys/QualysCloudAgent.deb

#Add Accolade customerID to Qualys
sudo /usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=6fd5a081-1f9f-41a8-a42f-292b827e9ca0 CustomerId=b8522f97-03d5-70b5-8076-fd917ee0ccfa

#Delete Qualys install file
sudo rm -rf /tmp/qualys

#Configure VPN


#Download apps that need DEB package
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.8.0-amd64.deb
wget https://zoom.us/client/latest/zoom_amd64.deb

#Install DEB packages
#sudo dpkg -i *.deb
sudo apt install ./*.deb

#Remove DEB packages
rm *deb


#Create user account
#has to be first.last format
sudo adduser username --force-badname

#Add user to sudo group
sudo usermod -aG sudo username

#Enforce password complexity:
#Install libpam-pwquality package
#sudo apt-get install libpam-pwquality

#Backup common-password file
#sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.original

#Add parameters to common-password
#password        requisite                       pam_pwquality.so retry=5 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 reject_username enforce_for_root

#Configure password rotation in /etc/login.defs
#PASS_MAX_DAYS 90
#PASS_MIN_DAYS 0
#PASS_WARN_AGE 14


# turn off welcome sound
sudo -u gdm gconftool-2 --set /desktop/gnome/sound/event_sounds --type bool false

# enabling cpufreq-applet CPU frequency scaling #
sudo chmod u+s /usr/bin/cpufreq-selector

#Change value of swapiness
sysctl vm.swappiness=10
#this needs a reboot to take effect

# finish
echo " ALL DONE; rebooting ... "
reboot
© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
