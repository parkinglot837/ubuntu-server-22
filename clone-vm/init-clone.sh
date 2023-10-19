#!/bin/bash
# filename: init-clone.sh

# Set Timezone to: America/New_York

echo "Timezone will be set to: America/New_York"
sudo timedatectl set-timezone America/New_York

# Remove and reset the machine-id
oldmachid=$(sudo cat /etc/machine-id)

sudo rm -f /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo dbus-uuidgen --ensure=/etc/machine-id

newmachid=$(sudo cat /etc/machine-id)

echo "Old Machine-ID: ${oldmachid}"
echo "New Machine-ID: ${newmachid}"

# Remove and regenerate the ssh host keys
echo " "
echo "Generate new SSH keys"
sudo rm /etc/ssh/ssh_host*
sudo rm /etc/ssh/ssh_host*.pub
sudo dpkg-reconfigure openssh-server

echo " "
echo "-----------------------------------"
ls - /etc/ssh/ | grep ssh_host
echo "-----------------------------------"
echo " "
echo " "
# Changes hostname
echo Enter New Hostname:
read myhstnm
echo " "
echo "The new hostname will be: ${myhstnm}"
echo " "
echo "Press 'C' to proceed if the hostname is correct."
echo "OR Any other key to stop the initialization…"
read -r -s -n 1 -p " :" key

if [ "$key" = 'C' ]; then
	echo "Set the hostname: to ${myhstnm}"
	sudo hostnamectl set-hostname $myhstnm

	# updates /etc/hosts file with hostname
	echo 'Update /etc/hosts file with new hostname'
	sudo sed -i '2d' /etc/hosts
	sudo sed -i "2i 127.0.1.1 $myhstnm" /etc/hosts


    # echo [$key] is empty when SPACE is pressed # uncomment to trace
else
    echo 'Exiting script'
    # Anything else pressed, do whatever else.
    # echo [$key] not empty
    exit
fi

source /home/ubadmin/initialize/changenet.sh
