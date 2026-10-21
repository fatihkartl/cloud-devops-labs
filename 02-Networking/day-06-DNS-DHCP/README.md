# Networking Day 06 — DNS & DHCP

## Goal

Understand DNS resolution, DNS records, caching, DHCP address allocation, lease management, and network troubleshooting.

## Topics Covered

- Recursive Resolver, Root, TLD, and Authoritative DNS
- DNS records: A, AAAA, CNAME, MX, NS, TXT
- DNS caching and TTL
- DNS tracing and troubleshooting
- DHCP DORA process
- DHCP lease renewal, T1 and T2
- Dynamic IP, Static IP, and DHCP Reservation
- Windows and WSL2 network configuration

## Commands Used

    dig example.com A
    dig example.com AAAA
    dig www.python.org CNAME
    dig gmail.com MX
    dig example.com NS
    dig +short example.com A
    dig +noall +answer +stats example.com A

    dig . NS +time=2 +tries=1
    dig @1.1.1.1 . NS +time=2 +tries=1
    dig +trace @1.1.1.1 example.com A

    ip -4 -br addr
    ip -4 route
    cat /etc/resolv.conf

Windows PowerShell:

    ipconfig /all

## Lab Results

### DNS

- Queried A, AAAA, CNAME, MX, and NS records.
- Observed TTL decrease from 104 to 99 seconds after five seconds.
- Default WSL DNS resolver: `10.255.255.254`.
- Diagnosed a timeout with the default resolver for root NS queries.
- Successfully completed DNS tracing using `@1.1.1.1`.
- Observed Root → TLD → Authoritative DNS resolution.

### DHCP and Network Configuration

Windows Ethernet:

- IPv4: `192.168.1.7/24`
- Gateway: `192.168.1.1`
- DHCP Server: `192.168.1.1`
- Lease duration: approximately 24 hours

WSL Ubuntu:

- IPv4: `172.26.210.222/20`
- Network: `172.26.208.0/20`
- Gateway: `172.26.208.1`
- DNS resolver: `10.255.255.254`

## Key Takeaways

DNS resolves names and other DNS records, while DHCP provides network configuration.

A successful DNS lookup does not guarantee network connectivity or application availability.

DNS TTL impacts how long cached records remain valid.

The network address, host IP, and default gateway represent different concepts.