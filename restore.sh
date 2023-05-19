#!/usr/bin/bash
. ./backup_restore_lib.sh
export LC_COLLATE=C
shopt -s extglob
echo "####################################" && sleep .4
echo "#                                  #" && sleep .4
echo "#         restore Script          #" && sleep .4
echo "#                                  #" && sleep .4
echo "####################################" && sleep .4

echo "The script requires three parameters."
sleep 2
echo "the first parameter is the directory that contains the backup."
sleep 2
echo "the second parameter is the directory that the backup should be restored to."
sleep 2
echo "the third parameter is the decryption key that should be used to restore the backup."
restore

echo "######################################" && sleep .2
echo "#                                    #" && sleep .2
echo "#thank you for using  restore Script #" && sleep .2
echo "#                                    #" && sleep .2
echo "######################################" && sleep .2