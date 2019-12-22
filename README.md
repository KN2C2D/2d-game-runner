<img src="/home/amir/Documents/rcss2d_game_scripts/Pics/KN2C_Logo.jpg" alt="KN2C_Logo" style="zoom: 67%;" />

## KN2C Game Tools

Game tools is developed by **KN2C robotic team** for running multiple games between different teams. it can be used for testing or hosting competitions.

Game tools is  developed in a way so you can use them with ease without any need for knowledge of shell commands and shell scripting. 

---

#### This project run in:

- [x] local mode
- [x] remote mode 

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
9. Including kill script (port and remote specific in addition to killall)
10. Handling results of penalty shoot-outs.

---

### How to use

First download this repository in your system

you have 2 choice for run the games:

**run in local : **

1. Put all of the teams in "teams" folder. (each team should have a *startAll* script that gets the port that games is going to be run on and run all of the players and coach)

*startAll*:

```bash
#!/bin/sh
#$1 ---> port
DIR="$(dirname $0)"
$DIR/src/start.sh -p $1
```

2. Specify games in "Games.txt" in the following formant: "Team1 Team2 tag". tag is optional. teams will be recognized by their folder name.

3. simply run start.sh script:

```bash
 ./start.sh
```

you see command like this:

> ./start.sh 
>
> enter path of teams directory: 
>
> ./teams
>
> enter path of results directory: 
>
> ./results
>
> enter number of games running simultaneously: 
>
> n=1
>
> enter servers start port: 
>
> ssp=6000
>
> enter servers port difference: 
>
> spd=10
>
> [=======================================================>
>
> Done!

To kill process

- run kill.sh script (if you want to kill processes of a single port you can specify it as input otherwise it would kill all the processes involved)

`./kill.sh `

`./kill.sh current port`

- run killall.sh script to killall scripts

`./killall.sh`

**run in remote mode**

1. after putting teams in teams directory and write the Games.txt you should fill masterAddress.txt and fill remoteAddresses.txt 

2. next set ssh key in master and other systems 

3. simply run startRemote script:

`./startRemote.sh`

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