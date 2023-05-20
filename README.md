# backup_restore_bash_scripts
## goal
The goal of These scripts that perform secure encrypted backup and restore functionality,that backup the content of a specific directory, towards a remote server **AWS EC2**, this script only copies new files and files that were modified for **number** of days,able to schedule running the backup script on predefined times
## Main features
* Backup modified directories
* Upload to EC2 server
* Encrypts backup file using GPG

## Requirements
* gnupg tool
   * GPG can be found in most distribution’s repositories out of the box.
     * On Debian and Ubuntu-based systems, install the gpg package:
        ```shell script
        sudo apt install gpg
        ```
     *   If you use Arch based distributions, install the gnupg package with the pacman command:
            ```shell script
            sudo pacman -S gnupg            
           ```
* SCP Command
  * CentOS 7/RHEL 7:
  ```shell script
   sudo yum install -y openssh-clients openssh
  ``` 

  * Ubuntu/Debian:
  ```shell script
  sudo apt install -y openssh-client openssh-server
  ``` 
  
  * Arch Linux:
   ```shell script
   sudo pacman -Sy
   ``` 
   ```shell script
   sudo pacman -S openssh
   ``` 
* tar 
* gzip
* 
## scripts
The two scripts **backup.sh** and **restore.sh** source **backup_restore_lib.sh** and invoke the corresponding functions.
1. backup.sh 
    * functions
      *  validate_backup_params
      *  backup
2. restore.sh
    * function 
      * validate_restore_params
      * restore
## remote server
If you want to use the backup script to upload the backup to a remote server, you must first prepare the AWS EC2 server. You can do this by following the instructions in the [AWS documentation](https://docs.aws.amazon.com/).
## Automate Backup
It is advisable to create a cron job to run the script regularly in an automatic manner. To do this, open **crontab** with the following command:
```shell script
sudo crontab -e
```
It may prompt you to choose an editor, I generally prefer nano. You can then add a line to the bottom of this file in the following format
minute hour day-of-month month day-of-week /path/to/shell/script
`Eg. 0 5 * * 6 $HOME/backup.sh >/dev/null 2>&1` 
Save & close the file.
This will execute the script at 05:05 every Saturday Also, we mute the execution result by sending the output to /dev/null.

## encryption using GPG

### How does GPG work for encryption?
GPG keys work by using two files, a private key and a public key. These two keys are tied to
each other, and are both needed to use all of GPG’s functionality, notably encrypting and
decrypting files.
When you encrypt a file with GPG, it uses the private key. The new, encrypted file can then
only be decrypted with the paired public key.
The private key is meant to be stored in a fashion stated directly in its name – privately, and
not given out to anyone.
The public key on the other hand is meant to be given to others, or anyone you want to be
able to decrypt your files.
This is where GPG’s main approach for encryption comes into play. It allows you to encrypt
files locally and then allow others to be ensured that the files they received were actually
sent from you. As the only way they’ll be able to decrypt the file is with your public key, which
would only work if the file was encrypted using your private key in the first place.
This also works in the opposite direction! Other people can encrypt files using your
public key, and the only way it’ll be able to be decrypted is with your private key. Thus
allowing others to publicly post files without worry of people besides you being able to read
them.

**In other words, if a file was encrypted with a private key, it can only be decrypted with
the corresponding public key. And if a file was encrypted with a public key, it can only
be decrypted with the corresponding private key.**

### Encrypting and decrypting files with GPG
This is a very simplistic scenario. I presume that you have just one system and you want to see how GPG works. You are not sending the files to other system. You encrypt the file and then decrypt it on the same system.
Of course, this is not a practical use case but that’s also not the purpose of this tutorial. My aim is to get you acquainted with GPG commands and functioning. After that, you can use this knowledge in a real-world situation (if need be). And for that, I’ll show you how you can share your public key with others.
#### Step 1: Installing GPG
#### Step 2: Generating a GPG key
Generating a GPG key on your system is a simple one-command
procedure.
Just run the following command, and your key will be generated (you
can use the defaults for most questions as shown in the underlined
sections below)

```shell script
gpg --full-generate-key
```
![gpg-create](https://github.com/MahmoudSamir0/backup_restore_bash_scripts/blob/master/screenshot/gpg-1.png)
![gpg-create-2](https://github.com/MahmoudSamir0/backup_restore_bash_scripts/blob/master/screenshot/gpg-2.png)

#### Checking the GPG Key
You can then see that the private key and public key are both tied to each other by that ID shown under pub by using the **–list-secret-keys** and **–list-public-keys** commands respectively:
![gpg-create-3](https://github.com/MahmoudSamir0/backup_restore_bash_scripts/blob/master/screenshot/ist_gpg.png)

#### Sending and receiving GPG Keys

To send someone a GPG key, you’ll first need to export it from your keychain, which is what contains all of your public and private keys.

To export a key, simply find the key ID in your keychain, and then run the following command, replacing id with the key’s ID and key.gpg with the name of the file you want to save to:
```shell script
gpg --output key.gpg --export id
```
![send](https://github.com/MahmoudSamir0/backup_restore_bash_scripts/blob/master/screenshot/gpg-send-1.png)

To import a key, simply give the output file **(from the previous command)** to the other user and then have them run the following command:
```shell script
gpg --import key.gpg
```
![import](https://github.com/MahmoudSamir0/backup_restore_bash_scripts/blob/master/screenshot/Screenshot%20from%202023-05-18%2021-13-35.png)

To use the key normally though, you’ll need to verify the key so GPG properly trusts it.

This can be done by running the **–edit-key** command on the other user’s system, following by signing the key:

```shell script
gpg --edit-key id
```
![import](https://github.com/MahmoudSamir0/backup_restore_bash_scripts/blob/master/screenshot/Screenshot%20from%202023-05-18%2021-14-48.png)
