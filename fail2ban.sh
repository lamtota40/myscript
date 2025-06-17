sudo apt update
sudo apt install fail2ban -y
sudo systemctl status fail2ban
sudo nano /etc/fail2ban/jail.d/ssh.local
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
findtime = 300
bantime = 600
sudo systemctl restart fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
sudo iptables -L -n
