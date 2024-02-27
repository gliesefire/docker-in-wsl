echo "[boot]" > /etc/wsl.conf
echo "systemed=true" > /etc/wsl.conf
echo "" > /etc/wsl.conf
echo "[interop]" > /etc/wsl.conf
echo "appendWindowsPath=false" > /etc/wsl.conf
echo "" > /etc/wsl.conf

apt-get remove docker docker-engine docker.io containerd runc 2>/dev/null || true
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Adds docker apt key
mkdir -p /etc/apt/keyrings
rm /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Adds docker apt repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

groupadd docker

adduser docker_user

# Add the user to the sudo groups
usermod -aG sudo docker_user

# Add the user to the docker group
usermod -aG docker $USER

# Check if docker is installed
docker --version


echo "if service docker status 2>&1 | grep -q ""is not running""; then" >> ~/.profile
echo "    wsl.exe -d ""${WSL_DISTRO_NAME}"" -u root -e /usr/sbin/service docker start >/dev/null 2>&1" >> ~/.profile
echo "fi" >> ~/.profile

sudo echo "# Docker daemon specification" >> /etc/sudoers
sudo echo "docker_user ALL=(ALL) NOPASSWD: /usr/bin/dockerd" >> /etc/sudoers
echo '# Start Docker daemon automatically when logging in if not running.' >> ~/.bashrc
echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> ~/.bashrc
echo 'if [ -z "$RUNNING" ]; then' >> ~/.bashrc
echo '    sudo dockerd > /dev/null 2>&1 &' >> ~/.bashrc
echo '    disown' >> ~/.bashrc
echo 'fi' >> ~/.bashrc