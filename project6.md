# WEB SOLUTION WITH WORDPRESS

[Resource](https://www.youtube.com/watch?v=fJnjuG-CK4g)

> Three-tier Architecture
* Generally, web, or mobile solutions are implemented based on what is called the Three-tier Architecture.

Three-tier Architecture is a client-server software architecture pattern that comprise of 3 separate layers.

![](images/project6/client-server-arc.png)

- Presentation Layer (PL): This is the user interface such as the client server or browser on your laptop.
- Business Layer (BL): This is the backend program that implements business logic. Application or Webserver
- Data Access or Management Layer (DAL): This is the layer for computer data storage and data access. Database Server or File System Server such as FTP server, or NFS Server

> Your 3-Tier Setup
- A Laptop or PC to serve as a client
- An EC2 Linux Server as a web server (This is where you will install WordPress)
- An EC2 Linux server as a database (DB) server
- Use RedHat OS for this project

* Step 1 — Prepare a Web Server

> Create AWS EBS and Mount EBS on EC2/LINUX

* Create 3 volumes

- login to your aws portal
- Under EBS(Elastic Block Store), select volumes
- click create volume in the reading pane
- select the espected information and create
- mount the aws EBS on the Linux server
- Select the created volume and right click to select attach
- Select the server you want to attach the EBS to
- Click attach
- login to the server and list all the blocks - lsblk
- Use df -h command to see all mounts and free space on your server
- Use gdisk utility to create a single partition on each of the 3 disks

* Create partition in the 3 volumes
- List all the blocks - lsblk
- create partition on one of the disk - sudo gdisk /dev/xvdf
- Enter n to create new disk
- To use the entire disk space, press enter or type the disk space you want to use
- For Hex code enter - 8e00 to create Linux LVM
- Enter p to create partition
- Enter w to write and save the changes
- Repeat the same steps for volume 2 and 3
- Install lvm2 package using sudo yum install lvm2. Run sudo lvmdiskscan command to check for available partitions.
- Use pvcreate utility to mark each of 3 disks as physical volumes (PVs) to be used by LVM
- sudo pvcreate /dev/xvdf1
- sudo pvcreate /dev/xvdg1
- sudo pvcreate /dev/xvdh1
- Run sudo pvs to verify the physical volumes are created
- Use vgcreate utility to add all 3 PVs to a volume group (VG). Name the VG webdata-vg
- sudo vgcreate webdata-vg /dev/xvdh1 /dev/xvdg1 /dev/xvdf1
- Verify that your VG has been created successfully by running-  sudo vgs
* Use lvcreate utility to create 2 logical volumes. apps-lv (Use half of the PV size), and logs-lv Use the remaining space of the PV size. NOTE: apps-lv will be used to store data for the Website while, logs-lv will be used to store data for logs.
- sudo lvcreate -n apps-lv -L 14G webdata-vg
- sudo lvcreate -n logs-lv -L 14G webdata-vg
Verify that your Logical Volume has been created successfully by running sudo lvs

![](images/project6/logical-v.png)


- check if it has file system - file -s /dev/webdata-vg(the EBS name)
- if it shows data, then the file system has not been create. Create it by 
- sudo mkfs -t ext4 /dev/vg-webdata/apps-lv
- sudo mkfs -t ext4 /dev/vg-webdata/logs-lv
- create a folder and point it to the drive 
* Create /var/www/html directory to store website files
- sudo mkdir -p /var/www/html
* Create /home/recovery/logs to store backup of log data
- sudo mount /dev/webdata-vg/apps-lv /var/www/html/
* Use rsync utility to backup all the files in the log directory /var/log into /home/recovery/logs (This is required before mounting the file system)
- sudo rsync -av /var/log/. /home/recovery/logs/
* Mount /var/log on logs-lv logical volume. (Note that all the existing data on /var/log will be deleted. That is why step 15 above is very
important)
- sudo mount /dev/webdata-vg/logs-lv /var/log
* Restore log files back into /var/log directory
- sudo rsync -av /home/recovery/logs/. /var/log

- sudo mkdir -p /home/recovery/logs
* Mount /var/www/html on apps-lv logical volume
- confirmit has been created - df -hT
- To have a pointer permently, 
- vim /etc/fstab
- Add a new line - /dev/sdf /newstorage ext4 defaults, nofail 0 0
- save the file
- Confirm everything is working fine - mount -a
- df -hT

> Update the `/etc/fstab` file

- The UUID of the device will be used to updfate the /etc/fstab file
- Run - sudo blkid
- Copy the following to notepad
- /dev/mapper/--: UUID="6846ad84---" BLOCK_SIZE="4096" TYPE="ext4"
- /dev/mapper/--: UUID="887f43ec-e7e3-4--" BLOCK_SIZE="4096" TYPE="ext4"
- Update the etc/fstab - sudo vim /etc/fstab

- Edit the mappers above as shown below and paste
- UUID=6846ad84-f8d2-4b40-b429-93fa920fb07b /var/www/html ext4 defaults, nofail 0 0
- UUID=887f43ec-e7e3-4cba-82f8-04a72b7d5d6a /var/log ext4 defaults 0 0

- run sudo mount -a to ensure there is no error

- Reload the Daemon - sudo systemctl daemon-reload
- Verify the database - df -h
![](images/project6/ws-setup.png)



