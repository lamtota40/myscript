#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo parted /dev/vda --script mkpart primary ext4 20GB 40GB
sudo parted /dev/vda --script mkpart primary linux-swap 40GB 100%

sudo partprobe /dev/vda
sleep 2

sudo mkfs.ext4 -L datafs /dev/vda2
sudo mkswap /dev/vda3
sudo swapon /dev/vda3

UUID_EXT4=$(blkid -s UUID -o value "/dev/vda2")
UUID_SWAP=$(blkid -s UUID -o value "/dev/vda3")

mkdir -p /data
echo "UUID=$UUID_EXT4 /data ext4 defaults 0 2" >> /etc/fstab
echo "UUID=$UUID_SWAP none swap sw 0 0" >> /etc/fstab

$swappiness=60
$vfs_cache_pressure=100
sed -i -e '/^vm.swappiness/d' -e '/^vm.vfs_cache_pressure/d' /etc/sysctl.conf
echo -e "vm.swappiness=$swappiness\nvm.vfs_cache_pressure=$vfs_cache_pressure" >> /etc/sysctl.conf
sysctl vm.swappiness=$swappiness
sysctl vm.vfs_cache_pressure=$vfs_cache_pressure
sysctl -p

mount /dev/vda2 /data
