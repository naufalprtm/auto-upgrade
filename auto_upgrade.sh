#!/bin/bash

LANGUAGE="en"
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
print_message() {
    local message=$1
    local status=$2
    case $LANGUAGE in
        "en")
            case $status in
                "check") echo -e "\e[32m✔ $message is already installed\e[0m" ;;
                "cross") echo -e "\e[31m✖ $message is not installed\e[0m" ;;
                "blue") echo -e "\e[34m$message\e[0m" ;;
                "yellow") echo -e "\e[33m$message\e[0m" ;;
                "cyan") echo -e "\e[36m$message\e[0m" ;;
                "green") echo -e "\e[32m$message\e[0m" ;;
                "red") echo -e "\e[31m$message\e[0m" ;;
                *) echo "$message" ;;
            esac
            ;;
        "id")
            case $status in
                "check") echo -e "\e[32m✔ $message sudah terinstall\e[0m" ;;
                "cross") echo -e "\e[31m✖ $message belum terinstall\e[0m" ;;
                "blue") echo -e "\e[34m$message\e[0m" ;;
                "yellow") echo -e "\e[33m$message\e[0m" ;;
                "cyan") echo -e "\e[36m$message\e[0m" ;;
                "green") echo -e "\e[32m$message\e[0m" ;;
                "red") echo -e "\e[31m$message\e[0m" ;;
                *) echo "$message" ;;
            esac
            ;;
        "ru")
            case $status in
                "check") echo -e "\e[32m✔ $message уже установлен\e[0m" ;;
                "cross") echo -e "\e[31m✖ $message не установлен\e[0m" ;;
                "blue") echo -e "\e[34m$message\e[0m" ;;
                "yellow") echo -e "\e[33m$message\e[0m" ;;
                "cyan") echo -e "\e[36m$message\e[0m" ;;
                "green") echo -e "\e[32m$message\e[0m" ;;
                "red") echo -e "\e[31m$message\e[0m" ;;
                *) echo "$message" ;;
            esac
            ;;
        "zh")
            case $status in
                "check") echo -e "\e[32m✔ $message 已安装\e[0m" ;;
                "cross") echo -e "\e[31m✖ $message 未安装\e[0m" ;;
                "blue") echo -e "\e[34m$message\e[0m" ;;
                "yellow") echo -e "\e[33m$message\e[0m" ;;
                "cyan") echo -e "\e[36m$message\e[0m" ;;
                "green") echo -e "\e[32m$message\e[0m" ;;
                "red") echo -e "\e[31m$message\e[0m" ;;
                *) echo "$message" ;;
            esac
            ;;
        "tr")
            case $status in
                "check") echo -e "\e[32m✔ $message zaten kurulu\e[0m" ;;
                "cross") echo -e "\e[31m✖ $message kurulu değil\e[0m" ;;
                "blue") echo -e "\e[34m$message\e[0m" ;;
                "yellow") echo -e "\e[33m$message\e[0m" ;;
                "cyan") echo -e "\e[36m$message\e[0m" ;;
                "green") echo -e "\e[32m$message\e[0m" ;;
                "red") echo -e "\e[31m$message\e[0m" ;;
                *) echo "$message" ;;
            esac
            ;;
        "th")
            case $status in
                "check") echo -e "\e[32m✔ $message ถูกติดตั้งแล้ว\e[0m" ;;
                "cross") echo -e "\e[31m✖ $message ยังไม่ได้ติดตั้ง\e[0m" ;;
                "blue") echo -e "\e[34m$message\e[0m" ;;
                "yellow") echo -e "\e[33m$message\e[0m" ;;
                "cyan") echo -e "\e[36m$message\e[0m" ;;
                "green") echo -e "\e[32m$message\e[0m" ;;
                "red") echo -e "\e[31m$message\e[0m" ;;
                *) echo "$message" ;;
            esac
            ;;
        "alien")
            case $status in
                "check") echo -e "\e[32m✔ $message ⟟⌇ ⋉⏃⍀☌⏃⏁⟒⎅\e[0m" ;;
                "cross") echo -e "\e[31m✖ $message ⟟⌇ ⋏⍜⏁ ⋉⏃⍀☌⏃⏁⟒⎅\e[0m" ;;
                "blue") echo -e "\e[34m$message\e[0m" ;;
                "yellow") echo -e "\e[33m$message\e[0m" ;;
                "cyan") echo -e "\e[36m$message\e[0m" ;;
                "green") echo -e "\e[32m$message\e[0m" ;;
                "red") echo -e "\e[31m$message\e[0m" ;;
                *) echo "$message" ;;
            esac
            ;;
    esac
}

