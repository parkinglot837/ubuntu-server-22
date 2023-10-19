#!/bin/bash
# changenet.sh
# Change NetPlan file and IP address.
echo "Enter New IP (format X.X.X.X/24) : "
read mynewip

sudo cp /home/ubadmin/initialize/netcfg.000 /home/ubadmin/initialize/00-installer-config.yaml
sudo sed -i "7i \ \ \ \ \ \ \ \ - ${mynewip}" /home/ubadmin/initialize/00-installer-config.yaml
echo " "
echo "This is the new configuration."
echo " "
cat /home/ubadmin/initialize/00-installer-config.yaml
echo " ----------------------------------------"
echo " "
echo "Commit the change?"
echo "    Press 'Y' to proceed if the hostname is correct."
echo "         OR Any other key to stop the initialization…"
read -r -s -n 1 -p " :" key

if [ "$key" = 'Y' ]; then

	echo "Set the IP for NetPlan to:  ${mynewip}"
	echo " "
	echo "Backup old netplan yaml file"
	sudo mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yold
        echo "Copy new netplan yaml file"
	sudo mv /home/ubadmin/initialize/00-installer-config.yaml /etc/netplan/

    # echo [$key] is empty when SPACE is pressed # uncomment to trace
else
    echo 'Exiting script'
    # Anything else pressed, do whatever else.
    # echo [$key] not empty
    exit
fi
echo Script End
echo Reboot to have changes take effect
