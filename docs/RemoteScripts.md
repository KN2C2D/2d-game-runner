## Remote scripts

#### remoteRun.sh

This script is designed to be copied to remote servers. It will take name of two teams (folder name of teams in teams folder) a port for the game to be run on and an optional tag. This script runs a single game between teams specified on the port specified then save the result on master(see [Remote_Files](RemoteFiles.md)) on the path specified.

#### runOnRemote.sh

This script is designed to be run on master and it will not be sent to remote servers. It will take index(number of the line for the remote in remoteAddresses.txt see [Remote_Files](RemoteFiles.md)), number of a port, n and m and runs k*n+m games in the Games.txt.

#### kill.sh and killall.sh

Same as kill.sh and killall.sh(see [Local_Scripts](LocalScripts.md)). These scripts will be sent to remote servers to help with killing processes.

#### updateRemote.sh

This script is designed to send teams and scripts to remote servers using scp command.

#### clearRemote.sh

This script will remove the folder copied to remote servers using updateRemote.sh

#### startRemote.sh

This script will take save path, teams path, start port and port difference (It also has default values for these inputs and also timeouts), Then updates remote server files using updateRemote.sh script. It will run runOnRemote.sh multiple times to run games on the specified servers and ports.

note: port difference should at least be 3.

#### killRemote.sh

This scripts is designed to kill running scripts and jobs related to games on master and remote servers. It uses kill.sh script in the remote servers. Index of the remote server and port can be specified optionally as input command arguments so rest won't be touched.

If an index and a port specified it would only kills the game currently running on the specified remote and port.

If no argument specified this scripts kills the whole process.