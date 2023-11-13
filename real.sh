#!/bin/bash
#!/bin/bash
# Update Packages List
echo "Updating package list..."
sudo apt update
# Upgrade Installed Packages
echo "Upgrading installed packages..."
sudo apt upgrade -y
# Distribution Upgrade
echo "Performing distribution upgrade..."
sudo apt dist-upgrade -y
# Remove Unused Packages
echo "Removing unused packages..."
sudo apt autoremove -y
# Clean Cache
echo "Cleaning cache..."
sudo apt clean
echo "Operation completed."
Install Firewall
echo "Installing UFW Firewall..."
sudo apt install ufw -y
Enable Firewall
echo "Enabling UFW Firewall..."
sudo ufw enable
Allow HTTPS Traffic
echo "Allowing HTTPS traffic..."
sudo ufw allow 443/tcp
sudo ufw allow 443/udp
sudo ufw allow 80/tcp
Allow Custom Ports
echo "Allowing custom ports..."
sudo ufw allow 5433/tcp
Remove Rule
echo "Removing rule..."
sudo ufw delete allow 22/tcp
Reload Firewall
echo "Reloading UFW Firewall..."
sudo ufw reload
Check Status
echo "Checking UFW status..."
sudo ufw status
Edit SSH Config - this requires manual intervention and cannot be automated in a script
echo "Editing sshd_config file..."
sudo nano /etc/ssh/sshd_config
Restart SSH
#echo "Restarting SSH..."
#sudo service ssh restart
echo "Operation completed."
Change SSH Port
echo "Changing SSH port..."
sudo sed -i 's/#Port 22/Port 5433/g' /etc/ssh/sshd_config
Restart SSH
echo "Restarting SSH..."
sudo service ssh restart
# Install Xray Service
echo "Installing Xray service..."
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
# Install OpenSSL
echo "Installing OpenSSL..."
sudo apt-get install openssl -y
# Generate Hex Key
echo "Generating Hex key..."
openssl rand -hex 8 | sudo tee /root/hex_key.txt
# Navigate to Bin
echo "Navigating to /usr/local/bin/..."
cd /usr/local/bin/
# Xray Key Generation
echo "Generating Xray key..."
./xray x25519 | sudo tee /root/xray_key.txt
# Xray UUID Generation
echo "Generating Xray UUID..."
./xray uuid | sudo tee /root/xray_uuid.txt
echo "Operation completed."
# Remove Xray Binary
echo "Removing Xray binary..."
sudo rm /usr/local/bin/xray
# Download Go Binary
echo "Downloading Go binary..."
curl -sLo go.tar.gz https://go.dev/dl/$(curl -sL https://golang.org/VERSION?m=text|head -1).linux-amd64.tar.gz
# Remove Existing Go
echo "Removing existing Go..."
rm -rf /usr/local/go
# Extract Go Binary
echo "Extracting Go binary..."
tar -C /usr/local/ -xzf go.tar.gz
# Remove Tarball
echo "Removing tarball..."
rm go.tar.gz
# Set Go Path
echo "Setting Go Path..."
echo -e "export PATH=$PATH:/usr/local/go/bin" > /etc/profile.d/go.sh
# Load Go Profile
echo "Loading Go profile..."
source /etc/profile.d/go.sh
# Check Go Version
echo "Checking Go version..."
go version
# Install Git
echo "Installing Git..."
apt install -y git
# Clone Xray Repo
echo "Cloning Xray repository..."
git clone https://github.com/XTLS/Xray-core.git
cd Xray-core
# Download Go modules
echo "Downloading Go modules..."
go mod download
# Set Go build environment variables
echo "Setting Go build environment variables..."
go env -w CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOAMD64=v2
# Build Xray
echo "Building Xray..."
go build -v -o xray -trimpath -ldflags "-s -w -buildid=" ./main
cd ..
echo "Operation completed."
#!/bin/bash
# Copy Linux Binary
echo "Copying Linux binary..."
cp -f Xray-core/xray /usr/local/bin/
chmod +x /usr/local/bin/xray
# Remove GeoIP Data
echo "Removing GeoIP data..."
sudo rm /usr/local/share/xray/geoip.dat
# Remove Geosite Data
echo "Removing Geosite data..."
sudo rm /usr/local/share/xray/geosite.dat
# Navigate to Xray Share
echo "Navigating to Xray share..."
cd /usr/local/share/xray/
# Download new GeoIP and Geosite data
echo "Downloading new GeoIP and Geosite data..."
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202311102208/geoip.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202311102208/geosite.dat
wget https://github.com/us254/geoip/releases/download/v2.7/ir.dat
echo "Operation completed."
#!/bin/bash
# Add the configuration to sysctl.conf
echo "Updating sysctl.conf..."
sudo bash -c 'cat <<EOF >> /etc/sysctl.conf
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_slow_start_after_idle = 0
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_sack = 1  # Enable
net.ipv4.tcp_dsack = 1  # Enable Double SACK
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_max_orphans = 3276800
EOF'
# Apply the changes
echo "Applying sysctl changes..."
sudo sysctl -p
echo "Operation completed."
