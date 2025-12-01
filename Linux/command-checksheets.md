# Linux

## Vagrant for VM
In vagrant there is no OS installation. It comes with a free box available on Vagrant could.

- _Vagrantfile_ - It manage all the VM settings, VM changes, provisioning
- _Vagrant commands_
- vagrant init boxname
- vagrant status
- vagrant list
- vagrant ssh - to login
- vagrant up
- vagrant ssh
- vagrant halt
- vagrant destroy
- vagrant reload
- history - To view prevous issued command
- vagrant global-status - Tell the state of all active Vagrant environments on the system for the currently logged in user.

#### Vagrant Architecture

![](../images/linux/vagrant-architecture.jpg)

- _Steps to setup VM using vigrant_
1. Create a folder in the directory of your choice: mkdir /c/vagrant-vms
2. Create vagrant file - vagrant init boxname. for example (vagrant init eurolinux-vagrant/centos-stream-9)
3. Start the VM using: vagrant up

### Linux Introduction

Most used Linux distros currently in IT industry
1. RPM Based: RHEL, CENTOS, ORACLE LINUX.
2. Debian Based: Ubuntu server, Kali Linux.

The difference between RPM and Debian based Linux are
- The extention of the Debian software package is _.deb_, _.rpm_ for RPM based Linux.
- For installation, Debian based use _dpkg_ command, while RPM based Linux use _rpm_ command. For example. Debian - _dpkg -i google-chrome-stable_current_amd64.deb_ and RPM - _rpm -ivh google-chrome-stable_current_amd64.rpm_

### Important Linux Directories

1. Home Directories

- /root — Home directory for the root (superuser) account

- /home/username — Home directory for regular users

2. User Executables

- /bin — Essential user commands

- /usr/bin — Non-essential but commonly used user commands

- /usr/local/bin — Locally installed user commands

3. System Executables

- /sbin — Essential system binaries

- /usr/sbin — Additional system administration binaries

- /usr/local/sbin — Locally installed system binaries

4. Other Mountpoints

- /media — Removable media (USB drives, CDs)

- /mnt — Temporary mount point

5. Configuration Files

- /etc — System-wide configuration files

6. Temporary Files

- /tmp — Temporary storage (cleared on reboot)

7. Kernels and Bootloader

- /boot — Kernel, initrd, and bootloader files

8. Server and Variable Data

- /var — Logs, spool files, variable application data

- /srv — Data served by the system (web, FTP, etc.)

9. System Information

- /proc — Kernel and process information (virtual filesystem)

- /sys — Device and system information (virtual filesystem)

10. Shared Libraries

- /lib — Essential shared libraries

- /usr/lib — Additional shared libraries

- /usr/local/lib — Locally installed libraries

##### VIM Editor

VIM has three command modes
1. Command mode
2. Insert (edit mode)
3. Extended command mode
- :set nu — Enable line numbers in Vim

##### Type of files in Linux

| File Type | First Character in File Listing | Desctiption |
| :---: | :---: | :---: |
| Regular file | - | Normal files such as text, data, or executable file | 
| Directory | d | Files that are lists of other files |
| Link | l | A shortcut that points to the location of the actual file |
| Special file | c | A special file that provides inter-process networking protected by the file system's access control |
| Pipe | p | A special file that allows processes to communicate with each other without using network socket semantics |

#### Common Log File Locations

| - | - | - | - | - | - |
| Log Files | Description |
| /var/log/syslog| General system logs (Debian/Ubuntu) |
| /var/log/messages | General system logs (RHEL/CentOS) |
| /var/log/auth.log | Authentication logs (SSH, sudo, login attempts)|
| /var/log/kern.log | Kernel log|
| /var/log/dmesg | Boot and hardware messages |
| /var/log/cron.log | Logs from scheduled cron jobs|
| /var/log/nginx/error.log | Nginx specific error log |
| /var/log/mysql/error.log | MySQL error log|


| - | - | - | - | - | - |

