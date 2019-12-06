These scripts is developed by **KN2C robotic team** for running multiple games between different teams. These scripts can be used for testing or hosting competition purposes.

The scripts are developed in a way so you can use them with ease without any need for knowledge of shell commands and shell scripting.

These scripts have the following features:

1. Global Tagging
2. Tagging for each game (look at the instructions)
3. Running multiple games on multiple ports.
4. Ports start and difference can be specified
5. Saving results in a file and saving results
6. Recognizing teams by nicknames (folder names - look at the instructions)
7. kill script(port specific and killall)

To uses these scripts follow the instructions below

	1. Put all of the teams in "teams" folder in the same folder as the scripts. (each team should have a startAll script that gets the port that games is going to be run on and run all of the players and coach)
 	2. Specify games in "Games.txt" in the following formant: "Team1 Team2 tag". tag is optional. teams will be recognized by their folder name.
 	3. simply run start.sh script

To kill process

- run kill.sh script (if you want to kill processes of a single port you can specify it as input otherwise it would kill all the processes involved)
- run killall.sh script to killall scripts



Put teams in teams folder in same folder as scripts (every team should have a startAll script in it's directory (with the exact name startAll) this script should get the port to be run on as an argument and start all of the players and the coach)

Write games in Games.txt in same folder as scripts in following format: "Team1 Team2 tag". Teams will be recognized by their folder name. Tag is optional.

simply run start.sh script and give it inputs or leave them at their default values.

You can use

