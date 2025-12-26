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

| Log Files | Description |
| :-: | :-: |
| /var/log/syslog| General system logs (Debian/Ubuntu) |
| /var/log/messages | General system logs (RHEL/CentOS) |
| /var/log/auth.log | Authentication logs (SSH, sudo, login attempts)|
| /var/log/kern.log | Kernel log|
| /var/log/dmesg | Boot and hardware messages |
| /var/log/cron.log | Logs from scheduled cron jobs|
| /var/log/nginx/error.log | Nginx specific error log |
| /var/log/mysql/error.log | MySQL error log|

### Basic Linux Commands with Examples
#### 1. File and Directory Operations Commands
| Command | Description | Options | Examples |
|--------|-------------|---------|----------|
| `ls` | List files and directories. | `-l` : Long format listing<br>`-a` : Include hidden files<br>`-h` : Human-readable file sizes | `ls -l`<br>Displays files and directories with detailed information.<br><br>`ls -a`<br>Shows all files and directories, including hidden ones.<br><br>`ls -lh`<br>Displays file sizes in a human-readable format. |
| `cd` | Change directory. |  | `cd /path/to/directory` <br> changes the current directory to the specified path. |
| `pwd` | Print current working directory. | | `pwd` <br> displays the current working directory. |
| `mkdir` | Create a new directory. | | `mkdir my_directory` <br> creates a new directory named "my_directory". |
| `rm` | Remove files and directories | `-r` <br> Remove directories recursively. <br><br> `-f` <br> Force removal without confirmation. | `rm file.txt` <br> deletes the file named "file.txt".<br><br> `rm -r my_directory` <br> deletes the directory "my_directory" and its contents. <br><br> `rm -f file.txt` <br> forcefully deletes the file "file.txt" without confirmation.|
| `cp` | Copy files and directories. | `-r` <br> Copy directories recursively. | ` cp -r directory destination` <br> copies the directory "directory" and its contents to the specified destination. <br><br> `cp file.txt destination` <br> copies the file "file.txt" to the specified destination. |
| `mv` |Move/rename files and directories. | |` mv file.txt new_name.txt ` <br> renames the file "file.txt" to "new_name.txt". <br><br> `mv file.txt directory` moves the file "file.txt" to the specified directory. |
| `touch` | Create an empty file or update file timestamps. | | `touch file.txt` <br> creates an empty file named "file.txt". |
| `cat` | View the contents of a file. | | `cat file.txt` <br> displays the contents of the file "file.txt". |
| `head` | Display the first few lines of a file. | `n` <br> Specify the number of lines to display. | `head file.txt` <br> shows the first 10 lines of the file "file.txt".<br><br> `head -n 5 file.txt` <br> displays the first 5 lines of the file "file.txt". |
| `tail` | Display the last few lines of a file. | `n` <br> Specify the number of lines to display. | `tail file.txt` <br> shows the last 10 lines of the file "file.txt".<br><br> `tail -n 5 file.txt` displays the last 5 lines of the file "file.txt". |
| `ln` | Create links between files. | `s` <br> Create symbolic (soft) links. | `ln -s source_file link_name` creates a symbolic link named "link_name" pointing to "source_file". |
| `find` | Search for files and directories. | `name` <br> Search by filename.<br><br> `type` Search by file type | `find /path/to/search -name "*.txt"` searches for all files with the extension ".txt" in the specified directory. |

#### 2. File Permission Commands

| Command | Description | Options | Examples |
|--------|-------------|---------|----------|
| `chmod` | Change file permissions. | `u` <br> User/owner permissions.<br><br> `g` <br> Group permissions.<br><br> `o` <br> Other permissions.<br><br> `+` <br> Add permissions.<br><br> `-` <br> Remove permissions.<br><br> `=` <br> Set permissions explicitly. | `chmod u+rwx file.txt` <br> grants read, write, and execute permissions to the owner of the file. |
| `chown` | Change file ownership. | | `chown user file.txt` <br> changes the owner of "file.txt" to the specified user. |
| `chgrp` | Change group ownership. | | `chgrp group file.txt` <br> changes the group ownership of "file.txt" to the specified group. |
| `unmask` |  Set default file permissions. | `umask 022` <br> sets the default file permissions to read and write for the owner, and read-only for group and others. |

