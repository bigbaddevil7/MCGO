# MCGO
A Script To Automate Minecraft Linux Servers

This is a script that was designed to help automate: Backups, Auto-Restart, and Maintence Restarts for my Minecraft Servers. I have decided to make it public in order to hopefully help others with there server management. I am bot responsibe for any issues that may cause server information loss.  

This Script uses and assumes that you have [mcrcon](https://bukkit.org/threads/admin-rcon-mcrcon-remote-connection-client-for-minecraft-servers.70910/) in the same location as the script.

It uses mcrcon to allow a remote connection to be able to run commands like "say", "save-all", "stop". Instead of just killing the process of the server. The nice thing is if you setup the script like I explain [below](https://github.com/bigbaddevil7/MCGO/blob/master/README.md#how-to-use-this-script), then even if the script was to crash or stop, it will not bring down the server(Except if it crashes during the restart phase). 

#Features
##Backups
The script will take the specified world save compress it into a [tar](http://www.howtogeek.com/248780/how-to-compress-and-extract-files-using-the-tar-command-on-linux/) 
It will also maintain a defined number of backups and kick out any old backs once that number has been reached. 

##Auto-Restart
This will check every X amount of times, to make server is still running. If it is not running it will attempt to start the server again. 

## Maintance Restarts
At the specified time it will gracefully shut down the server, save everything, backup the world, and bring the server back up to help keep the server running smooth. 

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
# How To Use This Script
For the best results I would recommend to drop both the MCGO.sh and the mcrcon in the Minecraft directory itself as it allows for easy navigation and if you know how to use linux can cheat on file paths. If you do not wish to do that, then you must have the MCGO.sh and the mcrocn in the same location. This Script currently assumes that mcrcon is in the same directory.

Once that is done make sure your permissions is server properly so that it is executable.
```
chmod +x <FILENAME>
```
You should run the Minecraft server once over on it's own so that you can get the RCON setup properly and then shut it off. You can keep it running if you keep the same Screen Name. Otherwise there could be two instances running. 

Then either nano or vim into the MCGO.sh so that you can set the Variables needed to get the script running properly and to you specifications. 

After everything has been set then go ahead start a new screen session with a name different then the one that you set in the Script
```
screen -S SCREENNAME
```
This will keep your session from being taken over by the script and can run in the background. Once you are in the session you can run the script. 
```
./MCGO.sh
```
It should say "Script Started" and should take care of the features described. 

# Examples Of Proper Variable Settings

When setting the variables in the script you need to make sure that there are no spaces.

Example:
```
RESTARTHOUR=5  # correct
RESTARTHOUR =5 # will try to run a command 'RESTARTHOUR'
RESTARTHOUR= 5 # will try to set the variable to ' ' 
```

# Breakdowns Of The Variables

##BACKUPLOC
```
BACKUPLOC=
```
This is what defines where your backups will be stored. If there is no Directory then one will be made.
Make sure to use the full path to the directory. Again if there isn't one then give the path and directory of where you want the saves to be stored.
```
BACKUPLOC=/path/to/backup
```
##WORLDLOC
```
WORLDLOC=
```
This is where you define the world save or which world that you want to be saved in case there are multiples in the directory. 
Much like the BACKUPLOC you need to use the full path to define where the world is. It helps insure the proper directories are being copied.
```
WORLDLOC=/path/to/world
```

##RESTARTHOUR
```
RESTARTHOUR=
```
In this variable you define what hour you want the server to go down for an automated restart. The appropriate values are 0-23 in military format 0 being midnight, 12 being noon, 23 being 11pm.
```
RESTARTHOUR=0 # Will set the restart hour to Midnight
```

##RESTARTMIN
```
RESTARTMIN=
```
This is just like RESTARTHOUR but for minutes. The appropriate values are 0-59. 
```
RESTARTHOUR=0
RESTARTMIN=0 #Will schedule the restart at Midnight 

RESTARTHOUR=14
RESTARTMIN=30 #Will schedule the restart for 2:30pm
```

##BACKUPTIMER
```
BACKUPTIMER=
```
This is where you specify how often you want there to be a backup in minutes. The Values must be divisble by 2, 5, or 10
```
BACKUPTIMER=30 #Will schedule a backup every 30mins
```

##FAILCHECKTIMER
```
FAILCHECKTIMER=
```
This is where you define how often you want the server to check to see if the server is still live. If it is not live then it will attempt to automatically restart the server. The Values must be divisible by 2, 5, or 10
```
FAILCHECKTIMER=5 #Will check every 5 mins to see if the server is live.
```

##NUMBACKUPS
```
NUMBACKUPS=
```
This is where you define how many backups you want to keep at a certain time. If the number defined is exceeded then it will remove the oldest backup to maintain the proper number of backups.
```
NUMBACKUPS=4 #Will keep 4 back ups, when a 5th one is schedules it will begin removing the oldest backups 1 at a time.
```

##SCREENNAME
```
SCREENNAME=
```
This is for naming the screen session that the Minecraft server is ran off of. This is also where you would have to go if you wanted to see the server console. This is used to have a constant session to check against when seeing if the server is live.
```
SCREENNAME=BESTMC # When the screen is started it will be under the name "BESTMC"
```

##MAXRAM
```
MAXRAM=
```
Sets the maximum amount of ram you want to the server. When you define a value remember to put the 'M' at the end of the value
```
MAXRAM=4096M # Will set the maximum ram to 4G 
```

##MINRAM
```
MINRAM=
```
Acts just like MAXRAM but sets the minimum.
```
MINRAM=1024M # will set the minimum ram to 1G
```

##JARPATH
```
JARPATH=
```
Here you specify where the jar is that you want to be launched. When you set the value leave off the .jar as it is not needed here.
```
JARPATH=/path/to/serverjar
```

##SERVERIP
```
SERVERIP=
```
Here you need to set the server IP. During my testing with mcrcon it seems the Lo addresses (127.0.0.1) can result in weird behavior. So I recommend using the actual IP for the server. 
```
SERVERIP=192.168.0.1
```

##RCONPORT
```
RCONPORT=
```
You will need to specify the rcon port that you are using. By default Minecraft has RCON disabled. Make sure to enable it  in your server.properties and then either set you own RCON port or use the default: 25575
```
RCONPORT=25575 # will use 25575 as the port on the server to run console commands 
```

##RCONPASS
```
RCONPASS=
```
Here you will need to define the RCON password. Again it's not set by default in server.properties so you will need to set it in both places. 
```
RCONPASS=BESTPASSWORDEVER # Will try to use this password to RCON to the server.
```
#POSSIBLE FEATURES
The reason I say possible is because this is designed for my needs and will only be added if it is needed or highly requested.
- [ ] Menu
- [ ] Option to disable features
- [ ] Script allowed to be run in the background without screen
- [ ] Script Arguments 
