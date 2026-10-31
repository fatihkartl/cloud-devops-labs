# Day 09 — Packet Analysis & Network Troubleshooting

Hands-on networking lab using **tcpdump**, **Wireshark**, **Curl**, and **dig** to observe TCP connections, HTTP/HTTPS traffic, DNS resolution, and common network errors.

## Lab Environment

- Ubuntu on WSL2 / Windows 11
- Nginx reverse proxy on `127.0.0.1:18080`
- Two Python HTTP backends on ports `8000` and `8001`
- tcpdump, Wireshark, Curl 8.18.0, dig

> Port `8080` is reserved for another application. This lab uses **18080**.

## What I Practiced

1. Captured TCP **SYN → SYN/ACK → ACK** and **FIN/ACK** connection teardown.
2. Inspected HTTP GET requests and `200 OK` responses as plaintext.
3. Verified that Nginx creates **separate TCP connections** to clients and upstream backends.
4. Captured HTTPS traffic and inspected TLS **ClientHello**, **ServerHello**, SNI, and TLS 1.3 negotiation.
5. Compared plaintext HTTP streams with encrypted HTTPS streams using **Follow TCP Stream**.
6. Identified **HTTP 404** packets and **TCP RST** responses to a closed port.
7. Inspected **DNS queries/responses**, Transaction IDs, A records, and TTL values.
8. Correlated DNS resolution and HTTP requests in a single packet capture.
9. Reviewed TCP and UDP traffic using **Statistics → Conversations**.
10. Reproduced and classified **NXDOMAIN**, **Connection refused**, and **HTTP 404**.

## Architecture

```text
Curl / Browser
     |
     | HTTP/1.1 (TCP :18080)
     v
  Nginx reverse proxy
     |                         
     +-- HTTP/1.0 --> Python :8000
     +-- HTTP/1.0 --> Python :8001
```

## Reproduce Key Captures

Run `tcpdump` in one WSL terminal; generate traffic in another. Stop the capture with `Ctrl+C`.

### HTTP and TCP handshake

```bash
sudo tcpdump -i lo -nn -A -s 0 'tcp port 18080'

# Other terminal
curl --http1.1 -H 'Connection: close' http://127.0.0.1:18080/
```

### Reverse proxy: both TCP connections

```bash
sudo tcpdump -i lo -nn -A -s 0 \
  'tcp and (port 18080 or port 8000 or port 8001)'
```

### HTTP capture for Wireshark

```bash
sudo tcpdump -i lo -nn -s 0 -w ~/day09-http.pcap 'tcp port 18080'
```

### HTTPS / TLS capture

```bash
sudo tcpdump -i any -nn -s 0 -w ~/day09-https.pcap 'tcp port 443'

# Other terminal
curl -4 --http1.1 -sS -o /dev/null \
  -w 'HTTP status: %{http_code}\n' https://example.com/
```

### DNS capture

```bash
sudo tcpdump -i any -nn -s 0 -w ~/day09-dns.pcap \
  'udp port 53 or tcp port 53'

# Other terminal
dig @1.1.1.1 example.org A +noall +answer
```

### DNS followed by HTTP

```bash
sudo tcpdump -i any -nn -s 0 -w ~/day09-dns-http.pcap \
  'port 53 or tcp port 80'

# Other terminal
IP=$(dig @1.1.1.1 example.org A +short | head -n 1)
curl -4 -i --http1.1 --max-time 10 \
  --resolve "example.org:80:$IP" http://example.org/
```

## Wireshark Display Filters

| Purpose | Filter |
|---|---|
| Initial TCP SYN | `tcp.flags.syn == 1 && tcp.flags.ack == 0` |
| TLS ClientHello | `tls.handshake.type == 1` |
| TLS ServerHello | `tls.handshake.type == 2` |
| TLS 1.3 outer Application Data | `tls.record.opaque_type == 23` |
| HTTP 404 response | `http.response.code == 404` |
| TCP RST | `tcp.flags.reset == 1` |
| DNS packets | `dns` |
| DNS and HTTP packets | `dns || http` |

**Note:** `tls.record.content_type == 23` did not match the TLS 1.3 packets in this capture; `tls.record.opaque_type == 23` worked.

## Observed Results

| Experiment | Result |
|---|---|
| Direct Python and proxied Nginx after recovery | HTTP `200` |
| Client → Nginx | HTTP/1.1 on port `18080` |
| Nginx → Python | Separate TCP connection; HTTP/1.0 on port `8001` |
| HTTPS negotiation | TLS **1.3** selected in ServerHello |
| TLS ClientHello SNI | `example.com` visible |
| HTTPS Follow TCP Stream | Encrypted data, no plaintext HTTP request |
| HTTP Follow TCP Stream | Readable `GET /`, `200 OK`, and HTML body |
| Missing HTTP resource | `404 Not Found` |
| Closed TCP port `59998` | `Connection refused`, TCP RST |
| DNS A records for `example.org` | `172.66.157.237`, `104.20.26.136` at capture time |
| DNS query Transaction ID | `0x379b` (`14235`) |
| DNS TTL observed | `94` seconds |
| Invalid DNS name `day09-test.invalid` | `NXDOMAIN` |

The IP addresses and DNS TTL reflect the **October 31, 2026** capture and may change on later runs.

## Troubleshooting Principle

```text
DNS failed?          → Check resolver and DNS response (e.g., NXDOMAIN)
TCP failed?          → Check SYN/RST and port listeners (Connection refused)
HTTP request failed? → Inspect status code and application/proxy logs (404, 502, 504)
TLS failed?          → Inspect handshake, hostname, and certificate validation
```

**Takeaway:** Diagnose network failures from protocol evidence, not from the browser error message alone.

> **Security:** Raw PCAP files can expose IP addresses, domains, cookies, and plaintext credentials. Do not upload captures to public repositories without reviewing and sanitizing them.
