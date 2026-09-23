# Linux Day 6 - Services

## Goal

Understand basic Linux service management.

## Core Commands

```bash
systemctl status "SERVICE NAME"
sudo systemctl start "SERVICE NAME"
sudo systemctl stop "SERVICE NAME"
sudo systemctl restart "SERVICE NAME"
sudo systemctl enable "SERVICE NAME"
journalctl -u "SERVICE NAME"