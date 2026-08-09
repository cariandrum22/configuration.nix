# Even Terminal over WireGuard

`chetter` exposes WireGuard on UDP port 51820. Even Terminal is reachable only from the registered
iPhone peer at `10.77.0.1:3456`.

The generated iPhone configuration is stored outside Git with mode `0600`:

```text
~/.config/wireguard/chetter-even-iphone.conf
```

Import that file into the WireGuard app on the iPhone. It routes only `10.77.0.1/32`; it does not
route the AWS VPC or general Internet traffic.

## Start Even Terminal

The application token is stored outside Git with mode `0600`:

```text
~/.config/even-terminal/token
```

Start Even Terminal interactively as `claude`, selecting the WireGuard interface explicitly:

```bash
even-terminal \
  --interface wg0 \
  --port 3456 \
  --token "$(<~/.config/even-terminal/token)" \
  --provider codex \
  --cwd "$HOME/Codex/github.com/cariandrum22/configuration.nix"
```

Verify that it listens only on the WireGuard address:

```bash
ss -ltnp 'sport = :3456'
```

The expected local address is `10.77.0.1:3456`, not `0.0.0.0:3456` or the EC2 address.

## Validate connectivity

After deploying the NixOS configuration and allowing UDP/51820 in the AWS Security Group:

```bash
ip address show wg0
sudo wg show wg0
```

Connect the Even app to the direct address first:

```text
http://10.77.0.1:3456
```

Only after direct-IP validation, create a DNS record such as
`even.chetter.stultitia.me -> 10.77.0.1` and switch the app to that hostname. TCP/3456 must not be
added to the EC2 Security Group.
