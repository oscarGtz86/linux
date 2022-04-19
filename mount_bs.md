## Mount Block Storage Volume

To use a block device in Linux it must be mounted into the operating system.

1. Use the *lsblk* command to view your available disk devices
```
# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0    8G  0 disk
-xvda1  202:1    0    8G  0 part /
xvdf    202:80   0   10G  0 disk
```

2. Create file system on the volume
```
# mkfs -t xfs /dev/xvdf
```
Warning: `mkfs command format the volume and delete the existing data`.

3. Create a mount point
```
# mkdir /data
```

4. Mount the volume at the directory
```
# mount /dev/xvdf /data
```

## Automatically mount an attached volume after reboot
1. Create a backup of /etc/fstab file
```
# cp /etc/fstab /etc/fstab.bkp
```

2. Find the UUID of the device using *blkid* command
```
# blkid
/dev/xvda1: LABEL="/" UUID="ca774df7-756d-4261-a3f1-76038323e572" TYPE="xfs" PARTLABEL="Linux" PARTUUID="02dcd367-e87c-4f2e-9a72-a3cf8f299c10"
/dev/xvdf: UUID="be86aa70-0549-44e0-a3e2-8dff5fbaed96" TYPE="xfs"
```
In this example the UUID is *be86aa70-0549-44e0-a3e2-8dff5fbaed96*

3. Add the entry to /etc/fstab
```
UUID=be86aa70-0549-44e0-a3e2-8dff5fbaed96  /data  xfs  defaults,nofail  0  2
```
Reboot to validate
```
# shutdown -r now
```

4. Check the output of *df* command after reboot
```
# df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  474M     0  474M   0% /dev
tmpfs          tmpfs     483M     0  483M   0% /dev/shm
tmpfs          tmpfs     483M  412K  483M   1% /run
tmpfs          tmpfs     483M     0  483M   0% /sys/fs/cgroup
/dev/xvda1     xfs       8.0G  1.6G  6.5G  20% /
/dev/xvdf      xfs       2.0G   35M  2.0G   2% /data
tmpfs          tmpfs      97M     0   97M   0% /run/user/1000
```

The entry `/dev/xvdf      xfs       2.0G   35M  2.0G   2% /data` shows the new file system attached