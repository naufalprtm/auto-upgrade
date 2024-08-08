#!/bin/bash

# Fungsi untuk mencetak pesan dengan warna
print_message() {
    local message=$1
    local color=$2
    case $color in
        "red") echo -e "\e[31m${message}\e[0m" ;;
        "green") echo -e "\e[32m${message}\e[0m" ;;
        "yellow") echo -e "\e[33m${message}\e[0m" ;;
        "blue") echo -e "\e[34m${message}\e[0m" ;;
        "magenta") echo -e "\e[35m${message}\e[0m" ;;
        "cyan") echo -e "\e[36m${message}\e[0m" ;;
        "white") echo -e "\e[37m${message}\e[0m" ;;
        *) echo "$message" ;;
    esac
}

print_message "Starting system update and upgrade..." "blue"
source ~/.bashrc

# Update and upgrade system packages
sudo apt-get update -y
sudo apt-get upgrade -y
print_message "System packages updated and upgraded." "green"

# Install necessary packages
sudo apt-get install -y build-essential curl python3 python3-pip
print_message "Essential packages installed." "green"

# Upgrade pip to the latest version
pip install --upgrade pip
print_message "Pip upgraded to the latest version." "green"

# List outdated pip packages and upgrade them
pip list --outdated --format=columns | tail -n +3 | awk '{print $1}' | xargs -n1 pip install -U
print_message "Outdated pip packages upgraded." "green"

# Install or upgrade Node.js
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt-get install -y nodejs
print_message "Node.js installed or upgraded." "green"

# Install or upgrade Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
print_message "Docker installed or upgraded." "green"

# Install or upgrade Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
print_message "Docker Compose installed or upgraded." "green"

# Install or upgrade Poetry
curl -sSL https://install.python-poetry.org | python3 -
print_message "Poetry installed or upgraded." "green"

# Install or upgrade Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup update
print_message "Rust installed or upgraded." "green"

# Install or upgrade Go
GO_VERSION=$(curl -s https://go.dev/VERSION?m=text)
curl -LO "https://golang.org/dl/${GO_VERSION}.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "${GO_VERSION}.linux-amd64.tar.gz"
rm "${GO_VERSION}.linux-amd64.tar.gz"
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc
print_message "Go installed or upgraded." "green"

# Install or upgrade systemctl (systemd)
sudo apt-get install -y systemd
print_message "Systemd installed or upgraded." "green"

# Install or upgrade other useful tools
sudo apt-get install -y htop tmux vim git
print_message "Useful tools (htop, tmux, vim, git) installed or upgraded." "green"

# Install or upgrade Java
sudo apt-get install -y default-jdk
print_message "Java installed or upgraded." "green"

# Install or upgrade Maven
sudo apt-get install -y maven
print_message "Maven installed or upgraded." "green"

# Install or upgrade Gradle
sudo apt-get install -y gradle
print_message "Gradle installed or upgraded." "green"

# Install or upgrade Python virtualenv
sudo pip install --upgrade virtualenv
print_message "Python virtualenv installed or upgraded." "green"

# Install or upgrade Ansible
sudo apt-get install -y ansible
print_message "Ansible installed or upgraded." "green"

# Install or upgrade Terraform
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y
sudo apt-get install -y terraform
print_message "Terraform installed or upgraded." "green"

# Install or upgrade AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
print_message "AWS CLI installed or upgraded." "green"

# Install or upgrade Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
print_message "Azure CLI installed or upgraded." "green"

# Install or upgrade Kubernetes kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
print_message "Kubernetes kubectl installed or upgraded." "green"

# Install or upgrade Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube /usr/local/bin/
rm minikube
print_message "Minikube installed or upgraded." "green"

# Install or upgrade Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
print_message "Helm installed or upgraded." "green"

# Install or upgrade CMake
sudo apt-get install -y cmake
print_message "CMake installed or upgraded." "green"

# Install or upgrade Nginx
sudo apt-get install -y nginx
print_message "Nginx installed or upgraded." "green"

# Install or upgrade PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib
print_message "PostgreSQL installed or upgraded." "green"

# Install or upgrade MySQL
sudo apt-get install -y mysql-server
print_message "MySQL installed or upgraded." "green"

# Install or upgrade Redis
sudo apt-get install -y redis-server
print_message "Redis installed or upgraded." "green"

# Install or upgrade MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update -y
sudo apt-get install -y mongodb-org
print_message "MongoDB installed or upgraded." "green"

# Install or upgrade additional tools
sudo apt-get install -y jq
print_message "jq installed or upgraded." "green"

sudo apt-get install -y tree
print_message "tree installed or upgraded." "green"

sudo apt-get install -y wget
print_message "wget installed or upgraded." "green"

sudo apt-get install -y screen
print_message "screen installed or upgraded." "green"

sudo apt-get install -y zip unzip
print_message "zip and unzip installed or upgraded." "green"

sudo apt-get install -y supervisor
print_message "supervisor installed or upgraded." "green"

sudo apt-get install -y fish
print_message "fish shell installed or upgraded." "green"

# Clean up
sudo apt-get autoremove -y
sudo apt-get clean
print_message "System clean-up completed." "green"

print_message "All specified packages and tools have been upgraded successfully." "cyan"