check_dependency() {
    local package=$1
    if dpkg -s "$package" &> /dev/null; then
        version=$(dpkg -s "$package" | grep Version | awk '{print $2}')
        print_message "$package (version: $version)" "check"
    else
        print_message "$package" "cross"
        missing_packages+=("$package")
    fi
}

check_python_dependency() {
    local package=$1
    if pip show "$package" &> /dev/null; then
        version=$(pip show "$package" | grep Version | awk '{print $2}')
        print_message "$package (version: $version)" "check"
    else
        print_message "$package" "cross"
        missing_packages+=("$package")
    fi
}

display_banner() {
    curl -s https://raw.githubusercontent.com/naufalprtm/banner/refs/heads/main/banner.sh | bash
}


install_package() {
    local package=$1
    if ! dpkg -s "$package" &> /dev/null; then
        print_message "Installing ${package}..." "cyan"
        if ! sudo apt install "$package" -y; then
            print_message "Error: Failed to install ${package}." "red"
            return 1
        else
            print_message "${package} has been installed successfully." "green"
        fi
    else
        version=$(dpkg -s "$package" | grep Version | awk '{print $2}')
        print_message "${package} is already installed (version: $version)." "yellow"
    fi
}

install_pip_dependencies() {
    for pip_package in "${pip_dependencies[@]}"; do
        if ! pip show "$pip_package" > /dev/null 2>&1; then
            print_message "Installing Python package $pip_package..." "blue"
            pip install "$pip_package"
            print_message "$pip_package installed successfully." "green"
        else
            print_message "Python package $pip_package is already installed." "check"
        fi
    done
}

remove_package() {
    local package=$1
    if dpkg -s "$package" &> /dev/null; then
        print_message "Removing ${package}..." "cyan"
        if ! sudo apt remove "$package" -y; then
            print_message "Error: Failed to remove ${package}." "red"
            return 1
        else
            print_message "${package} has been removed successfully." "green"
        fi
    else
        print_message "${package} is not installed." "yellow"
    fi
}

display_system_info() {
    echo -e "\n--- System Information ---"
    echo "Operating System: $(lsb_release -d | awk -F: '{print $2}' | xargs)"
    echo "Kernel Version: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Disk Usage:"
    df -h --total | grep 'total' | awk '{print $3 "/" $2 " (" $5 " used)"}'
    echo "Available Memory: $(free -h | awk '/^Mem:/{print $7}')"
    echo "CPU Information: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
    echo -e "--------------------------\n"
}


change_language() {
    echo "Select language:"
    echo "1. Indonesian"
    echo "2. English"
    echo "3. Russian"
    echo "4. Chinese"
    echo "5. Turkish"
    echo "6. Thai"
    echo "7. Alien"
    read -p "Enter your choice (1-7): " lang_choice

    case $lang_choice in
        1) LANGUAGE="id";;
        2) LANGUAGE="en";;
        3) LANGUAGE="ru";;
        4) LANGUAGE="zh";;
        5) LANGUAGE="tr";;
        6) LANGUAGE="th";;
        7) LANGUAGE="alien";;
        *) print_message "Invalid choice." "red";;
    esac
    print_message "Language changed to ${LANGUAGE}." "green"


    main_menu
}
install_and_check_viruses() {
    print_message "Installing chkrootkit and rkhunter..." "cyan"
    sudo apt install chkrootkit rkhunter -y

    print_message "Running chkrootkit..." "blue"
    sudo chkrootkit

    print_message "Running rkhunter..." "blue"
    sudo rkhunter --check
}

