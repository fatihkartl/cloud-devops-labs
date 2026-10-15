# Networking Day 01 - Network Fundamentals

## Goal
Understand LAN/WAN, OSI, TCP/IP, packet encapsulation, IP addressing, ports and routing.

## Commands

    ip -br addr
    ip route
    ip route get 1.1.1.1
    ip route get 127.0.0.1
    curl -I http://127.0.0.1
    ss -tn

## Key Ideas
- Switches forward Ethernet frames using MAC addresses.
- Routers forward IP packets between networks.
- OSI has 7 layers; the common TCP/IP model has 4.
- TCP data units are segments, IP data units are packets, Ethernet data units are frames.
- TCP connections use source and destination IP addresses and ports.
- Default gateways handle destinations without more specific routes.
- Loopback traffic stays within the local machine.

## Practice
Inspected WSL network interfaces and routing decisions, compared localhost with external destinations, and analyzed TCP/IP encapsulation.