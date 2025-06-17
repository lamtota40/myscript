#!/bin/bash

sudo apt update
sudo apt install fail2ban -y
sudo systemctl status fail2ban

cat > /etc/fail2ban/jail.d/ssh.local <<'EOF'
[sshd]
enabled = true
port = 22
logpath = /var/log/auth.log
maxretry = 1
findtime = 86400
bantime = -1
EOF

cat > /etc/fail2ban/jail.d/tigervnc.local <<'EOF'
[tigervnc]
enabled = true
port = 5901
filter = tigervnc
logpath = /root/.vnc/ubuntu:1.log
maxretry = 1
findtime = 86400
bantime = -1
EOF

cat > /etc/fail2ban/filter.d/tigervnc.conf <<'EOF'
[Definition]
failregex = ^.*Connections: closed: <HOST>::\d+ \(Authentication failure\)
ignoreregex =
EOF

sudo systemctl restart fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
sudo iptables -L -n
