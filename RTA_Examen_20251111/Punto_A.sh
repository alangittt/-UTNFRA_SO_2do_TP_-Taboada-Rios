#!/bin/bash

# Particionar discos para LVM
fdisk /dev/sdb <<EOF
n
p
1


t
8e
w
EOF

fdisk /dev/sdc <<EOF
n
p
1


t
8e
w
EOF

# Crear volúmenes físicos
pvcreate /dev/sdb1 /dev/sdc1

ev/vg_datos/lv_docker
mkfs.ext4 /dev/vg_temp/lv_workareas
mkswap /dev/vg_temp/lv_swap


mkdir -p /var/lib/docker
mkdir -p /work


mount /dev/vg_datos/lv_docker /var/lib/docker
mount /dev/vg_temp/lv_workareas /work
swapon /dev/vg_temp/lv_swap


echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 2" >> /etc/fstab
echo "/dev/vg_temp/lv_workareas /work ext4 defaults 0 2" >> /etc/fstab
echo "/dev/vg_temp/lv_swap none swap sw 0 0" >> /etc/fstab


