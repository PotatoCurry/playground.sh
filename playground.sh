#!/bin/bash

# A script to setup a server with fun activities and exercises for learning about Linux
# Usage: Run as root while providing a line-seperated list of colon-delimited usernames and passwords

echo "Starting Linux Playground Setup"

# Check if running as root
if [[ $EUID -ne 0 ]]
    then echo "Error: must run as root"
    exit
fi

# Check if user list provided
if [[ $# -eq 0 ]]
  then echo "Error: userlist argument not supplied"
  exit
fi

# Script introduction
echo "This script will create accounts and install software, it is recommended that you run this on a temporary installation or virtual machine"
echo "Press ENTER to continue"
read

# Create user accounts
while IFS=: read -r username password; do
    echo "Adding $username"
    useradd $username --create-home --skel template --shell /bin/bash
done < $1
chpasswd < $1

# Setup Apache with user directories
apt install --yes apache2
a2enmod userdir
sed -i s/public_html/web/ /etc/apache2/mods-available/userdir.conf
systemctl restart apache2

# Install other programs
apt install --yes alpine finger fortune-mod mailutils tldr tree w3m w3m-img

echo "Script finished"
