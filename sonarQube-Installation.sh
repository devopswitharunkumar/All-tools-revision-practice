
#!/bin/bash
set -Eeuo pipefail

echo "Starting SonarQube installation using Podman..."

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script using sudo"
    exit 1
fi

# 1. Install Podman
dnf install -y podman

# 2. Verify Podman
podman --version

# 3. Configure kernel requirements
cat > /etc/sysctl.d/99-sonarqube.conf <<EOF
vm.max_map_count=524288
fs.file-max=131072
EOF

sysctl --system

# 4. Enable Podman restart service
systemctl enable --now podman-restart.service

# 5. Create persistent volumes
podman volume create sonarqube_data
podman volume create sonarqube_extensions
podman volume create sonarqube_logs

# 6. Pull SonarQube image
echo "Downloading SonarQube image..."

podman pull docker.io/library/sonarqube:10.4.1-community

# 7. Remove old container if present
if podman container exists sonarqube; then
    podman rm -f sonarqube
fi

# 8. Start SonarQube
echo "Starting SonarQube..."

podman run -d \
    --name sonarqube \
    --restart=always \
    -p 9000:9000 \
    --ulimit nofile=131072:131072 \
    --ulimit nproc=8192:8192 \
    -v sonarqube_data:/opt/sonarqube/data \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    -v sonarqube_logs:/opt/sonarqube/logs \
    docker.io/library/sonarqube:10.4.1-community

# 9. Wait for startup
echo "Waiting for SonarQube..."
sleep 20

# 10. Check container
podman ps -a

# 11. Check logs
podman logs --tail 40 sonarqube

# 12. Check application status
for i in $(seq 1 30); do
    STATUS=$(curl -s http://localhost:9000/api/system/status || true)

    if echo "$STATUS" | grep -q '"status":"UP"'; then
        echo "SonarQube is UP!"
        break
    fi

    echo "SonarQube is starting... $i/30"
    sleep 10
done

echo "===================================="
echo "SonarQube installation process done"
echo "URL: http://YOUR-EC2-PUBLIC-IP:9000"
echo "Username: admin"
echo "Initial password: admin"
echo "===================================="



#Run This in SONARQUBE EC2 
# sudo chmod +x sonarQube-Installation.sh
# sudo ./sonarQube-Installation.sh