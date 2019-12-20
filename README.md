![2d_game](./2d_game.jpeg)



welcome to the kn2c_rcss_2d repository

These scripts is developed by **KN2C robotic team** for running multiple games between different teams. These scripts can be used for testing or hosting competition purposes.

The scripts are developed in a way so you can use them with ease without any need for knowledge of shell commands and shell scripting. 

---

#### These scripts run in:

- [x] local mode
- [x] remote mode 

---

### These scripts have the following features:

1. Global Tagging
2. Tagging for each game (look at the instructions)
3. Running multiple games on multiple ports.
4. Ports start and difference can be specified
5. Saving results in a file and saving results
6. Recognizing teams by nicknames (folder names - look at the instructions)
7. kill script(port specific and killall)

---

### How to build

first clone this repository in your system

you have 2 choice for run the games:

**run in local : **

Put all of the teams in "teams" folder in the same folder as the scripts. (each team should have a *startAll* script that gets the port that games is going to be run on and run all of the players and coach)

*startAll*:

```bash
#!/bin/sh
#$1 ---> port
DIR="$(dirname $0)"
$DIR/src/start.sh -p $1
```

Specify games in "Games.txt" in the following formant: "Team1 Team2 tag". tag is optional. teams will be recognized by their folder name.

simply run start.sh script:

```bash
 ./start.sh
```
you see command like this:

> ./start.sh 
> enter path of teams directory: 
> ./teams
> enter path of results directory: 
> ./results
> enter number of games running simultaneously: 
> n=1
> enter servers start port: 
> ssp=6000
> enter servers port difference: 
> spd=10
> [=======================================================>
> Done!

To kill process

- run kill.sh script (if you want to kill processes of a single port you can specify it as input otherwise it would kill all the processes involved)
- run killall.sh script to killall scripts

`kill.sh `

`kill.sh current port`

**run in remote mode**

- after putting teams in teams directory and write the Games.txt you should fill masterAddress.txt and fill remoteAddresses.txt 
- next set ssh key in master and other systems 

---

### after run 

you can see results directory and Results.txt into it

