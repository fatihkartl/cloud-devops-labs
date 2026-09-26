# Linux Day 11 - Bash Basics

## Goal

Learn basic Bash variables, input, command substitution, and shell scripting.

## Commands

```bash
echo "Hello"
name="Fatih"
echo "$name"
read -p "Name: " name
current_user=$(whoami)
chmod +x system-info.sh
./system-info.sh