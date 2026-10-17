# Networking Day 03 — Subnetting & CIDR

## Goal
Learn IPv4 subnet calculations, CIDR, subnet masks, broadcast addresses, usable hosts, and VLSM.

## Topics
- CIDR prefixes and subnet masks
- Network and broadcast address calculation
- Block size method
- First and last usable IP addresses
- `/20`, `/24`, `/25`, `/26`, `/27`, `/28` subnetting
- VLSM subnet allocation
- Subnet overlap prevention
- AWS VPC reserved IP addresses

## Linux Commands

    ip -4 -br addr show dev eth0
    ip -4 route

## Final Lab

Analyzed WSL IPv4 network:

    IP:         172.26.210.222/20
    Mask:       255.255.240.0
    Network:    172.26.208.0
    Broadcast:  172.26.223.255
    First Host: 172.26.208.1
    Last Host:  172.26.223.254
    Total IPs:  4096
    Usable IPs: 4094

Verified subnet calculations using Python's built-in `ipaddress` module.

## VLSM Practice

Designed non-overlapping subnets inside `10.10.10.0/24`:

| Department | Subnet | Usable Hosts |
|---|---|---:|
| Software | 10.10.10.0/26 | 62 |
| HR | 10.10.10.64/27 | 30 |
| Management | 10.10.10.96/28 | 14 |

## Result
Successfully calculated subnet boundaries, usable host ranges, and VLSM allocations without relying on online subnet calculators.