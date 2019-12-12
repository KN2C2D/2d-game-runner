## Local scripts

#### run.sh

This script takes name of two teams (folder name of the teams in teams folder), number of a port and an optional tag. Then runs the game on the specified port then saves the game's result and logs with the specified tag.

#### runOnPort.sh

This scripts takes a port number, n and m then runs the k*n+m games in Games.txt using run.sh

#### start.sh

It takes results path, teams path, number of games running simultaneously, server start port and server port difference as input (it also has default values for these inputs and timeouts). then runs runOnPort.sh script n times with 0~n-1 for m and server_start_port + server_port_difference * m for port number.

#### killall.sh

Kills all the scripts and jobs related to games using killall command.

#### kill.sh

Takes an optional port to kill processes related to games and the specified port. Kills all the processes related to games in no port specified as input argument.

#### clearResults.sh

Clears results according to path.txt(see [Temporary_Files](TempFiles.md)) .