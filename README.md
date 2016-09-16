# MCGO
A Script To Automate Minecraft Linux Servers

This is a script that is designed to help automate: Backups, Auto-Restart, and Maintence Restarts.

This Script uses and assumes that you have [mcrcon](https://bukkit.org/threads/admin-rcon-mcrcon-remote-connection-client-for-minecraft-servers.70910/) in the same location as the script.

It uses mcrcon to allow a remote connection to be able to run commands like "say", "save-all", "stop". Instead of just killing the process of the server. 

When you first install the script there will need to be variables assigned in order to get the script to run. 

These are the variables that need to be set. 
```
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
```

## Examples Of Proper Variable Settings

When setting the variables in the script you need to make sure that there are no spaces.

Example:
```
RESTARTHOUR=5  # correct
RESTARTHOUR =5 # will try to run a command 'RESTARTHOUR'
RESTARTHOUR= 5 # will try to set the variable to ' ' 
```

## Breakdowns Of The Variables

######BACKUPLOC
```
BACKUPLOC=
```
This is what defines where your backups will be stored. If there is no Directory then one will be made.
Make sure to use the full path to the directory. Again if there isn't one then give the path and directory of where you want the saves to be stored.
```
BACKUPLOC=/path/to/backup
```
######WORLDLOC
```
WORLDLOC=
```
This is where you define the world save or which world that you want to be saved in case there are multiples in the directory. 
Much like the BACKUPLOC you need to use the full path to define where the world is. It helps insure the proper directories are being copied.
```
WORLDLOC=/path/to/world
```

######RESTARTHOUR
```
RESTARTHOUR=
```
In this variable you define what hour you want the server to go down for an automated restart. The appropriate values are 0-23 in military format 0 being midnight, 12 being noon, 23 being 11pm.
```
RESTARTHOUR=0 # Will set the restart hour to Midnight
```
