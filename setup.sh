#!/bin/bash
# SCRIPT:
# REV: Version 1.0
# PLATFORM: Linux
# AUTHOR: psibot
#
# PURPOSE: Catsploit New Installer
#
##########################################################
########### DEFINE FILES AND VARIABLES HERE ##############
##########################################################

##########################################################
################ BEGINNING OF MAIN #######################
##########################################################

### Functions ###
if [[ $EUID -ne 0 ]]; then
    echo -e  "\e[1mMust be SUDO to run  this script!\e[0m"
    echo -e  "\e[1mMust be SUDO to run  this script!\e[0m"
    echo -e  "\e[1mMust be SUDO to run  this script!\e[0m"
    exit
fi


function pause(){ # Pause enter
        local message="$@"
        [ -z $message ] && message="Press [Enter] key to continue...CTrl + X exit "
        read -p "$message" readEnterKey
}

clear 
echo 
echo -e "\e[40;38;5;82m [+] \e[30;48;5;82m CATSPLOIT v2 Istaller    \e[0m"
echo
echo -e "\e[32m[*]\e[0m \e[1m Installing Packages  \e[0m"
echo 
echo -e "IT's \e[5mRUNNING IN SILENT MODE !!! \e[25mErorrs will show."
echo 
echo 
sudo apt-get -qq  update && sudo apt full-upgrade -y && sudo apt-get -qq autoremove -y && sudo apt-get -qq upgrade -y 
sudo apt-get -qq install -y python3-gvm python3-numpy python3-pandas python3-psycopg2 python3-pymetasploit3 python3-rich python3-ruamel.yaml gvm openvas greenbone-security-assistant postgresql 

sudo pip3 install pgmpy pyperplan  > /dev/null 2>&1
sudo pip3 install pg8000==1.30.5  > /dev/null 2>&1
echo
echo -e "\e[32m[*]\e[0m \e[1m System Packages Installed \e[0m"
echo 
pause 
echo 
echo -e "\e[32m[*]\e[0m \e[1m Starting Postgresql Service  \e[0m"
echo 
sudo systemctl enable  postgresql
sudo systemctl start  postgresql
sudo service postgresql status
echo
echo -e "\e[32m[*]\e[0m \e[1m  Postgresql Service Should be GREEN   \e[0m" 
echo 
pause
echo 
clear
echo
echo -e "\e[32m[*]\e[0m \e[1m Setup Postgres CATSDB Database   \e[0m"
echo 
sudo su postgres -c "psql -U postgres << EOF
  alter user postgres with password 'password';
  create database catsdb;
EOF"
echo 
echo -e "\e[32m[*]\e[0m \e[1m Creating Tables for catsdb  \e[0m"
echo 
pause
sudo su postgres -c "psql -U postgres catsdb < db/catsploit.sql"
echo 
echo -e "\e[32m[*]\e[0m \e[1m THE SCRIPT SHOULD COMPLETE FOR THE NEXT STEP   \e[0m"
echo 
pause
echo 
clear
echo -e "\e[32m[*]\e[0m \e[1m Lets Check The DATABASE State - You should see a db called catsdb  \e[0m"
echo
sudo su postgres -c "psql -U postgres << EOF
  SELECT datname FROM pg_database;
EOF"
echo 
pause 
echo 
echo -e "\e[32m[*]\e[0m \e[1m Greenbone Openvas setup  \e[0m"
echo 
sudo gvm-setup
echo 
pause 
echo
echo -e "\e[32m[*]\e[0m \e[1m Lets setup latest feeds for Greenbone - This will TAKE SOME TIME  \e[0m"
echo
pause
echo
sudo runuser -u _gvm -- greenbone-nvt-sync
sleep 5
sudo -u _gvm greenbone-feed-sync --type GVMD_DATA
sleep 5
sudo -u _gvm greenbone-feed-sync --type SCAP
sleep 5
sudo -u _gvm greenbone-feed-sync --type CERT
sleep 5
sudo openvas --update-vt-info
echo 
echo -e "\e[32m[*]\e[0m \e[1m Greenbone feeds  Updated !!! \e[0m"
echo
pause
echo 
clear
echo 
echo -e "\e[32m[*]\e[0m \e[1m Lets check Greenbone Status \e[0m"
echo
pause
echo 
sudo gvm-check-setup
echo 
sudo -u _gvm gvmd --user=admin --new-password=password
echo 
echo -e "\e[32m[*]\e[0m \e[1m Greenbone Status Checked \e[0m"
echo
sleep 5
echo -e "\e[40;38;5;82m [exit] \e[30;48;5;82m THANK YOU FOR USING ME !!!  \e[0m"
echo -e "\e[40;38;5;82m [exit] \e[30;48;5;82m Have a nice day! \e[0m"
sleep 2
####################################################
################ END OF MAIN #######################
####################################################
exit 0
# End of script


