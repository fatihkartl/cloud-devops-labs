# Linux Day 15 - Disk & Storage

## Goal
Learn Linux disk usage, block devices, filesystems and mount points.

## Commands

    df -h
    df -h ~
    du -sh ~/bash-lab
    du -h --max-depth=1 /var/log
    lsblk
    lsblk -f
    findmnt
    findmnt -T /
    findmnt -T /mnt/c

## Key Ideas
- `df` shows filesystem capacity and usage.
- `du` shows file and directory disk usage.
- `lsblk` lists disks and partitions.
- `mount` attaches a filesystem to a directory.
- `umount` detaches a mounted filesystem.
- `findmnt` displays filesystem mount information.
- WSL provides access to Windows drives through paths such as `/mnt/c`.

## Practice
Inspected Ubuntu and Windows storage from WSL and completed a disk troubleshooting scenario using `df`, `du`, `lsblk` and `findmnt`.