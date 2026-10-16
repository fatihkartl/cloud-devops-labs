# Networking Day 02 — IP Addressing

## Goal
Understand IPv4, IPv6, CIDR basics, private/public addressing, DHCP, NAT, CGNAT and routing.

## Topics
- IPv4: 32-bit addresses and octets
- IPv6: 128-bit addresses and hextets
- Network ID, Host ID and `/24` prefixes
- RFC 1918 private address ranges
- Loopback, link-local and CGNAT addresses
- Static IP, dynamic IP and DHCP reservation
- IPv4 and IPv6 route inspection

## Linux Commands

    ip -4 -br addr
    ip -6 -br addr
    ip -4 route
    ip -6 route
    ip route get 1.1.1.1
    ip -4 route get 127.0.0.1
    ip -6 route get ::1

## Lab Results

WSL Ubuntu:
- IPv4: `172.26.210.222/20`
- IPv4 gateway: `172.26.208.1`
- IPv6: Link-local address on `eth0`
- IPv6 default route: Not configured

## What I Learned

IPv4 and IPv6 have different address structures, but both require routing to reach remote networks. A link-local IPv6 address alone does not provide global IPv6 connectivity.