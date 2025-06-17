#!/bin/bash

sudo apt update
sudo apt install fail2ban -y
sudo systemctl status fail2ban

cat > /etc/fail2ban/jail.d/sshd.local <<'EOF'
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

cat > /etc/fail2ban/filter.d/xrdp.conf <<'EOF'
[Definition]
failregex = .*login failed for user:.*
ignoreregex =
EOF

cat > /etc/fail2ban/jail.d/xrdp.local <<'EOF'
[xrdp]
enabled = true
port = 3389
filter = xrdp
logpath = /var/log/xrdp.log
maxretry = 1
findtime = 86400
bantime = -1
EOF

sudo systemctl restart fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
sudo iptables -L -n