get_main_menu_options() {
    case $LANGUAGE in
        "en")
            echo -e "1. Install all\n2. Install only what's needed (missing dependencies)\n3. Check updates\n4. Remove dependencies\n5. Install one specific package\n6. Change language\n7. Install and check for viruses\n8. Exit"
            ;;
        "id")
            echo -e "1. Install semua\n2. Install hanya yang dibutuhkan (dependensi yang hilang)\n3. Periksa pembaruan\n4. Hapus dependensi\n5. Install satu paket tertentu\n6. Ganti bahasa\n7. Instal dan periksa virus\n8. Keluar"
            ;;
        "ru")
            echo -e "1. Установить все\n2. Установить только необходимые (недостающие зависимости)\n3. Проверить обновления\n4. Удалить зависимости\n5. Установить один конкретный пакет\n6. Изменить язык\n7. Установить и проверить вирусы\n8. Выйти"
            ;;
        "zh")
            echo -e "1. 安装所有\n2. 仅安装所需的（缺少的依赖项）\n3. 检查更新\n4. 删除依赖项\n5. 安装一个特定的软件包\n6. 更改语言\n7. 安装并检查病毒\n8. 退出"
            ;;
        "tr")
            echo -e "1. Tümünü kur\n2. Sadece gerekli olanı kur (eksik bağımlılıklar)\n3. Güncellemeleri kontrol et\n4. Bağımlılıkları kaldır\n5. Bir özel paketi kur\n6. Dili değiştir\n7. Virüsleri kontrol et ve kur\n8. Çık"
            ;;
        "th")
            echo -e "1. ติดตั้งทั้งหมด\n2. ติดตั้งเฉพาะที่จำเป็น (การพึ่งพาที่หายไป)\n3. ตรวจสอบการอัปเดต\n4. ลบการพึ่งพา\n5. ติดตั้งแพ็คเกจเฉพาะ\n6. เปลี่ยนภาษา\n7. ติดตั้งและตรวจสอบไวรัส\n8. ออกจากระบบ"
            ;;
        "alien")
            echo -e "1. ⟟⋏⌇⏁⏃⌰⌰ ⏃⌰⌰\n2. ⟟⋏⌇⏁⏃⌰⌰ ⍜⋏⌰⊬ ⍙⊑⏃⏁'⌇ ⋏⟒⟒⎅⟟⎅ (⋔⟟⌇⌇⟟⋏☌ ⎅⟒⌿⟒⋏⎅⟒⋏☊⟟⟒⌇)\n3. ☊⊑⟒☊☍ ⋉⏃⍀☌⏃⏁⟒ ⎍⌿⎅⏃⏁⟒⌇\n4. ⍀⟒⋔⍜⎐⟒ ⋉⏃⍀☌⏃⏁⟒ ⎅⟒⌿⟒⋏⎅⟒⋏☊⟟⟒⌇\n5. ⋉⏃⍀☌⏃⏁⟒ ⍜⋏⟒ ⌇⌿⟒☊⟟⎎⟟☊ ⌿⏃☊☍⏃☌⟒\n6. ☊⊑⏃⋏☌⟒ ⋉⏃⍀☌⏃⏁⟒ ⌰⏃⋏☌⎍⏃☌⟒\n7. ⟒⌖⟟⏁\n8. ⏘⟟⏁⏀⏁⏖"
            ;;
    esac
}

