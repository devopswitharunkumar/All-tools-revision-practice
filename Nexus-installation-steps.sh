#!/bin/bash

set -e

echo "===================================="
echo " Nexus Installation Started"
echo "===================================="

# Update system
echo "Updating system packages..."
# dnf update -y

# Install Java and required packages
echo "Installing Java and utilities..."
dnf install -y java-17-openjdk java-17-openjdk-devel wget tar unzip

echo "Java Version:"
java -version

# Create Nexus user
echo "Creating Nexus user..."
if ! id nexus &>/dev/null; then
    useradd -r -m -d /opt/nexus -s /bin/bash nexus
fi


# Download Nexus
cd /opt

echo "Downloading Nexus..."
wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/nexus-3.83.1-03-linux-x86_64.tar.gz

# Extract Nexus
echo "Extracting Nexus..."
tar -xzf nexus.tar.gz

# Rename extracted folder
mv nexus-3.83.1-03 nexus

# Create Sonatype work directory
echo "Creating sonatype-work directory..."
mkdir -p /opt/sonatype-work

# Set ownership
echo "Setting permissions..."
chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work

# Configure Nexus to run as nexus user
echo 'run_as_user="nexus"' > /opt/nexus/nexus-3.83.1-03/bin/nexus.rc


# Create systemd service
cat > /etc/systemd/system/nexus.service <<EOF

[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking

User=nexus
Group=nexus

LimitNOFILE=65536

Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk"

ExecStart=/opt/nexus/nexus-3.83.1-03/bin/nexus start
ExecStop=/opt/nexus/nexus-3.83.1-03/bin/nexus stop

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
echo "Reloading systemd..."
systemctl daemon-reload

# Enable Nexus
echo "Enabling Nexus service..."
systemctl enable nexus

# Start Nexus
echo "Starting Nexus..."
systemctl start nexus

echo
echo "Waiting 30 seconds for Nexus to start..."
sleep 30

echo
echo "===================================="
echo " Nexus Service Status"
echo "===================================="
systemctl status nexus --no-pager

echo
echo "===================================="
echo " Nexus Installation Completed!"
echo "===================================="

echo
echo "Initial Admin Password:"
cat /opt/sonatype-work/nexus3/admin.password