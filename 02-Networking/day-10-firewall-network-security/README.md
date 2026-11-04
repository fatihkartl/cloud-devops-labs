# Networking Day 10 — Firewall & Network Security

Hands-on Linux firewall and SSH hardening exercises using **Ubuntu on WSL2**, `nftables`, OpenSSH, systemd journal, and Fail2ban.

## Objectives

- Distinguish listening sockets from actual network reachability.
- Test `DROP`, `REJECT`, conntrack states, ordered rules, and IP allowlists.
- Capture denied packets and analyze kernel logs/TCP retransmissions.
- Set up a **localhost-only** OpenSSH server with ED25519 authentication.
- Debug SSH authentication, harden server limits, and test Fail2ban → nftables enforcement.
- Audit and clean up temporary lab services and rules.

## Lab topology

| Endpoint | Purpose |
|---|---|
| `127.0.0.1:19090` | Python HTTP firewall target |
| `127.0.0.1:2222` | SSH + Fail2ban lab |
| `127.0.0.1:2223` | Hardened SSH configuration |
| `127.0.0.1:2224` | Isolated MaxStartups test |
| `127.0.0.1` | Allowlisted test source |
| `127.0.0.2` | Blocked test source |

> **Safety:** All test servers were bound to loopback. Temporary nftables rules targeted only lab ports. Do not apply these rules blindly on production or remote servers.

## 1. Port and firewall discovery

```bash
sudo ss -lntup
sudo ufw status verbose
sudo nft list ruleset
```

Initial findings: UFW inactive; nftables ruleset empty; Nginx listening on `:80` and `:18080`. A listening service is not necessarily reachable from the public internet, particularly under WSL2/Windows Firewall.

## 2. Local HTTP firewall test

```bash
mkdir -p ~/day10-firewall-lab
echo '<h1>Day 10 Firewall Test OK</h1>' > ~/day10-firewall-lab/index.html
python3 -m http.server 19090 --bind 127.0.0.1 --directory ~/day10-firewall-lab
```

In another terminal:

```bash
curl -i http://127.0.0.1:19090/
```

We validated:

- `drop` → connection timeout while the service remains running.
- `reject with tcp reset` → immediate refusal and TCP RST visible in `tcpdump`.
- `ct state new` vs `ct state established,related` → distinct packet counters.
- `jump` to a per-service ACL → default-deny design without changing the host-wide input policy.
- `nft insert rule` → permit before the final drop rule.
- `ip saddr` source matching → `127.0.0.1` accepted, `127.0.0.2` denied.

Example isolated rule:

```bash
sudo nft add table inet day10_lab
sudo nft 'add chain inet day10_lab input { type filter hook input priority 0; policy accept; }'
sudo nft add rule inet day10_lab input iifname lo ip daddr 127.0.0.1 tcp dport 19090 drop
sudo nft delete table inet day10_lab
```

## 3. Packet and kernel logging

```bash
sudo nft 'add rule inet day10_lab input iifname "lo" ip saddr 127.0.0.2 ip daddr 127.0.0.1 tcp dport 19090 counter log prefix "DAY10_BLOCK: " drop'
sudo dmesg | grep DAY10_BLOCK
```

The logs showed three SYN attempts from the **same source port** (`34076`) approximately one second apart: TCP SYN retransmissions, not three separate users.

## 4. SSH key authentication and troubleshooting

```bash
ssh-keygen -t ed25519 -a 64 -f ~/.ssh/day10_lab_ed25519 -C 'day10-ssh-lab'
ssh-keygen -lf ~/.ssh/day10_lab_ed25519.pub
```

The lab server used a dedicated `sshd_config` with `Port 2222`, `ListenAddress 127.0.0.1`, `PubkeyAuthentication yes`, `PasswordAuthentication no`, `PermitRootLogin no`, and `AllowUsers fatih`.

Debugging a failed login via `ssh -vvv` showed the server **accepted the public key**, but the client could not sign until the **private-key passphrase** was entered. Authentication was subsequently confirmed with:

```text
REMOTE_USER=fatih
SSH_CONNECTION=127.0.0.1 41702 127.0.0.1 2222
```

## 5. Fail2ban detection and firewall enforcement

- Switched from a bare `sshd -E` log file to time-stamped **systemd journal** records.
- Tested SSH filters with `fail2ban-regex`.
- Created an isolated jail for port `2222` with `maxretry=3`, `findtime=5m`, `bantime=1m`, and `ignoreip=127.0.0.1/32`.
- Confirmed `127.0.0.2` was automatically banned after invalid SSH attempts.
- Verified the installed nftables action created an IP set and a per-port `REJECT` rule.

Observed nftables action:

```nft
table inet f2b-table {
  set addr-set-day10-sshd {
    type ipv4_addr
    elements = { 127.0.0.2 }
  }
  chain f2b-chain {
    type filter hook input priority filter - 1; policy accept;
    tcp dport 2222 ip saddr @addr-set-day10-sshd reject with icmp port-unreachable
  }
}
```

**Controlled comparison:** With the SSH listener running and no ban, both loopback source addresses connected. With the ban active, `127.0.0.1` connected and `127.0.0.2` was blocked.

## 6. SSH hardening tests

| Setting | Lab value | Observed result |
|---|---|---|
| `MaxAuthTries` | `3` | Third rejected key caused `Too many authentication failures` |
| `LoginGraceTime` | `30` seconds | Unauthenticated TCP connection closed; server logged timeout |
| `MaxStartups` | `5:30:20` | 25 attempts: **11 SSH banners, 14 rejects/closures**; server logs explicitly stated `Maxstartups` |

The MaxStartups test ran on isolated port `2224`, with `PerSourcePenalties no` in that test config to isolate the effect. Receiving an SSH banner **does not mean authentication succeeded**.

## 7. Final security audit

```bash
sudo ss -lntp '( sport = :2222 or sport = :2223 or sport = :2224 or sport = :19090 )'
sudo nft -a list ruleset
sudo systemctl is-active fail2ban
sudo fail2ban-client status
```

**Final observed state:** No listeners on the temporary lab ports, empty nftables ruleset, Fail2ban service `active`, only the distro-provided `sshd` jail enabled. Nginx `:80/:18080` were outside the final filtered-port check.

### Key takeaways

1. `Connection refused` can indicate no listener **or** a firewall `REJECT`; verify both.
2. Firewall rule order and conntrack state matter.
3. OpenSSH's per-source penalties are independent from Fail2ban.
4. `MaxAuthTries`, `LoginGraceTime`, and `MaxStartups` defend against different behaviors.
5. A running Fail2ban service alone does not prove that any particular SSH service is currently protected.

**Documentation:** Full Turkish Obsidian notes cover all commands, exact observations, troubleshooting steps, and review questions.
