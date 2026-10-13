# Linux Day 16 - Troubleshooting

## Goal
Learn to diagnose CPU, memory, disk, service and network issues on Linux.

## Commands

    uptime
    nproc
    top
    ps aux --sort=-%cpu | head -n 6
    free -h
    ps aux --sort=-%mem | head -n 6
    df -h
    du -h --max-depth=1 /var/log
    systemctl status nginx
    journalctl -u nginx -n 20 --no-pager
    sudo ss -ltnp '( sport = :80 )'
    curl -I http://127.0.0.1
    sudo nginx -t
    ip -br addr
    ip route
    getent hosts example.com

## Key Ideas
- `uptime` shows system load averages.
- `top` monitors processes in real time.
- `free` reports RAM and swap usage.
- `df` and `du` help diagnose disk usage.
- `systemctl` and `journalctl` help diagnose service failures.
- `ss`, `ip`, `getent` and `curl` help diagnose network issues.

## Practice
Investigated CPU, RAM, disk and network metrics in WSL Ubuntu. Verified an Nginx service using port checks, HTTP responses and configuration tests. Completed simulated production incident scenarios.