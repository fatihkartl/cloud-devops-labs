# Linux Day 14 - Users, Groups & sudo

## Goal
Learn Linux user management, groups, permissions and file ownership.

## Commands

    whoami
    id
    groups
    getent passwd "$USER"
    getent group sudo
    sudo -l
    sudo groupadd labdev
    sudo useradd -m -s /bin/bash labuser
    sudo usermod -aG labdev labuser
    sudo -u labuser whoami
    sudo chown labuser:labdev file.txt
    sudo userdel -r labuser
    sudo groupdel labdev

## Key Ideas
- UID identifies a user; GID identifies a group.
- `sudo` runs authorized commands as another user.
- `useradd` creates users; `usermod` changes them.
- `-aG` preserves existing supplementary groups.
- `chmod` changes permissions; `chown` changes ownership.

## Practice
Created a Linux test user and group, managed group membership, tested file ownership and safely cleaned up the lab.