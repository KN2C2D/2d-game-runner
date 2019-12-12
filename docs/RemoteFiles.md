## Remote files

#### remoteAddresses.txt

This file stores address and users of the remote servers. Also it keeps track of how many games should be run simultaneously in each of the remote servers. Additionally it can contain path for remote files to be copied on the server. It will ignore lines out of the format below:

​	user@server number_of_simultaneous_games [optional]path_for_games_files

Servers can be disabled by adding a '#' to start of their line for when you don't have them availabe at the moment but you don't want to remove them from the file.

Writing anything out of that pattern with same number of word (two or three space separated words) won't cause scripts to ignore them but instead will cause errors.

#### masterAddresses.txt

This file stores user and IP address of the master. It should be just one line with the format below:

​	user@IP_of_master



