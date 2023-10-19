# Resizing a partition, lv and ubuntu linux filesystem
## cfdisk
show cfdisk image


### vgdisplay
~~~
ubadmin@server5:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <38.00 GiB
  PE Size               4.00 MiB
  Total PE              9727
  Alloc PE / Size       4863 / <19.00 GiB
  Free  PE / Size       4864 / 19.00 GiB
  VG UUID               NbEjjH-rmtr-c1yI-hfBi-inkg-6nzI-cwPJLk

ubadmin@server5:~$
ubadmin@server5:~$
~~~
## lvdisplay
~~~
ubadmin@server5:~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                pYaALb-IvFX-Y6ch-X4oZ-GN82-ze9X-n4ubQK
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2023-08-09 17:56:14 -0400
  LV Status              available
  # open                 1
  LV Size                <19.00 GiB
  Current LE             4863
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

ubadmin@server5:~$
ubadmin@server5:~$ sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
  Size of logical volume ubuntu-vg/ubuntu-lv changed from <19.00 GiB (4863 extents) to <38.00 GiB (9727 extents).
  Logical volume ubuntu-vg/ubuntu-lv successfully resized.
ubadmin@server5:~$
ubadmin@server5:~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                pYaALb-IvFX-Y6ch-X4oZ-GN82-ze9X-n4ubQK
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2023-08-09 17:56:14 -0400
  LV Status              available
  # open                 1
  LV Size                <38.00 GiB
  Current LE             9727
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

ubadmin@server5:~$
ubadmin@server5:~$
~~~

## Resize the filesystem
### resize2fs
~~~
ubadmin@server5:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              794M  1.2M  793M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   19G  9.8G  7.9G  56% /
tmpfs                              3.9G     0  3.9G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G  527M  1.3G  29% /boot
tmpfs                              794M  4.0K  794M   1% /run/user/1000
ubadmin@server5:~$ sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
old_desc_blocks = 3, new_desc_blocks = 5
The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 9960448 (4k) blocks long.

ubadmin@server5:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              794M  1.2M  793M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   38G  9.8G   26G  28% /
tmpfs                              3.9G     0  3.9G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G  527M  1.3G  29% /boot
tmpfs                              794M  4.0K  794M   1% /run/user/1000
ubadmin@server5:~$

~~~



~~~
sudo pvresize /dev/sda3
  Physical volume "/dev/sda3" changed
  1 physical volume(s) resized or updated / 0 physical volume(s) not resized



Device       Start       End   Sectors Size Type
/dev/sda1     2048      4095      2048   1M BIOS boot
/dev/sda2     4096   4198399   4194304   2G Linux filesystem
/dev/sda3  4198400 167772126 163573727  78G Linux filesystem


Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 38 GiB, 40797995008 bytes, 79683584 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


ubadmin@devtools:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              794M  8.4M  786M   2% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   38G   18G   19G  49% /
tmpfs                              3.9G   52K  3.9G   1% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G  404M  1.4G  23% /boot
tmpfs                              794M  4.0K  794M   1% /run/user/1000
ubadmin@devtools:~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                pYaALb-IvFX-Y6ch-X4oZ-GN82-ze9X-n4ubQK
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2023-08-09 17:56:14 -0400
  LV Status              available
  # open                 1
  LV Size                <38.00 GiB
  Current LE             9727
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

ubadmin@devtools:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <78.00 GiB
  PE Size               4.00 MiB
  Total PE              19967
  Alloc PE / Size       9727 / <38.00 GiB
  Free  PE / Size       10240 / 40.00 GiB
  VG UUID               NbEjjH-rmtr-c1yI-hfBi-inkg-6nzI-cwPJLk


ubadmin@devtools:~$
ubadmin@devtools:~$ sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
  Size of logical volume ubuntu-vg/ubuntu-lv changed from <38.00 GiB (9727 extents) to <78.00 GiB (19967 extents).
  Logical volume ubuntu-vg/ubuntu-lv successfully resized.

ubadmin@devtools:~$
ubadmin@devtools:~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                pYaALb-IvFX-Y6ch-X4oZ-GN82-ze9X-n4ubQK
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2023-08-09 17:56:14 -0400
  LV Status              available
  # open                 1
  LV Size                <78.00 GiB
  Current LE             19967
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

ubadmin@devtools:~$

ubadmin@devtools:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <78.00 GiB
  PE Size               4.00 MiB
  Total PE              19967
  Alloc PE / Size       19967 / <78.00 GiB
  Free  PE / Size       0 / 0
  VG UUID               NbEjjH-rmtr-c1yI-hfBi-inkg-6nzI-cwPJLk


ubadmin@devtools:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              794M  8.4M  785M   2% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   38G   18G   19G  49% /
tmpfs                              3.9G   52K  3.9G   1% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G  404M  1.4G  23% /boot
tmpfs                              794M  4.0K  794M   1% /run/user/1000
ubadmin@devtools:~$
ubadmin@devtools:~$
ubadmin@devtools:~$ sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
old_desc_blocks = 5, new_desc_blocks = 10
The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 20446208 (4k) blocks long.

ubadmin@devtools:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              794M  8.4M  785M   2% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   77G   18G   57G  24% /
tmpfs                              3.9G   52K  3.9G   1% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G  404M  1.4G  23% /boot
tmpfs                              794M  4.0K  794M   1% /run/user/1000
ubadmin@devtools:~$
~~~


![image](https://github.com/parkinglot837/ubuntu-server-22/assets/8241838/84abf61f-1467-4312-84af-867d04e346aa)
