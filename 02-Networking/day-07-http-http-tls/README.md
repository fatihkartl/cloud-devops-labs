# Day 07 — HTTP, HTTPS & TLS

## Overview

Hands-on networking lab exploring HTTP request/response behavior, status codes, headers, cookies, sessions, persistent connections, TLS certificates, and HTTP protocol versions.

## Environment

- Ubuntu on WSL2
- Nginx 1.28.3
- Python 3 HTTP server
- Curl 8.18.0
- OpenSSL
- Google Chrome DevTools

## Topics Covered

- HTTP methods and status codes
- HTTP headers and Nginx access logs
- TCP connection errors vs. HTTP errors
- Cookies and server-side sessions
- HTTP/1.1 Keep-Alive
- HTTPS, TLS 1.3, and certificate verification
- HTTP/1.1, HTTP/2, and HTTP/3
- Basic web troubleshooting

## Hands-on Labs

**1. HTTP response inspection**

```bash
curl -i http://127.0.0.1/
curl -v http://127.0.0.1/
```

**2. Local Python HTTP server**

```bash
mkdir -p /tmp/networking-day07
echo '<h1>HTTP Lab</h1>' > /tmp/networking-day07/index.html
python3 -m http.server 59999 --bind 127.0.0.1 --directory /tmp/networking-day07
```

**3. Custom headers and Nginx logs**

```bash
curl -A "Network-Lab-07" -I http://127.0.0.1/
sudo tail -n 5 /var/log/nginx/access.log
```

**4. HTTP connection reuse**

```bash
curl -v --http1.1 \
  -o /dev/null http://127.0.0.1/ \
  -o /dev/null http://127.0.0.1/
```

**5. TLS certificate inspection**

```bash
echo | openssl s_client \
  -connect example.com:443 \
  -servername example.com 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates
```

**6. HTTP version comparison**

```bash
curl -sS --http1.1 -o /dev/null -w '%{http_version}\n' https://example.com/
curl -sS --http2 -o /dev/null -w '%{http_version}\n' https://example.com/
```

## Key Findings

- HTTP 404 indicates an HTTP response; connection refusal occurs before an HTTP response is received.
- Nginx may return HTTP 502 when an upstream backend is unavailable.
- Cookies can carry session identifiers while session state is stored server-side.
- Keep-Alive allows multiple HTTP requests to reuse a TCP connection.
- TLS certificate verification protects against hostname mismatches.
- HTTP/3 uses QUIC over UDP rather than TCP.

## Lab Results

| Test | Observed Result |
|---|---|
| Nginx default page | HTTP 200 |
| Missing Nginx resource | HTTP 404 |
| Unsupported POST | HTTP 405 |
| Closed local port | Connection refused |
| Python server running | HTTP 200 |
| TLS connection | TLS 1.3 |
| Invalid certificate hostname | Hostname mismatch |
| Local Nginx | HTTP/1.1 |
| example.com via Curl | HTTP/2 |
| example.com via Chrome | HTTP/3 |

## Outcome

Developed practical skills in observing HTTP traffic, validating TLS connections, and diagnosing common networking and application-layer errors.
