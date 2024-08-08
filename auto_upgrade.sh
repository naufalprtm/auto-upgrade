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

# Menentukan opsi
if [ "$1" == "upgrade" ]; then
    MODE="upgrade"
elif [ "$1" == "install-upgrade" ]; then
    MODE="install-upgrade"
else
    print_message "Usage: $0 {upgrade|install-upgrade}" "red"
    exit 1
fi

print_message "Starting system update and upgrade..." "blue"
source ~/.bashrc

# Update sistem
if ! sudo apt-get update -y; then
    print_message "Failed to update package list." "red"
    exit 1
fi

if [ "$MODE" == "upgrade" ]; then
    # Hanya upgrade paket yang sudah ada
    if ! sudo apt-get upgrade -y; then
        print_message "Failed to upgrade existing packages." "red"
        exit 1
    fi
    print_message "System packages upgraded." "green"
elif [ "$MODE" == "install-upgrade" ]; then
    # Upgrade paket yang sudah ada
    if ! sudo apt-get upgrade -y; then
        print_message "Failed to upgrade existing packages." "red"
        exit 1
    fi
    print_message "System packages updated and upgraded." "green"
    
    # Daftar paket-paket yang akan diinstal
    PACKAGES=(
        build-essential curl python3 python3-pip
        htop tmux vim git default-jdk maven gradle
        virtualenv ansible terraform awscli azure-cli
        kubectl minikube helm cmake nginx postgresql postgresql-contrib
        mysql-server redis-server mongodb-org jq tree wget screen zip unzip
        supervisor fish
    )
    
    # Instal paket-paket
    for pkg in "${PACKAGES[@]}"; do
        if ! dpkg -l | grep -qw $pkg; then
            if ! sudo apt-get install -y $pkg; then
                print_message "Failed to install $pkg." "red"
                exit 1
            fi
            print_message "$pkg installed." "green"
        else
            print_message "$pkg already installed. Upgrading if necessary." "yellow"
        fi
    done

    # Upgrade pip to the latest version
    if ! pip install --upgrade pip; then
        print_message "Failed to upgrade pip." "red"
        exit 1
    fi
    print_message "Pip upgraded to the latest version." "green"

    # List outdated pip packages and upgrade them
    if ! pip list --outdated --format=columns | tail -n +3 | awk '{print $1}' | xargs -n1 pip install -U; then
        print_message "Failed to upgrade outdated pip packages." "red"
        exit 1
    fi
    print_message "Outdated pip packages upgraded." "green"

    # Install atau upgrade Node.js
    if ! curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -; then
        print_message "Failed to set up Node.js." "red"
        exit 1
    fi
    if ! sudo apt-get install -y nodejs; then
        print_message "Failed to install Node.js." "red"
        exit 1
    fi
    print_message "Node.js installed or upgraded." "green"

    # Install atau upgrade Docker
    if ! curl -fsSL https://get.docker.com -o get-docker.sh; then
        print_message "Failed to download Docker installation script." "red"
        exit 1
    fi
    if ! sudo sh get-docker.sh; then
        print_message "Failed to install Docker." "red"
        exit 1
    fi
    rm get-docker.sh
    print_message "Docker installed or upgraded." "green"

    # Install atau upgrade Docker Compose
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    if ! sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; then
        print_message "Failed to download Docker Compose." "red"
        exit 1
    fi
    if ! sudo chmod +x /usr/local/bin/docker-compose; then
        print_message "Failed to set permissions for Docker Compose." "red"
        exit 1
    fi
    print_message "Docker Compose installed or upgraded." "green"

    # Install atau upgrade Poetry
    if ! curl -sSL https://install.python-poetry.org | python3 -; then
        print_message "Failed to install Poetry." "red"
        exit 1
    fi
    print_message "Poetry installed or upgraded." "green"

    # Install atau upgrade Rust
    if ! curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
        print_message "Failed to install Rust." "red"
        exit 1
    fi
    source $HOME/.cargo/env
    if ! rustup update; then
        print_message "Failed to update Rust." "red"
        exit 1
    fi
    print_message "Rust installed or upgraded." "green"

    # Install atau upgrade Go
    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text)
    if ! curl -LO "https://golang.org/dl/${GO_VERSION}.linux-amd64.tar.gz"; then
        print_message "Failed to download Go." "red"
        exit 1
    fi
    if ! sudo tar -C /usr/local -xzf "${GO_VERSION}.linux-amd64.tar.gz"; then
        print_message "Failed to install Go." "red"
        exit 1
    fi
    rm "${GO_VERSION}.linux-amd64.tar.gz"
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
    source ~/.bashrc
    print_message "Go installed or upgraded." "green"

    # Install atau upgrade Helm
    if ! curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash; then
        print_message "Failed to install Helm." "red"
        exit 1
    fi
    print_message "Helm installed or upgraded." "green"

    # Install atau upgrade CMake
    if ! sudo apt-get install -y cmake; then
        print_message "Failed to install CMake." "red"
        exit 1
    fi
    print_message "CMake installed or upgraded." "green"

    # Install atau upgrade Minikube
    if ! curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64; then
        print_message "Failed to download Minikube." "red"
        exit 1
    fi
    if ! sudo install minikube /usr/local/bin/; then
        print_message "Failed to install Minikube." "red"
        exit 1
    fi
    rm minikube
    print_message "Minikube installed or upgraded." "green"

    # Install atau upgrade Ansible
    if ! sudo apt-get install -y ansible; then
        print_message "Failed to install Ansible." "red"
        exit 1
    fi
    print_message "Ansible installed or upgraded." "green"

    # Install atau upgrade Terraform
    if ! sudo apt-get install -y gnupg software-properties-common curl; then
        print_message "Failed to install required packages for Terraform." "red"
        exit 1
    fi
    if ! curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -; then
        print_message "Failed to add HashiCorp GPG key." "red"
        exit 1
    fi
    if ! sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"; then
        print_message "Failed to add HashiCorp repository." "red"
        exit 1
    fi
    if ! sudo apt-get update -y; then
        print_message "Failed to update package list for Terraform." "red"
        exit 1
    fi
    if ! sudo apt-get install -y terraform; then
        print_message "Failed to install Terraform." "red"
        exit 1
    fi
    print_message "Terraform installed or upgraded." "green"

    # Install atau upgrade AWS CLI
    if ! curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; then
        print_message "Failed to download AWS CLI." "red"
        exit 1
    fi
    if ! unzip awscliv2.zip; then
        print_message "Failed to unzip AWS CLI package." "red"
        exit 1
    fi
    if ! sudo ./aws/install; then
        print_message "Failed to install AWS CLI." "red"
        exit 1
    fi
    rm -rf awscliv2.zip aws
    print_message "AWS CLI installed or upgraded." "green"

    # Install atau upgrade Azure CLI
    if ! curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash; then
        print_message "Failed to install Azure CLI." "red"
        exit 1
    fi
    print_message "Azure CLI installed or upgraded." "green"

    # Install atau upgrade Kubernetes kubectl
    if ! curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; then
        print_message "Failed to download kubectl." "red"
        exit 1
    fi
    if ! sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; then
        print_message "Failed to install kubectl." "red"
        exit 1
    fi
    rm kubectl
    print_message "Kubernetes kubectl installed or upgraded." "green"

    # Install atau upgrade PostgreSQL
    if ! sudo apt-get install -y postgresql postgresql-contrib; then
        print_message "Failed to install PostgreSQL." "red"
        exit 1
    fi
    print_message "PostgreSQL installed or upgraded." "green"

    # Install atau upgrade MySQL
    if ! sudo apt-get install -y mysql-server; then
        print_message "Failed to install MySQL." "red"
        exit 1
    fi
    print_message "MySQL installed or upgraded." "green"

    # Install atau upgrade Redis
    if ! sudo apt-get install -y redis-server; then
        print_message "Failed to install Redis." "red"
        exit 1
    fi
    print_message "Redis installed or upgraded." "green"

    # Install atau upgrade MongoDB
    if ! wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -; then
        print_message "Failed to add MongoDB GPG key." "red"
        exit 1
    fi
    if ! echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list; then
        print_message "Failed to add MongoDB repository." "red"
        exit 1
    fi
    if ! sudo apt-get update -y; then
        print_message "Failed to update package list for MongoDB." "red"
        exit 1
    fi
    if ! sudo apt-get install -y mongodb-org; then
        print_message "Failed to install MongoDB." "red"
        exit 1
    fi
    print_message "MongoDB installed or upgraded." "green"

    # Install atau upgrade additional tools
    ADDITIONAL_TOOLS=(
        jq tree wget screen zip unzip supervisor fish
    )
    
    for tool in "${ADDITIONAL_TOOLS[@]}"; do
        if ! dpkg -l | grep -qw $tool; then
            if ! sudo apt-get install -y $tool; then
                print_message "Failed to install $tool." "red"
                exit 1
            fi
            print_message "$tool installed." "green"
        else
            print_message "$tool already installed. Upgrading if necessary." "yellow"
        fi
    done
fi

# Bersihkan
if ! sudo apt-get autoremove -y; then
    print_message "Failed to autoremove unnecessary packages." "red"
    exit 1
fi
if ! sudo apt-get clean; then
    print_message "Failed to clean up package cache." "red"
    exit 1
fi

print_message "All specified packages and tools have been processed successfully." "cyan"
