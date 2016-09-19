#!/bin/bash
#Program: MCGO
#Verson 1.2
#Author: Bigbaddevil7
#An automation script for Minecraft Linux Servers. 

# When setting the variables do not use spaces. Ex. RESTARTHOUR=5

BACKUPLOC=			#Specify the full path to the Backup Location
WORLDLOC=			#Specify the full path to the world save location

RESTARTHOUR=		#Set the Hour you want the server to restart 0-23 (0 = Midnight)
RESTARTMIN=			#Set the Minute you want the server to restart 0-59
BACKUPTIMER=		#Set how often you want the world to backup must be divisble by 10
FAILCHECKTIMER=		#Set how often the server checks to see if it is still up must be divisble by 2

NUMBACKUPS=			#Set the number of backups you want to keep, if the number is exceeded the oldest will be removed

SCREENNAME=			#Set the name of the screen session you want to server to be launched in				

MAXRAM=				#Set the Maximum amount of RAM allocated. Ex. 4096M (Do Not forget the M!)
MINRAM=				#Set the Minimum amount of RAM Allocaled. EX. 1028M (Do Not forget the M!)
JARPATH=			#Specify the path to the server jar that is being launched (ignore the .jar at the end)

SERVERIP=			#Specify the Server IP (127.0.0.1) does not seem to work well with mcrcon =(
RCONPORT=			#Specify the RCON Port. The port is set in server.properties (Default: 25575)
RCONPASS=			#Specify the RCON Pass. The password is set in server.properties


function startServer () {
	echo "Started Server"
	screen -dmS $SCREENNAME java -Xmx$MAXRAM -Xms$MINRAM -jar $JARPATH.jar nogui
}

function backUp () {
	fileExists
	local MIN=$(getMin)
	local MINMOD=$(( MIN % BACKUPTIMER))
	if [[ $MINMOD -eq 0 ]]; then
		echo "Preparing to backup the world save..."
		if [[ $(getNumBackups) -lt $NUMBACKUPS ]]; then
			echo "Backing up and compressing the save file to $BACKUPLOC, time will vary depending on world size"
			./mcrcon -H $SERVERIP -P $RCONPORT -p $RCONPASS "say Backing up the world save!"
			./mcrcon -H $SERVERIP -P $RCONPORT -p $RCONPASS save-all
			tar -czf $BACKUPLOC/backup_$(getDate).tar.gz $WORLDLOC
			echo "Backed up the world!"
		else
			./mcrcon -H $SERVERIP -P $RCONPORT -p $RCONPASS "say Backing up the world save!"
			./mcrcon -H $SERVERIP -P $RCONPORT -p $RCONPASS save-all
			echo "Number of backups exceeded! Removing Oldest Backup, otherwise increase the amount backs allowed"			
			IFS= read -r -d $'\0' line < <(find $BACKUPLOC -maxdepth 1 -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
			file="${line#* }"
			rm -rf "$file"
			echo "Removed Oldest backup to make room."
			tar -czf $BACKUPLOC/backup_$(getDate).tar.gz $WORLDLOC
			echo "Backed up the world!"
		fi	
	fi
}

function shutDown () {
	echo "Attempting to shut down the server..."
	./mcrcon -H $SERVERIP -P $RCONPORT -p $RCONPASS stop 
}

function isServerUp () {
	local MIN=$(getMin)
	local MINMOD=$((MIN % FAILCHECKTIMER))
	if [[ $MINMOD -eq '0' ]]; then
		echo "Checking to see if server is still live..."
		if  screen -list | grep $SCREENNAME ; then
			echo "Server is Alive and well!"
		else
			echo "Server is down... Attempting to start server..."
			startServer
		fi
	fi
}

function isRestartReady () {
	local HOUROFFSET=
	local MIN=

	
	if [[ $RESTARTMIN -lt 10 ]]; then
		if [[ $RESTARTHOUR -eq 0 ]]; then
			HOUROFFSET=23
		else
			HOUROFFSET=$((RESTARTHOUR - 1))
		fi
		local MINOFFSET=$((10 - $RESTARTMIN))			
		MIN=$((60 - MINOFFSET))

	elif [[ $RESTARMIN -eq 10 ]]; then
		HOUROFFSET=$RESTARTHOUR
		MIN=0

	else
		HOUROFFSET=$RESTARTHOUR
		echo "ELSE"
		MIN=$((RESTARTMIN - 10))
	fi
	
	if [[ $(getHour) -eq $HOUROFFSET ]]; then
		if [[ $(getMin) -eq $MIN ]]; then
			echo "Warning the players for the server restart."
			./mcrcon -H $SERVERIP -P $RCONPORT -p $RCONPASS "say The Server is restarting in 10 minutes!"
		fi
        fi
		        
	if [[ $(getHour) -eq $RESTARTHOUR  ]]; then
		if [[ $(getMin) -eq $RESTARTMIN  ]]; then 
			echo "Announced Server Restart"
			./mcrcon -H $SERVERIP -P $RCONPORT -p $RCONPASS "say Server Restarting in 10 seconds!"
			sleep 10
			shutDown
			backUp
			sleep 30
			startServer
		fi
	fi
}

function fileExists() {
	if [[ -d $BACKUPLOC ]]; then
		if [[ -w $BACKUPLOC ]]; then 
			if [[  -O $BACKUPLOC  ]]; then
				:
			else
				echo "Ownership not set properly for the backup folder!"
				echo "Please make sure you are either the Owner or in the correct group!"
				exit 1
			fi
		else
			echo "Permissions are not set properly for the backupfolder!"
			echo "Make sure you have proper WRITE permissions to the folder!"
			exit 1
		fi
	else
		echo "$BACKUPLOC Doesn't Exist, Creating it..."
		mkdir $BACKUPLOC
	fi
}

function getMin () {
	local MIN=$(date +"%M")
	echo $MIN|sed 's/^0*//'
}

function getHour () {
	local HOUR=$(date +"%H")
	echo $HOUR|sed 's/^0*//'
}

function getDate () {
	date +"%m-%d-%Y-%T"
}

function getNumBackups () {
	find $BACKUPLOC -maxdepth 1 -type f -print| wc -l
}


echo "Script Started!"
while :
do
	isRestartReady
	backUp
	isServerUp
sleep 60
done &