#### 3. File Compression and Archiving Commands
| Command | Description | Options | Examples |
| `tar` | Create or extract archive files. | `c` <br> Create a new archive.<br><br> `x` <br> Extract files from an archive.<br><br> `f` <br> Specify the archive file name.<br><br> `v` <br> Verbose mode.<br><br> `z` <br> Compress the archive with gzip.<br><br> `j` <br> Compress the archive with bzip2. | `tar -czvf archive.tar.gz files/` <br> creates a compressed tar archive named "archive.tar.gz" containing the files in the "files/" directory.<br><br> `tar –xvzf archive.tar.gz files/` <br> uncompressed tar archive named "archive.tar.gz |
| `gzip` | Compress files. | `d` <br> Decompress files. | `gzip file.txt` <br> compresses the file "file.txt" and renames it as "file.txt.gz". |
| `zip` | Create compressed zip archives. | `r` <br> Recursively include directories. | `zip archive.zip file1.txt file2.txt` <br> creates a zip archive named "archive.zip" containing "file1.txt" and "file2.txt". |












| S/N | Problem | Log to Check | Example Command | Expected Outcome | Possible Fixes |
|----|---------|--------------|-----------------|------------------|----------------|
|**Diagnosing SSH Login Failures** | You’re trying to SSH into a server, but the authentication fails, or the connection hangs indefinitely | /var/log/auth.log (Debian/Ubuntu)<br>/var/log/secure (RHEL/CentOS) | `grep sshd /var/log/auth.log` | `Failed password for invalid user admin...`<br>`Accepted password for root...` | • Ensure username/password is correct<br>• For *public key denied*: verify `~/.ssh/authorized_keys` and permissions<br>• If many failures: check Fail2ban or IP blocks |
| **Investigating High Disk Usage** | Your system has run out of space, as indicated by errors such as “No space left on device.” | Disk issues show indirectly in:<br>/var/log/syslog<br>/var/log/messages | `sudo du -sh /var/log/*` | `grep -i "disk full" /var/log/syslog`<br>`grep -i "no space" /var/log/syslog` | • Configure **logrotate**<br>• Clear /tmp, /var/cache<br>• Use `df -h` and `du -sh` to locate large files |
| **Service Crashes / Failure (NGINX, Apache, MySQL)** | A service, such as NGINX, Apache, or MySQL, crashes or refuses to start. | /var/log/syslog<br>/var/log/messages<br>/var/log/nginx/error.log<br>/var/log/mysql/error.log | `grep nginx /var/log/syslog` | `nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)` | • Port in use → run `lsof -i :80`<br>• Validate config: `nginx -t` / `apachectl configtest`<br>• Check OOM kills in syslog |
| **Boot Issues / Kernel Panics** | The system fails to boot properly or encounters kernel panics during startup. | /var/log/kern.log<br>/var/log/dmesg<br>/var/log/syslog | `dmesg | less` | `Kernel panic - not syncing: VFS: Unable to mount root fs...` | • Boot with live USB → run `fsck`<br>• Reinstall GRUB / update initramfs<br>• Verify `/etc/fstab` UUIDs |
| **Unauthorized Access / Attacks** | You suspect brute force attacks or unauthorized access attempts are taking place against your system | /var/log/auth.log<br>/var/log/fail2ban.log<br>/var/log/messages | `grep "Failed password" /var/log/auth.log` | `Failed password for invalid user...` | • Enable fail2ban<br>• Change SSH port<br>• Disable root login<br>• Use SSH keys instead of passwords |
| **Application-Level Issues** | Your custom application crashes, returns HTTP 500 errors, or behaves in an unexpected manner | /var/log/myapp.log<br>/var/log/syslog | `grep "Exception" /var/log/myapp.log` | Application stack traces / exceptions | • Improve app logging<br>• Use `tail -f` for live debugging<br>• Add alerts/monitoring tools |
| **Troubleshooting Cron Jobs** | Scheduled cron tasks are not executing, or their output isn’t visible as expected. | /var/log/cron.log<br>/var/log/syslog | `grep CRON /var/log/syslog` | `CMD (/usr/local/bin/backup.sh)`<br>`CMDOUT (Permission denied)` | • Ensure script is executable: `chmod +x`<br>• Add `PATH=` inside script<br>• Log output: `script.sh >> /var/log/backup.log 2>&1` |

#### Tools to enhance log troubleshooting

| Command | Example | Description |
|:-:|:-:|:-:|
| tail -f | /var/log/syslog | Monitor logs in real-time to see new entries as they are made |
| journalctl | journalctl -u nginx.service --since "1 hour ago" | For systems using systemd, you can view service-specific logs |
| logrotate | sudo logrotate -d /etc/logrotate.conf | Prevent logs from becoming excessively large and consuming disk space with log rotation |
| watch | watch -n 2 tail -n 10 /var/log/syslog | run log checks at regular intervals |


| Command                          | Description                                              |                           |
| -------------------------------- | -------------------------------------------------------- | ------------------------- |
| `sudo -i`                        | Switch to root user                                      |                           |
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
