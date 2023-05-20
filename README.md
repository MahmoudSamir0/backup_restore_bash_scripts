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

    