main_menu() {
    missing_packages=() 

declare -a dependencies=(
    "build-essential" "cmake" "gcc" "g++" "libssl-dev"
    "curl" "wget" "git" "python3" "python3-pip" "poetry"
    "nvidia-driver-560" "nvidia-cuda-toolkit" "nvidia-smi"
    "golang" "rustc" "cargo" "solc" "geth" "bitcoind"
    "docker.io" "docker-compose" "nodejs" "npm" "java" "maven"
    "gradle" "ansible" "terraform" "awscli" "azure-cli"
    "kubectl" "minikube" "helm" "nginx" "postgresql"
    "mysql-server" "redis-server" "mongodb" "jq" "tree"
    "screen" "zip" "unzip" "supervisor" "fish" "systemd"
    "openssl" "net-tools" "vim" "nano" "htop"
    "tmux" "postfix" "rsync" "git-lfs" "kafka"
    "elasticsearch" "rabbitmq-server" "prometheus"
    "grafana" "zsh" "xclip" "netcat" "iftop"
    "tcpdump" "bpftrace" "sysstat" "apt-transport-https"
    "software-properties-common" "python3-venv" "python3-dev"
    "libffi-dev" "libyaml-dev" "libsqlite3-dev" "libjpeg-dev"
    "libpng-dev" "libtiff-dev" "libpq-dev" "libxml2-dev"
    "libxslt1-dev" "libcurl4-openssl-dev" "libboost-all-dev"
    "rkhunter" "chkrootkit" 
)

declare -a pip_dependencies=(
    "numpy" "pandas" "scikit-learn" "matplotlib" "seaborn"
    "flask" "django" "fastapi" "requests" "beautifulsoup4"
    "pytest" "pytest-cov" "black" "isort" "jupyter"
    "tensorflow" "torch" "opencv-python" "Pillow" "scrapy"
    "SQLAlchemy" "pyodbc" "psycopg2" "paramiko" "fabric"
    "pydantic" "asyncio" "aiohttp" "geopy" "twilio"
    "pytest-asyncio" "mypy" "sphinx" "notebook" "streamlit"
    "dash" "plotly" "tensorflow-datasets" "keras" "transformers"
    "torchvision" "nltk" "spacy" "flask-socketio" "pytest-html"
)

display_banner
display_system_info
print_message "Checking Python dependencies..." "blue"

    echo "Checking Python dependencies..."
    for pkg in "${pip_dependencies[@]}"; do
    check_python_dependency "$pkg"
    done

    print_message "Checking dependencies..." "blue"
    for package in "${dependencies[@]}"; do
        check_dependency "$package"
    done

    if [ ${#missing_packages[@]} -gt 0 ]; then
      print_message "Some dependencies are not installed." "yellow"
      echo "Choose an option:"
      get_main_menu_options  
      read -p "Enter your choice (1-8): " choice

        case $choice in
            1)
                print_message "Installing all dependencies..." "cyan"
                sudo apt install "${dependencies[@]}" -y
                ;;
            2)
                print_message "Installing only what's needed..." "cyan"
                                sudo apt install "${missing_packages[@]}" -y
                ;;
            3)
                print_message "Checking for updates for all packages..." "cyan"
                sudo apt update
                sudo apt list --upgradable
                read -p "Updates available. Do you want to update? (y/n): " update_choice
                if [ "$update_choice" == "y" ]; then
                    sudo apt upgrade -y
                else
                    print_message "Update canceled." "yellow"
                fi
                ;;
            4)
                print_message "Select a dependency to remove:" "yellow"
                for i in "${!dependencies[@]}"; do
                    echo "$((i+1)). ${dependencies[$i]}"
                done
                read -p "Enter the number of the dependency to remove: " uninstall_choice

                if [[ $uninstall_choice -gt 0 && $uninstall_choice -le ${#dependencies[@]} ]]; then
                    selected_package="${dependencies[$((uninstall_choice-1))]}"
                    remove_package "$selected_package"
                else
                    print_message "Invalid choice." "red"
                fi
                ;;
            5)
                print_message "Select one package to install:" "yellow"
                for i in "${!missing_packages[@]}"; do
                    echo "$((i+1)). ${missing_packages[$i]}"
                done
                read -p "Enter the number of the package to install: " package_choice

                if [[ $package_choice -gt 0 && $package_choice -le ${#missing_packages[@]} ]]; then
                    selected_package="${missing_packages[$((package_choice-1))]}"
                    install_package "$selected_package"
                else
                    print_message "Invalid choice." "red"
                fi
                ;;
            6)
                change_language
                ;;
            7)
                install_and_check_viruses
                ;;
            8)
                print_message "Exiting..." "green"
                exit 0
                ;;
            *)
                print_message "Invalid choice." "red"
                ;;
        esac
    else
        print_message "All dependencies are installed!" "green"
    fi

    install_and_check_viruses

    # Prompt to run the main menu again
    read -p "Would you like to run the main menu again? (y/n): " repeat_choice
    if [[ $repeat_choice =~ ^[Yy]$ ]]; then
        main_menu
    else
        print_message "Exiting..." "yellow"
        exit 0
    fi
}

# Start the main menu
main_menu