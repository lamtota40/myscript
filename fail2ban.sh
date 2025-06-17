sudo apt update
sudo apt install fail2ban -y
sudo systemctl status fail2ban
cat > /etc/fail2ban/jail.d/ssh.local <<'EOF'
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 2
findtime = 86400
bantime = -1
EOF

sudo systemctl restart fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
sudo iptables -L -n
