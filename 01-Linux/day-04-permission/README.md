# Linux Day 4 - Permissions

## Goal

Understand Linux file permissions, ownership and executable files.

## Permissions

- `r` → read > 4 
- `w` → write > 2
- `x` → execute > 1

## Permission Groups

- user
- group
- others
    eg.
    '-' normal file
    'd' folder
    / -rw-/ r-- / r-- / 1 fatih fatih 412 Sep 22 14:58 README.md
    user  group  others

## Numeric Permissions

- `7` → rwx  4+2+1
- `6` → rw-  4+2+0
- `5` → r-x  4+0+1
- `4` → r--  4+0+0
- `0` → ---  0+0+0
   
   4+2+0    4+0+0  4+0+0
/  -rw-   /  r-- / r--  / 1 fatih fatih 412 Sep 22 14:58 README.md
    user   group  others    user:group

## Examples

```bash
chmod 600 test.txt    user rw- 4+2+0 / group --- 0+0+0 / others --- 0+0+0
chmod 644 test.txt    user rw- 4+2+0 / group r-- 4+0+0 / others r-- 4+0+0
chmod 755 hello.sh    user rwx 4+2+1 / group r-x 4+0+1 / others r-x 4+0+1
chmod 700 private.sh  user rwx 4+2+1 / group --- 0+0+0 / others --- 0+0+0

## owner

`chown` changes the owner/group of a file or folder.

Example:

`sudo chown root:root README.md`

-rw-r--r-- 1 root root 931 Sep 22 15:07 README.md

It sets the file's owner and group to `root`.
