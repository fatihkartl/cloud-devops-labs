# Networking Day 04 — Routing & NAT

## Goal
Understand Linux routing, static routes, NAT/PAT, SNAT/DNAT, port forwarding and CGNAT.

## Topics
- Routing tables and longest prefix match
- Default gateway and connected routes
- Static routing
- NAT, PAT, SNAT and DNAT
- Port forwarding and CGNAT
- TCP port and HTTP troubleshooting

## Commands

    ip -4 route
    ip route get 8.8.8.8
    systemctl is-active nginx
    sudo ss -ltnp '( sport = :80 )'
    curl -I --max-time 5 http://127.0.0.1

## Lab Results

WSL Ubuntu:
- IPv4: `172.26.210.222/20`
- Default gateway: `172.26.208.1`
- Nginx: Active
- TCP port 80: Listening on IPv4 and IPv6
- Local HTTP response: `200 OK`

CGNAT investigation:
- Router WAN: `100.77.197.252`
- Observed external IPv4: `109.228.206.95`
- Conclusion: ISP-side CGNAT

## What I Learned
A valid route does not guarantee reachability. NAT changes addressing information, while firewall rules, service state and CGNAT can independently affect connectivity.