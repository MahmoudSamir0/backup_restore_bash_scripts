#!/usr/bin/bash
. ./backup_restore_lib.sh
export LC_COLLATE=C
shopt -s extglob
echo "####################################" && sleep .4
echo "#                                  #" && sleep .4
echo "#          Backup Script          #" && sleep .4
echo "#                                  #" && sleep .4
echo "####################################" && sleep .4

echo "This is a script given to users on a machine when they want to back up their work to a specific backup directory"
sleep 2
echo "The script requires four parameters"
sleep 2
echo "the first parameter is the directory to be backed up"
sleep 2
echo "the second parameter is the directory which should store eventually the backup"
sleep 2
echo "the third parameter is an encryption key that you should use to encrypt your backup"
sleep 2
echo "the fourth parameter is number of days (n) that the script should use to backup only the changed files during the last n days."
backup

echo "######################################" && sleep .2
echo "#                                    #" && sleep .2
echo "# thank you for using  Backup Script #" && sleep .2
echo "#                                    #" && sleep .2
echo "######################################" && sleep .2