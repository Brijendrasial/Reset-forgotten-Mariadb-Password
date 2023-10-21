#!/bin/bash

# Reset Forgotten Mysql Root Password in Rescumode for CentMinMod Installer [CMM]

# Scripted by Brijendra Sial @ Bullten Web Hosting Solutions [https://www.bullten.com]

RED='\033[01;31m'
RESET='\033[0m'
GREEN='\033[01;32m'
YELLOW='\e[93m'
WHITE='\e[97m'
BLINK='\e[5m'


#set -e
#set -x

echo " "
echo -e "$GREEN*******************************************************************************$RESET"
echo " "
echo -e $YELLOW"Reset Forgotten Mysql Root Password in Rescumode for CentMinMod Installer [CMM]$RESET"
echo " "
echo -e $YELLOW"By Brijendra Sial @ Bullten Web Hosting Solutions [https://www.bullten.com]"$RESET
echo " "
echo -e $YELLOW"Web Hosting Company Specialized in Providing Managed VPS and Dedicated Server's"$RESET
echo " "
echo -e "$GREEN*******************************************************************************$RESET"

echo " "

echo -e $GREEN"Generating MariaDB Passowrd"$RESET
echo " "

MYSQL_PASSWORD=`openssl rand -hex 12`

echo " "

echo -e $GREEN"Stopping MariaDB Now"$RESET
echo " "
systemctl stop mariadb

echo " "

echo -e $GREEN"Killing All MariaDB Processes"$RESET
echo " "

echo " "

echo -e $GREEN"Starting MariaDB in Safemode"$RESET
echo " "
mysqld_safe --skip-grant-tables > /dev/null 2>&1 &

echo " "

echo -e $GREEN"Waiting for 10 Seconds for MariaDB to Start"$RESET
echo " "
sleep 10

echo " "

echo -e $GREEN"Setting New Password for MariaDB"$RESET
echo " "
mysql -u root -B -N -e "FLUSH PRIVILEGES;ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';FLUSH PRIVILEGES;"

echo " "

echo -e $GREEN"Killing All MariaDB Processes"$RESET
echo " "

PID=`ps -eaf | grep mysql | grep -v grep | awk '{print $2}'`
if [[ "" !=  "$PID" ]]; then
   kill -9 $PID
   wait $PID 2>/dev/null
fi

echo " "

echo -e $GREEN"Restarting MariaDB Now"$RESET
echo " "
systemctl start mariadb

echo -e $YELLOW"Your New Password is ${MYSQL_PASSWORD}"$RESET
echo " "

echo -e $YELLOW"Changing Password in /root/.my.cnf File"$RESET
echo " "
sed -i "/password=*/c password=${MYSQL_PASSWORD}" /root/.my.cnf

echo " "
