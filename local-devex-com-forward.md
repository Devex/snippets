# Use local.devex.com to access your Vagrant Box

If you want to access your vagrant box via local.devex.com, you have to do the steps described below.

## Linux

### 1. Define local.devex.com

Add the following line to `/etc/hosts`:
```
127.0.0.1  local.devex.com
```

### 2. Make https://local.devex.com work without a port

Run the following commands as root to forward port 433 (https default) to 8443 (vagrant port for https):
```
sysctl net.ipv4.ip_forward=1
iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
iptables -t nat -I OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-ports 8443
iptables -t nat -A POSTROUTING -j MASQUERADE
```
