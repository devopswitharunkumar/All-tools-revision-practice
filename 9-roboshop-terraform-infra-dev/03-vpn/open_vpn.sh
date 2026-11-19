
#!/bin/bash

set -e

LOG_FILE="/var/log/openvpn-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "========== OpenVPN Bootstrap Started : $(date) =========="

MARKER="/var/lib/openvpn-fips-disabled"

AFTER_SCRIPT="/usr/local/bin/openvpn-after-reboot.sh"
SERVICE_FILE="/etc/systemd/system/openvpn-after-reboot.service"

FIREWALL_SCRIPT="/usr/local/sbin/openvpn-mongodb-ssh-firewall.sh"
FIREWALL_SERVICE="/etc/systemd/system/openvpn-mongodb-ssh-firewall.service"

############################################################
# Configure Persistent MongoDB SSH Firewall
############################################################

configure_mongodb_ssh_firewall() {

    echo "Configuring persistent MongoDB SSH firewall rule..."

    cat > "$FIREWALL_SCRIPT" <<'FW_EOF'
#!/bin/bash

set -e

IPTABLES=$(command -v iptables)

if [ -z "$IPTABLES" ]; then
    echo "ERROR: iptables command not found"
    exit 1
fi

echo "Waiting for OpenVPN forwarding chain..."

for i in {1..30}
do
    if $IPTABLES -L OPENVPN_INSTALL_FORWARD -n >/dev/null 2>&1
    then
        break
    fi

    sleep 2
done

if ! $IPTABLES -L OPENVPN_INSTALL_FORWARD -n >/dev/null 2>&1
then
    echo "ERROR: OPENVPN_INSTALL_FORWARD chain not found"
    exit 1
fi

echo "Checking MongoDB SSH firewall rule..."

if ! $IPTABLES -C OPENVPN_INSTALL_FORWARD \
    -i tun+ \
    -s 10.8.0.0/24 \
    -d 10.0.21.94/32 \
    -p tcp --dport 22 \
    -j ACCEPT 2>/dev/null
then

    echo "Adding MongoDB SSH ACCEPT rule..."

    $IPTABLES -I OPENVPN_INSTALL_FORWARD 1 \
        -i tun+ \
        -s 10.8.0.0/24 \
        -d 10.0.21.94/32 \
        -p tcp --dport 22 \
        -j ACCEPT

else

    echo "MongoDB SSH rule already exists."

fi

echo "MongoDB SSH firewall rule configured successfully."

FW_EOF

    chmod +x "$FIREWALL_SCRIPT"

    cat > "$FIREWALL_SERVICE" <<'SERVICE_EOF'
[Unit]
Description=Persistent OpenVPN MongoDB SSH Firewall Rule
After=network-online.target openvpn-server@server.service
Requires=openvpn-server@server.service

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/openvpn-mongodb-ssh-firewall.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICE_EOF

    chmod 644 "$FIREWALL_SERVICE"

    systemctl daemon-reload

    echo "Persistent firewall script and service created."

}

############################################################
# Create Persistent Firewall Configuration
############################################################

configure_mongodb_ssh_firewall

############################################################
# Disable FIPS if enabled
############################################################

if [ ! -f "$MARKER" ]; then

    if [ "$(cat /proc/sys/crypto/fips_enabled)" = "1" ]; then

        echo "FIPS Enabled"

        fips-mode-setup --disable

        ####################################################
        # Script to Continue Installation After Reboot
        ####################################################

        cat > "$AFTER_SCRIPT" <<'AFTER_EOF'
#!/bin/bash

set -e

LOG_FILE="/var/log/openvpn-install.log"
exec >> "$LOG_FILE" 2>&1

echo "========== Continuing After Reboot =========="

echo "Waiting for network..."

NETWORK_READY=false

for i in {1..30}
do

    if curl -fsS https://raw.githubusercontent.com >/dev/null 2>&1
    then
        NETWORK_READY=true
        break
    fi

    sleep 10

done

if [ "$NETWORK_READY" != "true" ]
then
    echo "Network never became ready"
    exit 1
fi

echo "Setting crypto policy..."

update-crypto-policies --set DEFAULT

echo "Current Crypto Policy:"
update-crypto-policies --show

echo "Checking FIPS..."

fips-mode-setup --check || true

cat /proc/sys/crypto/fips_enabled

if [ "$(cat /proc/sys/crypto/fips_enabled)" != "0" ]
then
    echo "FIPS still enabled"
    exit 1
fi

############################################################
# Download OpenVPN Installer
############################################################

echo "Downloading installer..."

cd /root

curl -fO https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh

chmod +x openvpn-install.sh

############################################################
# OpenVPN Variables
############################################################

export AUTO_INSTALL=y

