#!/bin/sh
# MRTG configuration and index maker
# Created by Winter Faulk 2013
# http://faulk.me
# http://github.com/faulker/mrtg-maker

# Create a file with one device per line, include the SNMP community (exp. public@192.168.1.1)
# and change the variable DEVLIST to point to it.
DEVLIST="device.list"

CFG="/etc/mrtg.cfg" # Path to MRTG config file.
BIN="/usr/bin" # Path to bin that is holding cfgmaker.
WEBUSER="www-data"
WWWPATH="/var/www/mrtg"

env LANG=C
clear

# Adds all the devices from the $DEVLIST to a variable
NETWORK="$(
	while read LINE
	do
		echo -n ${LINE} | tr "\r" " "
	done < $DEVLIST)"

echo "Creating MRTG configuration file..."

$BIN/cfgmaker\
	--no-down\
	--ifref=nr\
	--ifdesc=descr\
	--global "WorkDir: ${WWWPATH}"\
	--global "options[_]: bits"\
	--subdirs=HOSTNAME_SNMPNAME\
	$NETWORK > $CFG

echo "Done creating configuration file."
echo
echo "Creates the MRTG index.html file..."

$BIN/indexmaker\
	--columns=2\
	--show=day\
	$CFG > ${WWWPATH}/index.html

echo "Done creating index.html file"

chown -R $WEBUSER:$WEBUSER $WWWPATH

echo
echo "-----------------------"
echo "Done!"
