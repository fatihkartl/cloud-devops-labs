# Linux Day 10 - SSH Basics

## Goal

Understand basic SSH connections and key-based authentication.

## Commands

```bash
ssh user@host
ssh -p 2222 user@host
ssh-keygen -t ed25519 -C "fatih-cloud-devops"
ls -la ~/.ssh
cat ~/.ssh/id_ed25519.pub