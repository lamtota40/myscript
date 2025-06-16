#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo parted /dev/vda --script mkpart primary ext4 20GB 40GB
sudo parted /dev/vda --script mkpart primary linux-swap 40GB 100%

mkpart primary ext4 20GB 40GB
mkpart primary linux-swap 40GB 100%

sudo mkfs.ext4 -L datafs /dev/vda2
sudo mkswap /dev/vda3
sudo swapon /dev/vda3
