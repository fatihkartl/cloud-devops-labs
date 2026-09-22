# Linux Day 5 - Processes

## Goal

Understand Linux processes, PIDs, process monitoring and termination.

## Commands

```bash
ps
ps aux
top
htop
pgrep -a sleep
kill PID

Pipes and Filtering

ps aux | head
ps aux | grep sleep

- | passes output from one command to another.
- head shows the first 10 lines by default.
- grep filters matching text.

sleep 300 &

& runs the command in the background.

What I Learned
- A process is a running program.
- Each process has a PID.
- ps, top and htop help inspect processes.
- kill terminates a process.
- pgrep searches processes by name.