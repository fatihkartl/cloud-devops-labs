# Networking Day 05 — TCP, UDP & Ports

## Goal

Understand TCP/UDP communication, connection establishment, sequence numbers, acknowledgments, retransmission, TCP states, and socket identification.

## Topics Covered

- TCP vs UDP
- TCP Three-Way Handshake
- Sequence and Acknowledgment Numbers
- Cumulative ACK and Retransmission
- RTO and Fast Retransmit
- TCP Connection States
- FIN, RST, and TIME-WAIT
- TCP 4-Tuple and 5-Tuple
- Linux Socket Troubleshooting

## Linux Commands

    sudo ss -ltnp '( sport = :80 )'
    sudo ss -lunp
    ss -tn state established
    sudo ss -tnp '( sport = :80 or dport = :80 )'
    sudo ss -tan '( sport = :80 or dport = :80 )'

## Hands-on Lab

Created a TCP connection to Nginx using Python:

    import socket
    s = socket.create_connection(("127.0.0.1", 80))
    print(s.getsockname())
    print(s.getpeername())
    s.close()

### Observations

- Client endpoint: `127.0.0.1:43004`
- Server endpoint: `127.0.0.1:80`
- Two ESTABLISHED socket entries observed
- Nginx continued listening on TCP port 80
- TIME-WAIT was not observed during the final check

## Key Takeaways

TCP connections are identified by a unique 4-tuple. TCP flags and states are different concepts. ACK numbers identify the next expected byte, and missing data can be recovered through retransmission.

A listening TCP socket, an established connection, and a successful HTTP response represent different layers of connectivity.