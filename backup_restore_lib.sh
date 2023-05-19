#!/usr/bin/bash
# 2. Your program should print a help message indicating how it should be used if it is invoked without any parameters.
export LC_COLLATE=C
shopt -s extglob
function backup {

backup_date=$(date | sed "s/:/_/g" | sed "s/ /_/g")
mkdir "$HOME"/"$backup_date"
echo "backup directory created and is ready at $HOME/$backup_date"
echo "list all directory to help you"
ls "$HOME"
validate_backup_params
main_directories=$(ls "$HOME"/$valid_directory_name_backup)
for dir in $main_directories; do
  if [ -d "$HOME"/$valid_directory_name_backup/$dir ]
then
  mkdir -p "$HOME"/$valid_directory_name_store/$dir
  find "$HOME"/$valid_directory_name_backup/$dir -type f -mtime "$valid_number_days" -exec cp {} "$HOME"/$valid_directory_name_store/$dir \;
  find "$HOME"/$valid_directory_name_store/ -type d -empty  -delete
  fi
done
cd "$HOME"/$valid_directory_name_store
archive_directories=$(ls "$HOME"/$valid_directory_name_store)
for tar in $archive_directories; do
  tar czvf $tar-$backup_date.tar.gz  $tar/*
  gpg --encrypt $tar-$backup_date.tar.gz
  rm -r $tar
  rm $tar-$backup_date.tar.gz
done
cd "$HOME"
tar czvf $valid_directory_name_store.tar.gz  $valid_directory_name_store
gpg --encrypt $valid_directory_name_store.tar.gz
rm -r $valid_directory_name_store
rm $valid_directory_name_store.tar.gz
echo "---------------------------------done---------------------------------------------------------"
echo "now do you want to upload your encrypt directory to remote server (ec2) you should prepare ec2 first (Y/N)"
read anse
case $anse in
      "Y" | "y" | "YES" | "Yes" | "yes" )
      echo "enter path of private key for ec2 "
      read private
      echo "enter Public IPv4 DNS for ec2"
      read DNS
      echo "enter user name for  ec2"
      read $user

sudo scp -i $private $valid_directory_name_store.tar.gz.gpg $user@$DNS:~/.
      ;;
     "N" | "n" | "No" | "NO" | "no" | "nO" )
echo "######################################" && sleep .2
echo "#                                    #" && sleep .2
echo "# thank you for using  Backup Script.#" && sleep .2
echo "#                                    #" && sleep .2
echo "######################################" && sleep .2
      ;;
   *)
    esac

}

function validate_backup_params {
echo "now enter requires parameters"
echo "1) the directory to be backed up"
read  directory_name_backup
if [  -d "$HOME"/"$directory_name_backup" ]
then
valid_directory_name_backup="$directory_name_backup"
echo "directory name is valid!"
else
  echo "directory name is not valid!"
 	select choice in "choose another name" "exit"
 	do
	case $REPLY in
	1)echo "enter another directory"
	  read directory_name_backup
	  if [  -d "$HOME"/"$directory_name_backup" ]
	  then
    valid_directory_name_backup="$directory_name_backup"
    echo "directory name is valid!"
    break
    else
    echo "directory name is not valid!"
    fi
  ;;
  2) sleep .5
    exit
  ;;
		*)
		sleep .5
		echo "$REPLY is not the correct choice!"
			;;
		esac
		done

fi
echo "2) the directory which should store eventually the backup"
read directory_name_store
if [  -d "$HOME"/"$directory_name_store" ] && [[ $directory_name_store != $directory_name_backup ]];
then
valid_directory_name_store="$directory_name_store"
echo "directory name is valid!"
else
  echo "directory name is not valid! or directory_name_store ('$directory_name_store') and directory_name_backup ('$directory_name_backup') are the same directory "
 	select choice in "choose another name" "exit"
 	do
	case $REPLY in
	1)echo "enter another directory"
	  read directory_name_store

	  if [  -d "$HOME"/"$directory_name_store" ]
	  then
    valid_directory_name_store="$directory_name_store"
    echo "directory name is valid!"
    break
    else
      echo "directory name is not valid!"
    fi
  ;;
  2) sleep .5
    exit
  ;;
		*)
		sleep .5
		echo "$REPLY is not the correct choice!"
			;;
		esac
		done

fi

echo -e  "3) encryption key that you should use to encrypt your backup or  decrypt your backup directory \n Pres yes if you want to generate key or NO to something else ? (Y/N) "
read ans
case $ans in
      "Y" | "y" | "YES" | "Yes" | "yes" )
      echo " to generate key  find it in documentation step by step"
      gpg --full-generate-key
      echo " to export the key To send someone a GPG key find it in documentation "
      ;;
     "N" | "n" | "No" | "NO" | "no" | "nO" )
        echo "to import the key from someone a GPG key find it in documentation"
        echo -e "\n"
      ;;
   *)
    esac

echo "4) the number of days (n) that the script should use to backup only the changed files during the last n days."
read number_days
if [[ $number_days =~ ^[0-9]+$ ]]
then
  valid_number_days=$number_days
else
  echo "'$number_days' is not valid!"
  select choice in "enter number days again" "exit"
  do
	case $REPLY in
	1) echo "enter number days again"
	    read number_days
      if [[ $number_days =~ ^[0-9]+$ ]]
        then
          valid_number_days=$number_days
          break
       else
        echo "'$number_days' is not valid!"
      fi
  ;;
  2) sleep .5
    exit
  ;;
		*)
		sleep .5
		echo "$REPLY is not the correct choice!"
			;;
		esac
		done
		fi
}

function restore {
validate_restore_params
mkdir "$HOME"/"$valid_restored_directory"
echo "restore directory created and is ready at $HOME/$valid_restored_directory"
echo "list all archive_directories to help you to select your directory"
ls "$HOME"
valid_decrypt_backup_directory=$(sed 's/.\{4\}$//' <<<"$valid_encrypt_backup_directory")
gpg --decrypt --output "$HOME"/$valid_decrypt_backup_directory "$HOME"/$valid_encrypt_backup_directory
mv "$HOME"/$valid_decrypt_backup_directory "$HOME"/"$valid_restored_directory"
cd "$HOME"/"$valid_restored_directory"
tar xzf $valid_decrypt_backup_directory
rm $valid_decrypt_backup_directory
cd "$HOME"/$valid_directory_name_store
restore_directories=$(sed 's/.\{7\}$//' <<<"$valid_decrypt_backup_directory")
restore_subdirectories=$(ls "$HOME"/$valid_restored_directory/$restore_directories)
echo $restore_subdirectories
cd "$HOME"/$valid_restored_directory/$restore_directories
ls
for decrypt in $restore_subdirectories; do
  decrypt_backup_subdirectory=$(sed 's/.\{4\}$//' <<<"$decrypt")
  gpg --decrypt --output "$HOME"/$valid_restored_directory/$restore_directories/$decrypt_backup_subdirectory "$HOME"/$valid_restored_directory/$restore_directories/$decrypt
  tar xzf $decrypt_backup_subdirectory
  rm $decrypt_backup_subdirectory
  rm $decrypt
done
}

function validate_restore_params {
  echo "enter restored directory name "
  read restored_directory
	  if [ ! -d "$HOME"/$restored_directory ]
      then
        valid_restored_directory=$restored_directory
        echo "directory name is valid!"
    else
      echo "directory name is not valid! there is another directory has same name "
 	select choice in "choose another name" "exit"
 	do
	case $REPLY in
	1)echo "enter another directory"
	  read restored_directory

	  if [ ! -d "$HOME"/$restored_directory ]
	  then
    valid_restored_directory="$restored_directory"
    echo "directory name is valid!"
    break
    else
      echo "directory name is not valid! there is another directory has same name "
    fi
  ;;
  2) sleep .5
    exit
  ;;
		*)
		sleep .5
		echo "$REPLY is not the correct choice!"
			;;
		esac
		done
      fi


echo "enter your encrypt backup directory path "
read encrypt_backup_directory
if [  -e "$HOME"/"$encrypt_backup_directory" ]
then
valid_encrypt_backup_directory="$encrypt_backup_directory"
echo "found the directory "
else
  echo "unfounded the directory"
 	select choice in "choose another name" "exit"
 	do
	case $REPLY in
	1)echo "enter another directory"
	  read encrypt_backup_directory
	  if [  -e "$HOME"/"$encrypt_backup_directory" ]
	  then
    valid_encrypt_backup_directory="$encrypt_backup_directory"
echo "found the directory "
    break
    else
  echo "unfounded directory"
    fi
  ;;
  2) sleep .5
    exit
  ;;
		*)
		sleep .5
		echo "$REPLY is not the correct choice!"
			;;
		esac
		done
		fi

		echo -e  "3) encryption key that you should use to decrypt your backup directory \n  do you have encryption key ? (Y/N) "
read answer
case $answer in
      "Y" | "y" | "YES" | "Yes" | "yes" )
      echo " continue decryption"
      ;;
     "N" | "n" | "No" | "NO" | "no" | "nO" )
        echo " to import the key from someone a GPG key find it in documentation "
        echo -e "\n"
      ;;
   *)
    esac
}
