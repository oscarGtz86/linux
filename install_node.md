# Installing Node.js

Installing Node.js in Debian/Ubuntu distro.

https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions

# Instructions
```bash
# Get repo
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# Install package node and npm
$ sudo apt-get install -y nodejs
```

## Enable port 80 in node applications
```bash
# Install libcap
sudo apt install libcap2-bin
# Setup node to be able to use port 80
sudo setcap cap_net_bind_service=+ep `readlink -f \`which node\``
```

## Installing pm2 process manager
#### 1. Install package:
```bash
# Install package globally
sudo npm install pm2 -g

# Validate installation
pm2 ls

# Enable startup script
pm2 startup
```

Validate output to find command:
```
[PM2] Init System found: systemd
[PM2] To setup the Startup Script, copy/paste the following command:
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
```
#### 2. In this case comman is:
```
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
```
#### 3 Start and daemonize application:
```bash
# Change to app home
cd <APP_HOME>

# Start app
pm2 start app.js

# Validate app
pm2 ls
```

Sample output:
| id | name | namespace | version | mode | pid | uptime | ↺ | status | cpu | mem    | user   | watching |
|----|------|-----------|---------|------|-----|--------|---|--------|-----|--------|---------|----------|
|  0 | app  | default   | 1.00    | fork | 465 | 20s    | 0 | online |  0% | 58.1mb | ubuntu  | disable  |

### 4. Save current process list
```bash
# Save list
pm2 save
```

### 5. Review logs
```bash
# Check logs
pm2 logs
```

### 6. Monitoring and performance
```bash
# Check monitor
pm2 monit
```

### 7. Stop/start
```bash
# Stop
pm2 stop <ID>

# Start
pm2 start <ID>
```