| S/N| Problem | Log to check | Example command | Expected outcome | Possible fixex |

| Diagnosing SSH Login failures | You’re trying to SSH into a server, but the authentication fails, or the connection hangs indefinitely | /var/log/auth.log (Debian/Ubuntu) <br>
/var/log/secure (RHEL/CentOS)| grep sshd /var/log/auth.log | Jul 5 11:02:43 server sshd[1234]: Failed password for invalid user admin from 192.168.0.101 port 55888 ssh2 <br>
Jul 5 11:03:10 server sshd[1234]: Accepted password for root from 192.168.0.105 port 57844 ssh2| For a Failed Password: Ensure that the username exists and confirm that the password used is correct. <br>
For a Permission Denied (public key): Check that the ~/.ssh/authorized_keys file has the correct public key and verify permissions on the SSH configuration file sshd_config. <br>
For Too Many Failed Attempts: Look for rate-limiting tools like fail2ban that may be blocking the IP address.|

|Investigating High Disk Usage | Your system has run out of space, as indicated by errors such as “No space left on device.” | While disk usage itself may not be logged directly, you might see side effects in: <br> /var/log/syslog <br> /var/log/messages <br> To check which logs are growing rapidly. | You can use: sudo du -sh /var/log/* | You can search for relevant messages using: <br> grep -i "disk full" /var/log/syslog <br> grep -i "no space" /var/log/syslog
 | Use logrotate to rotate large logs, ensuring they do not overwhelm your disk space. <br> Clear unnecessary files in directories such as /tmp or /var/cache. <br> Use df -h and du -sh to identify the largest disk users and analyze disk usage trends.|

| Service crashes and failure | A service, such as NGINX, Apache, or MySQL, crashes or refuses to start. | General service logs include: <br> /var/log/syslog <br>
/var/log/messages <br> Service-specific logs may include: <br> /var/log/nginx/error.log <br> /var/log/mysql/error.log | grep nginx /var/log/syslog | You might find entries similar to this: <br> Jul 5 14:20:01 server nginx[4782]: nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use) | _Address Already in Use_: Another service is likely using port 80. Use lsof -i :80 to identify which service is running on that port. <br> _Missing Configuration File_: Verify the configuration using nginx -t or apachectl configtest to check for syntax errors in the configuration file. <br> _Out-of-Memory Kills_: Check /var/log/syslog for Out-Of-Memory (OOM) messages that may indicate that the service was killed due to resource constraints. | 

| Identifying Boot issues or Kernel panics | The system fails to boot properly or encounters kernel panics during startup. | /var/log/kern.log <br>/var/log/dmesg <br> 
/var/log/syslog <br> Use _dmesg | less_ <br> Look for: <br> Hardware errors (related to disk, RAM, GPU) <br> Kernel panics <br> Missing kernel modules or drivers necessary for booting | [1.234567] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) | Boot from a live CD or USB and check disk health using tools like fsck. <br> Reinstall GRUB or update initramfs to fix bootloader issues. <br> Check the fstab file and ensure that UUIDs and paths are correctly specified to avoid filesystem mounting issues. |

| Detecting unauthorized access or attacks| You suspect brute force attacks or unauthorized access attempts are taking place against your system| /var/log/auth.log <br> /var/log/fail2ban.log <br> /var/log/messages | grep "Failed password" /var/log/auth.log | wc -l | You might see something like: <br> Jul 5 11:02:43 server sshd[1234]: Failed password for invalid user test from 192.168.0.105 <br> Jul 5 11:02:45 server sshd[1234]: Failed password for root from 192.168.0.105 | Utilize fail2ban or similar tools to automatically block IP addresses that make too many failed login attempts. <br> Change the default SSH port to prevent bots from targeting the standard port (22). <br>Disable root login via SSH for better security practices. <br>
Implement public key authentication rather than password-based authentication to enhance security.|

| Application -level issues | Your custom application crashes, returns HTTP 500 errors, or behaves in an unexpected manner | If you’ve configured rsyslog to capture logs for your application, look in: <br>
/var/log/myapp.log <br> /var/log/syslog |grep "Exception" /var/log/myapp.log |Add appropriate logging in your application to capture errors effectively and trace issues when they arise.<br> During testing, monitor logs in real-time using tail -f to catch issues as they occur.<br>
Set up alerts using log monitoring tools to be notified of critical errors or failures. |

|Troubleshooting cron jobs | Scheduled cron tasks are not executing, or their output isn’t visible as expected. | /var/log/cron.log <br>
/var/log/syslog |ggrep CRON /var/log/syslog | You might see entries like this: <br>

Jul 5 07:15:01 server CRON[1212]: (root) CMD (/usr/local/bin/backup.sh) <br>
Jul 5 07:15:01 server CRON[1213]: (root) CMDOUT (Permission denied) | _Permission Issues_: Ensure that the script being run is executable by using chmod +x /usr/local/bin/backup.sh. <br>
_Environment Variables_: Remember that cron runs in a minimal shell environment. You may need to set the PATH variable inside the script to ensure it can find all necessary commands. <br>
_Redirect Output_: Implement logging within the script to capture errors. You can add redirection within the cron entry itself (e.g., /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1) to log output and errors for easier troubleshooting.
|

#### Tools to enhance log troubleshooting

|-|-|-|
|:-:|:-:|:-:|
|tail -f |/var/log/syslog|Monitor logs in real-time to see new entries as they are made|
|journalctl | journalctl -u nginx.service --since "1 hour ago"| For systems using systemd, you can view service-specific logs|
|logrotate |sudo logrotate -d /etc/logrotate.conf| Prevent logs from becoming excessively large and consuming disk space with log rotation|
|watch | watch -n 2 tail -n 10 /var/log/syslog | run log checks at regular intervals|


| Command                          | Description                                              |                           |
| -------------------------------- | -------------------------------------------------------- | ------------------------- |
| `whoami`                         | Displays the current logged-in username                  |                           |
| `pwd`                            | Prints the current working directory                     |                           |
| `ls`                             | Lists directory contents                                 |                           |
| `ls -l`                          | Long listing with permissions, size, owner, etc.         |                           |
| `ls -lt`                         | Lists files sorted by time (newest first)                |                           |
| `ls -ltr`                        | Lists files sorted by time (oldest first)                |                           |
| `ls -ltr /etc/`                  | Lists `/etc` directory in reverse time order             |                           |
| `clear`                          | Clears the terminal screen                               |                           |
| `cd <path>`                      | Changes directory                                        |                           |
| `cd ~`                           | Goes to home directory                                   |                           |
| `mkdir <dir>`                    | Creates a directory                                      |                           |
| `mkdir dir1 dir2`                | Creates multiple directories                             |                           |
| `mkdir -p <path>`                | Creates nested directories (no error if exists)          |                           |
| `touch <file>`                   | Creates an empty file                                    |                           |
| `cat <file>`                     | Prints file contents                                     |                           |
| `cat /etc/hostname`              | Shows system hostname                                    |                           |
| `cat /proc/uptime`               | Shows system uptime (kernel level)                       |                           |
| `cp <src> <dest>`                | Copies files                                             |                           |
| `cp -r <src> <dest>`             | Recursively copies directories                           |                           |
| `cp --help`                      | Shows help for `cp` command                              |                           |
| `mv <src> <dest>`                | Moves or renames files/directories                       |                           |
| `rm <file>`                      | Deletes a file                                           |                           |
| `rm -r <dir>`                    | Deletes a directory recursively                          |                           |
| `rm -rf *`                       | Deletes *all* files and folders in directory (dangerous) |                           |
| `uptime`                         | Shows system uptime and load averages                    |                           |
| `free -m`                        | Displays memory usage in MB                              |                           |
| `df -h`                          | Shows disk usage in human-readable format                |                           |
| `file <file>`                    | Identifies file type                                     |                           |
| `vim <file>`                     | Opens a file in Vim editor                               |                           |
| `less <file>`                    | Opens file for paginated viewing                         |                           |
| `more <file>`                    | Similar to `less` (forward only)                         |                           |
| `head <file>`                    | Shows first 10 lines of a file                           |                           |
| `head -n <num>`                  | Shows first N lines                                      |                           |
| `tail <file>`                    | Shows last 10 lines                                      |                           |
| `tail -n <num>`                  | Shows last N lines                                       |                           |
| `tail -f <file>`                 | Follows a file in real time                              |                           |
| `grep <pattern> <file>`          | Searches for text in a file                              |                           |
| `grep -i <pattern> <file>`       | Case-insensitive search                                  |                           |
| `grep -R <pattern> <path>`       | Recursive search                                         |                           |
| `cut -d':' -f1 /etc/passwd`      | Cuts column 1 using `:` delimiter                        |                           |
| `awk '{print $1}'`               | Prints the first column                                  |                           |
| `awk -F':' '{print $1}'`         | Uses `:` as field separator                              |                           |
| `sed 's/x/y/g'`                  | Replaces text (non-destructive)                          |                           |
| `sed -i 's/x/y/g'`               | Replaces text in-place                                   |                           |
| `wc -l <file>`                   | Counts lines in a file                                   |                           |
| `wc -l < file`                   | Line count using redirection                             |                           |
| `ls                              | wc -l`                                                   | Counts files in directory |
| `find <path> -name <pattern>`    | Searches for files/directories                           |                           |
| `locate <pattern>`               | Fast file search (uses mlocate DB)                       |                           |
| `updatedb`                       | Updates `locate` database                                |                           |
| `hostname`                       | Shows the current hostname                               |                           |
| `hostname <newname>`             | Sets a new hostname                                      |                           |
| `yum install <pkg>`              | Installs a package                                       |                           |
| `yum remove <pkg>`               | Removes a package                                        |                           |
| `yum search <pkg>`               | Searches for packages                                    |                           |
| `yum upgrade`                    | Upgrades system packages                                 |                           |
| `rpm -ivh <packagename>.rpm`     | Installs an RPM package                                  |                           |
| `rpm -qa`                        | Lists installed RPM packages                             |                           |
| `rpm -e <pkg>`                   | Removes an RPM package                                   |                           |
| `rpm --help`                     | Shows RPM help                                           |                           |
| `curl <url> -o <file>`           | Downloads a file using curl                              |                           |
| `systemctl start <service>`      | Starts a service                                         |                           |
| `systemctl stop <service>`       | Stops a service                                          |                           |
| `systemctl restart <service>`    | Restarts a service                                       |                           |
| `systemctl reload <service>`     | Reloads config without stopping service                  |                           |
| `systemctl status <service>`     | Shows service status                                     |                           |
| `systemctl enable <service>`     | Enables service on boot                                  |                           |
| `systemctl is-active <service>`  | Checks if service is active                              |                           |
| `systemctl is-enabled <service>` | Checks if service starts on boot                         |                           |
| `cat /etc/systemd/...`           | Shows systemd service file                               |                           |
| `tree <directory>`               | Lists directory tree structure                           |                           |
| `ln -s <target> <link>`          | Creates symbolic link                                    |                           |
| `unlink <link>`                  | Removes symbolic link                                    |                           |
| `grep -i firewall *`             | Searches entire directory for “firewall”                 |                           |
| `lsof -u <user>`                 | Lists open files by user                                 |                           |
| `wc -l /etc/passwd`              | Count number of users                                    |                           |
| `useradd <user>`                 | Creates a new user                                       |                           |
| `passwd <user>`                  | Sets password for user                                   |                           |
| `groupadd <group>`               | Creates a group                                          |                           |
| `usermod -aG <group> <user>`     | Adds user to group                                       |                           |
| `id <user>`                      | Shows user identity info                                 |                           |
| `tail -f /var/log/messages`      | Follows system log                                       |                           |
| `last`                           | Shows last login history                                 |                           |
| `who`                            | Shows logged-in users                                    |                           |
| `lsof`                           | Lists open files and processes                           |                           |
| `userdel <user>`                 | Deletes user                                             |                           |
| `userdel -r <user>`              | Deletes user and home directory                          |                           |
| `groupdel <group>`               | Deletes a group                                          |                           |
| `chmod`                          | Changes permissions                                      |                           |
| `chown`                          | Changes ownership                                        |                           |
| `echo "text"`                    | Prints text                                              |                           |
| `echo text > file`               | Writes to file (overwrite)                               |                           |
| `echo text >> file`              | Appends to file                                          |                           |
| `yum install wget -y`            | Installs wget                                            |                           |

#### I/O Redirection

| Symbol | Description     |
| ------ | --------------- |
| `>`    | Redirect output |
| `<`    | Redirect input  |
| `>>`   | Append output   |


#### Common Commands

- df -h — Show disk usage in human-readable format

- echo — Print text to terminal

#### Users and Groups
Every Linux user has a User ID (UID) stored in /etc/passwd, while the encrypted password is stored in /etc/shadow.

#### Types of Users
| Type    | Example           | User ID Range | Group ID Range | Home Directory | Shell         |
| ------- | ----------------- | ------------- | -------------- | -------------- | ------------- |
| Root    | root              | 0             | 0              | /root          | /bin/bash     |
| Regular | Emmanuel, Vagrant | 1000–60000    | 1000–60000     | /home/username | /bin/bash     |
| Service | ftp, ssh, apache  | 1–999         | 1–999          | /var/ftp, etc. | /sbin/nologin |

#### Users and group management

| Command                      | Description                          |
| ---------------------------- | ------------------------------------ |
| `useradd username`           | Add a new user                       |
| `groupadd groupname`         | Add a new group                      |
| `usermod -aG Devops ansible` | Add user *ansible* to *Devops* group |
| `passwd ansible`             | Set/reset password for user          |
| `lsof -u vagrant`            | Show all open files by user          |
| `userdel username`           | Delete a user                        |
| `userdel -r username`        | Delete user and their home directory |
| `groupdel groupname`         | Delete a group                       |


#### File Permissions
Use ls -l to display file permissions.

| Symbol | Meaning                 |
| ------ | ----------------------- |
| **r**  | Read permission         |
| **w**  | Write / create / remove |
| **x**  | Execute                 |
| **-**  | No permission           |


#### Changing Ownership

| Command                            | Description                          |
| ---------------------------------- | ------------------------------------ |
| `chown -R username:groupname path` | Change ownership recursively         |
| `chmod o-x file`                   | Remove execute permission for others |
| `chmod g+w file`                   | Add write permission for group       |

#### Numeric (Octal) Permissions

Three-digit format:

- 1st digit = owner

- 2nd digit = group

- 3rd digit = others

#### Permission values:

- 4 = read

- 2 = write

- 1 = execute

#### Example:

chmod 640 myfile


- 6 = owner has read (4) + write (2)

- 4 = group has read

- 0 = others have no permission

#### Sudo Access

To grant a user sudo privileges:

- Run visudo

- Edit /etc/sudoers

##### Give the user permissions similar to root

Package Management (CentOS/RHEL) common package tools:

- yum

- dnf

Example:

- yum install epel-release -y — Enable extra packages repository

#### Process Management

| Command      | Description                |                                 |
| ------------ | -------------------------- | ------------------------------- |
| `top`        | Real-time CPU & RAM usage  |                                 |
| `ps aux`     | Show all running processes |                                 |
| `ps -ef`     | Full process listing       |                                 |
| `ps -ef      | grep httpd`                | Find processes matching *httpd* |
| `kill <PID>` | Kill a process             |                                 |