TOKEN=$(curl -sX PUT \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
http://169.254.169.254/latest/api/token)

export ENDPOINT=$(curl -s \
-H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/public-ipv4)

export APPROVE_INSTALL=y
export APPROVE_IP=y
export IPV6_SUPPORT=n
export CLIENT_IPV4=y
export CLIENT_IPV6=n
export IPV4_SUBNET_CHOICE=1
export PORT_CHOICE=1
export PROTOCOL=tcp
export DNS=adguard
export MULTI_CLIENT=n
export MTU_CHOICE=1
export AUTH_MODE=pki
export COMPRESSION_ENABLED=n
export CUSTOMIZE_ENC=n
export CLIENT=arunvpn
export CLIENT_CERT_DURATION_DAYS=3650
export PASS=1

############################################################
# Install OpenVPN
############################################################

echo "Installing OpenVPN..."

./openvpn-install.sh install

############################################################
# Verify OVPN Profile
############################################################

echo "OVPN profile created at: /root/arunvpn.ovpn"

if [ -f /root/arunvpn.ovpn ]; then

    echo "OVPN file generated successfully."
    ls -l /root/arunvpn.ovpn

else

    echo "ERROR: arunvpn.ovpn was not created."
    exit 1

fi

############################################################
# Restart OpenVPN
############################################################

echo "Restarting OpenVPN..."

systemctl enable openvpn-server@server

systemctl restart openvpn-server@server || true

echo "Checking OpenVPN status..."

systemctl status openvpn-server@server --no-pager || true

############################################################
# Enable Persistent Firewall Service
############################################################

echo "Enabling MongoDB SSH firewall service..."

systemctl daemon-reload

systemctl enable openvpn-mongodb-ssh-firewall.service

systemctl restart openvpn-mongodb-ssh-firewall.service

echo "Checking firewall rule..."

iptables -L OPENVPN_INSTALL_FORWARD -n -v --line-numbers

echo "OpenVPN installation completed."

############################################################
# Cleanup After Reboot
############################################################

systemctl disable openvpn-after-reboot.service || true

rm -f /etc/systemd/system/openvpn-after-reboot.service

rm -f /usr/local/bin/openvpn-after-reboot.sh

systemctl daemon-reload

echo "Completed Successfully"

AFTER_EOF

        chmod +x "$AFTER_SCRIPT"

        ####################################################
        # Create After-Reboot Systemd Service
        ####################################################

        cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Continue OpenVPN Installation After FIPS Reboot
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$AFTER_SCRIPT
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

        systemctl daemon-reload

        systemctl enable openvpn-after-reboot.service

        touch "$MARKER"

        echo "Rebooting instance..."

        systemctl reboot

        exit 0

    fi
fi

############################################################
# FIPS Already Disabled
############################################################

echo "FIPS already disabled."

update-crypto-policies --set DEFAULT

echo "Current Crypto Policy:"
update-crypto-policies --show

############################################################
# Download OpenVPN Installer
############################################################

cd /root

curl -fO https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh

chmod +x openvpn-install.sh

############################################################
# OpenVPN Variables
############################################################

export AUTO_INSTALL=y

TOKEN=$(curl -sX PUT \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
http://169.254.169.254/latest/api/token)

export ENDPOINT=$(curl -s \
-H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/public-ipv4)

export APPROVE_INSTALL=y
export APPROVE_IP=y
export IPV6_SUPPORT=n
export CLIENT_IPV4=y
export CLIENT_IPV6=n
export IPV4_SUBNET_CHOICE=1
export PORT_CHOICE=1
export PROTOCOL=tcp
export DNS=adguard
export MULTI_CLIENT=n
export MTU_CHOICE=1
export AUTH_MODE=pki
export COMPRESSION_ENABLED=n
export CUSTOMIZE_ENC=n
export CLIENT=arunvpn
export CLIENT_CERT_DURATION_DAYS=3650
export PASS=1

############################################################
# Install OpenVPN
############################################################

echo "Installing OpenVPN..."

./openvpn-install.sh install

############################################################
# Verify OVPN Profile
############################################################

echo "OVPN profile created at: /root/arunvpn.ovpn"

if [ -f /root/arunvpn.ovpn ]; then

    echo "OVPN file generated successfully."
    ls -l /root/arunvpn.ovpn

else

    echo "ERROR: arunvpn.ovpn was not created."
    exit 1

fi

############################################################
# Restart OpenVPN
############################################################

systemctl enable openvpn-server@server

systemctl restart openvpn-server@server || true

systemctl status openvpn-server@server --no-pager || true

############################################################
# Enable Persistent Firewall Service
############################################################

echo "Enabling MongoDB SSH firewall service..."

systemctl daemon-reload

systemctl enable openvpn-mongodb-ssh-firewall.service

systemctl restart openvpn-mongodb-ssh-firewall.service

echo "Checking firewall rule..."

iptables -L OPENVPN_INSTALL_FORWARD -n -v --line-numbers

############################################################
# Final Status
############################################################

echo "========== OpenVPN Bootstrap Completed : $(date) =========="
