# Linux Day 3 - Filesystem

## Goal

Understand the purpose of important Linux directories.

## Key Directories

- `/` → filesystem root
- `/home` → user home directories
- `/etc` → system and service configuration
- `/var/log` → logs
- `/tmp` → temporary files
- `/usr` → programs and shared system resources
- `/root` → root user's home directory

## Practice

```bash
cd /
ls

cd /etc
ls | head

cd /var/log
ls | head

cd /tmp
pwd

cd ~
pwd