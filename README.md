<img src="/home/amir/Documents/rcss2d_game_scripts/Pics/KN2C_Logo.jpg" alt="KN2C_Logo" style="zoom: 67%;" />

## KN2C Game Tools

Game tools is developed by **KN2C robotic team** for running multiple games between different teams. it can be used for testing or hosting competitions.

Game tools is  developed in a way so you can use them with ease without any need for knowledge of shell commands and shell scripting. 

---

### Features:

1. Tagging each game (see Instructions)
2. Running multiple games on multiple ports (om a single computer).
3. Running multiple games on multiple (remote) servers and ports.
4. Ports start and difference can be specified
5. Saving game logs with their tag (see Instructions)
6. Saving game results in a general file.
7. Saving game results in a separate file for each tag
8. Recognizing teams by nicknames (folder names - see Instructions)
9. Including kill script (port and remote specific in addition to kill all)
10. Handling results of penalty shoot-outs.
11. Showing progress using progress bar.

---

### Instructions

Game Tools are designed for two ways of running; Running on local computer and Running on multiple remote servers.

#### Instructions for running on local PC

1. Put each team's binaries in a folder with their name under teams folder. Default path for teams folder is `GAME_TOOLS_FOLDER/teams` but can be changed. (Format of teams binaries is described below)

2. Add Games in Games.txt file in root folder of Game Tools.

   Each line of Games.txt should contain exactly one game in the following format.

   `Team1 Team2`

   or

   `Team1 Team2 Tag`

   Specifying tag for games is optional.

3. Run start.sh script. You will be asked for the following:
   1. Teams folder: The folder you put teams binaries in. (as mentioned above `GAME_TOOLS_FOLDER/teams` is default folder, if you placed teams binaries in a different folder enter it's path here)
   2. Results folder: The folder results will be saved in. (Default is `GAME_TOOLS_FOLDER/results`)
   3. Number of games running simultaneously
   4. Server start port: Servers will be run on this port and above. (Default is 6000, leave untouched if you are unsure)
   5. Server port difference: Difference between server ports. (Default is 10, should at least be 3. leave untouched if you are unsure)

Wait for games to finish.

#### Instructions for running on remote servers

1. Add ssh key of master(id_rsa.pub) to `~/.ssh/authorized_keys` in all remote servers and add them as trusted servers in master.

2. Add ssh key of every remote server(id_rsa.pub) to `~/.ssh/authorized_keys` in master and add master as a trusted server in them.

3. Add your remote servers address to remoteAddresses.txt file in root folder of Game Tools in the following format

   `user@server_address number_of_games_on_this_server`

   or

   `user@server_address Number_of_games_on_this_server Path_for_Game_Files`

   Adding a path for game files is optional, if you don't start your path from root (`/...`) it will be started from home directory of the user specified.  User specified should have access to the folder you add for game files.

4. Add master address to masterAddress.txt file in root folder of Game Tools in the following format

   `master_user@master_address`

5. Put each team's binaries in a folder with their name under teams folder. Default path for teams folder is `GAME_TOOLS_FOLDER/teams` but can be changed. (Format of teams binaries is described below)

6. Add Games in Games.txt file in root folder of Game Tools.

   Each line of Games.txt should contain exactly one game in the following format.

   `Team1 Team2`

   or

   `Team1 Team2 Tag`

   Specifying tag for games is optional.

7. Run startRemote.sh script. You will be asked for the following:

   1. Teams folder: The folder you put teams binaries in. (as mentioned above `GAME_TOOLS_FOLDER/teams` is default folder, if you placed teams binaries in a different folder enter it's path here)
   2. Results folder: The folder results will be saved in. (Default is `GAME_TOOLS_FOLDER/results`)
   3. Server start port: Servers will be run on this port and above. (Default is 6000, leave untouched if you are unsure)
   4. Server port difference: Difference between server ports. (Default is 10, should at least be 3. leave untouched if you are unsure)

Wait for games to finish.



---

### After run 

Results and log files will be saved inside results folder which can be specified (see Instructions).

Results are saved on Results.txt file.

If a tag is included the logs will be saved in a folder with tag name inside results folder. In addition results of the tag will be saved in Results.txt inside tag folder as well as the main Results.txt file.

You can also use results.sh script to see, filter and save results.

##### Instructions for results.sh

1. Run results.sh in a shell.
2. You will be asked if you want to save results in a file in addition to seeing them. Enter y for yes, n for no. If you don't Enter any of them or take more than 10 seconds, script assumes you don't want to use this option
3. If you entered yes (y) in previous step you will be asked for a path for the save file if you don't specify or take more than 30 seconds, default location (./Saved_Results.txt) will be assumed.
4. You will be asked if you want results of a specific tag. If you do not enter anything or take more than 10 seconds, script shows (and saves if you chose to) all of the tags.

---

#### Additional Suggestion

There is another monitor which has more detailed information about matches and players information. This monitor is used in the official Robocup World Cup. If you wish to install it, just run these commands:

In the RoboCup repository cited above in this tutorial, download this [file](https://osdn.net/projects/rctools/releases/p4886).

Open a terminal and run:

> tar -zxpf soccerwindow2-x.x.x.tar.gz
>
> cd soccerwindow2-x.x.x.tar.gz
>
> ./configure
>
> make
>
> sudo make install

---

### Maintainers

**KN2C Robotic Team**

- Amir Mirzaei - <amir.mirzaei1379@gmail.com>
- Arash Saatchi - <arash.saatchi99@gmail.com>

[KN2C Website](http://kn2c.aras.kntu.ac.ir/)