# Day 08 — Nginx Reverse Proxy & Load Balancing

## Overview

Hands-on Cloud/DevOps networking lab using Nginx as a reverse proxy and load balancer in Ubuntu on WSL2. The lab covers upstream routing, Round Robin, failover, passive health checks, access-log observability, and troubleshooting HTTP 502/504 errors.

## Architecture

```text
Client / curl
    |
    v
Nginx :18080
    |
    +---- Python Backend 1 :8000
    |
    +---- Python Backend 2 :8001
```

**Note:** Port `8080` is reserved for another application. This lab uses `18080`.

## Tools

- Ubuntu (WSL2)
- Nginx
- Python 3 (`http.server` for local testing)
- curl

## Backend Setup

Run each server in a separate terminal:

```bash
mkdir -p /tmp/day08-backend /tmp/day08-backend-2
printf '<h1>Merhaba! Ben Python Backend.</h1>\n' > /tmp/day08-backend/index.html
printf '<h1>Merhaba! Ben Backend 2 - Port 8001.</h1>\n' > /tmp/day08-backend-2/index.html

# Terminal 1
python3 -m http.server 8000 --bind 127.0.0.1 --directory /tmp/day08-backend

# Terminal 2
python3 -m http.server 8001 --bind 127.0.0.1 --directory /tmp/day08-backend-2
```

## Nginx Configuration

File: `/etc/nginx/conf.d/day08-loadbalancer.conf` (included inside the Nginx `http` context).

```nginx
log_format day08_upstream
    '$remote_addr [$time_local] "$request" '
    'status=$status upstream=$upstream_addr '
    'upstream_status=$upstream_status '
    'request_time=$request_time '
    'upstream_time=$upstream_response_time';

upstream day08_backends {
    zone day08_backends 64k;
    server 127.0.0.1:8000 max_fails=2 fail_timeout=20s;
    server 127.0.0.1:8001 max_fails=2 fail_timeout=20s;
}

server {
    listen 18080;
    server_name localhost;
    access_log /var/log/nginx/day08-access.log day08_upstream;

    location / {
        proxy_pass http://day08_backends;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Apply:

```bash
sudo nginx -t && sudo nginx -s reload
```

## Tests

**Round Robin:**

```bash
curl -sS --http1.1 \
  http://127.0.0.1:18080/ \
  http://127.0.0.1:18080/ \
  http://127.0.0.1:18080/ \
  http://127.0.0.1:18080/
```

**Check upstream logs:**

```bash
sudo tail -n 10 /var/log/nginx/day08-access.log
sudo tail -n 10 /var/log/nginx/error.log
```

**Observe HTTP status codes:**

```bash
curl -sS -o /dev/null -w 'HTTP %{http_code}\n' http://127.0.0.1:18080/
```

## Results

| Scenario | Observed result |
|---|---|
| Both backends healthy | Round Robin across ports 8000 and 8001 |
| Single backend stopped | Successful failover to the remaining backend |
| Passive health checks | Two connection failures recorded; service remained available |
| One backend delayed by 1 second | HTTP 200, but about 1.0 s latency for that backend |
| 500 ms proxy read timeout during delayed response | HTTP 504 in **0.500989 s** |
| Final recovery | 4/4 HTTP 200 responses; both backends around 0–1 ms (logged precision) |

### Troubleshooting Takeaways

- **Connection refused:** TCP connection to the target port was rejected.
- **502 Bad Gateway:** Nginx could not obtain a valid upstream response (observed when the backend was stopped).
- **504 Gateway Timeout:** Nginx did not receive the upstream response in time.
- **200 OK does not guarantee a healthy backend:** check latency and upstream error logs too.

## Outcome

Built and debugged a two-backend Nginx load balancer with passive health checks, failover, custom upstream logs, and latency-based troubleshooting. All tests used local-only Python servers for educational purposes.
