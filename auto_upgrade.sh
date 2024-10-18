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
        *)
            echo -e "${RED}Language not supported. Using English.${NC}"
            ;;
    esac
}

view_missing_packages() {
    if [ ${#missing_packages[@]} -eq 0 ]; then
        print_message "No missing packages detected." "green"
    else
        print_message "Missing packages:" "yellow"
        for pkg in "${missing_packages[@]}"; do
            echo "- $pkg"
        done
    fi
}

install_specific_pip() {
    echo "Choose a Python package to install:"
    for i in "${!pip_dependencies[@]}"; do
        echo "$((i+1)). ${pip_dependencies[$i]}"
    done
    read -p "Enter the number of the package to install: " pip_choice
    if [[ $pip_choice -gt 0 && $pip_choice -le ${#pip_dependencies[@]} ]]; then
        pip_package="${pip_dependencies[$((pip_choice-1))]}"
        if ! pip show "$pip_package" > /dev/null 2>&1; then
            print_message "Installing $pip_package..." "blue"
            pip install "$pip_package"
            print_message "$pip_package installed successfully." "green"
        else
            print_message "$pip_package is already installed." "check"
        fi
    else
        print_message "Invalid choice." "red"
    fi
}

remove_specific_pip() {
    echo "Choose a Python package to remove:"
    for i in "${!pip_dependencies[@]}"; do
        echo "$((i+1)). ${pip_dependencies[$i]}"
    done
    read -p "Enter the number of the package to remove: " pip_choice
    if [[ $pip_choice -gt 0 && $pip_choice -le ${#pip_dependencies[@]} ]]; then
        pip_package="${pip_dependencies[$((pip_choice-1))]}"
        if pip show "$pip_package" > /dev/null 2>&1; then
            print_message "Removing $pip_package..." "cyan"
            pip uninstall -y "$pip_package"
            print_message "$pip_package removed successfully." "green"
        else
            print_message "$pip_package is not installed." "cross"
        fi
    else
        print_message "Invalid choice." "red"
    fi
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

check_cargo_dependency() {
    local package=$1
    if cargo install --list | grep "$package" &> /dev/null; then
        print_message "$package" "check"
    else
        print_message "$package" "cross"
        missing_packages+=("$package")
    fi
}

check_cpp_dependency() {
    local package=$1
    if command -v "$package" &> /dev/null; then
        print_message "$package" "check"
    else
        print_message "$package" "cross"
        missing_packages+=("$package")
    fi
}

menu_check_dependencies() {
    echo -e "\n1. Dependencies\n2. Python Dependencies\n3. Cargo Dependencies\n4. C++ Dependencies"
    read -p "Choose the type of dependencies to check: " dep_choice

    case $dep_choice in
        1) 
            print_message "You selected Dependencies. The following will be checked:" "cyan"
            for dep in "${dependencies[@]}"; do
                echo "- $dep"
            done
            read -p "Do you want to check these dependencies? (y/n): " confirm
            if [[ "$confirm" == "y" ]]; then
                for dep in "${dependencies[@]}"; do
                    check_dependency "$dep"
                done
            fi
            ;;
        2)
            print_message "You selected Python Dependencies. The following will be checked:" "cyan"
            for dep in "${pip_dependencies[@]}"; do
                echo "- $dep"
            done
            read -p "Do you want to check these dependencies? (y/n): " confirm
            if [[ "$confirm" == "y" ]]; then
                for dep in "${pip_dependencies[@]}"; do
                    check_python_dependency "$dep"
                done
            fi
            ;;
        3)
            print_message "You selected Cargo Dependencies. The following will be checked:" "cyan"
            for dep in "${cargo_dependencies[@]}"; do
                echo "- $dep"
            done
            read -p "Do you want to check these dependencies? (y/n): " confirm
            if [[ "$confirm" == "y" ]]; then
                for dep in "${cargo_dependencies[@]}"; do
                    check_cargo_dependency "$dep"
                done
            fi
            ;;
        4)
            print_message "You selected C++ Dependencies. The following will be checked:" "cyan"
            for dep in "${cpp_dependencies[@]}"; do
                echo "- $dep"
            done
            read -p "Do you want to check these dependencies? (y/n): " confirm
            if [[ "$confirm" == "y" ]]; then
                for dep in "${cpp_dependencies[@]}"; do
                    check_cpp_dependency "$dep"
                done
            fi
            ;;
        *)
            print_message "Invalid choice" "red"
            ;;
    esac
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
            echo -e "1. Install all dependencies\n2. Install only missing dependencies\n3. Check updates\n4. Remove dependencies\n5. Install a specific package\n6. Install specific Python package\n7. Remove specific Python package\n8. View missing packages\n9. Change language\n10. Install and check for viruses\n11. Check dependencies\n000. Exit"
            ;;
        "id")
            echo -e "1. Install semua\n2. Install hanya yang dibutuhkan (dependensi yang hilang)\n3. Periksa pembaruan\n4. Hapus dependensi\n5. Install satu paket tertentu\n6. Install paket Python tertentu\n7. Hapus paket Python tertentu\n8. Lihat paket yang hilang\n9. Ganti bahasa\n10. Install dan periksa virus\n11. Periksa dependensi\n000. Keluar"
            ;;
        "ru")
            echo -e "1. Установить все\n2. Установить только необходимые (недостающие зависимости)\n3. Проверить обновления\n4. Удалить зависимости\n5. Установить один конкретный пакет\n6. Установить пакет Python\n7. Удалить пакет Python\n8. Просмотреть недостающие пакеты\n9. Изменить язык\n10. Установить и проверить вирусы\n11. Проверить зависимости\n000. Выйти"
            ;;
        "zh")
            echo -e "1. 安装所有\n2. 仅安装所需的（缺少的依赖项）\n3. 检查更新\n4. 删除依赖项\n5. 安装一个特定的软件包\n6. 安装特定的 Python 包\n7. 删除特定的 Python 包\n8. 查看缺失的包\n9. 更改语言\n10. 安装并检查病毒\n11. 检查依赖项\n000. 退出"
            ;;
        "tr")
            echo -e "1. Tümünü kur\n2. Sadece gerekli olanı kur (eksik bağımlılıklar)\n3. Güncellemeleri kontrol et\n4. Bağımlılıkları kaldır\n5. Bir özel paketi kur\n6. Belirli bir Python paketi kur\n7. Belirli bir Python paketini kaldır\n8. Eksik paketleri görüntüle\n9. Dili değiştir\n10. Virüsleri kur ve kontrol et\n11. Bağımlılıkları kontrol et\n000. Çık"
            ;;
        "th")
            echo -e "1. ติดตั้งทั้งหมด\n2. ติดตั้งเฉพาะที่จำเป็น (การพึ่งพาที่หายไป)\n3. ตรวจสอบการอัปเดต\n4. ลบการพึ่งพา\n5. ติดตั้งแพ็คเกจเฉพาะ\n6. ติดตั้งแพ็คเกจ Python เฉพาะ\n7. ลบแพ็คเกจ Python เฉพาะ\n8. ดูแพ็คเกจที่หายไป\n9. เปลี่ยนภาษา\n10. ติดตั้งและตรวจสอบไวรัส\n11. ตรวจสอบการพึ่งพา\n000. ออกจากระบบ"
            ;;
        "alien")
            echo -e "1. ⟟⋏⌇⏁⏃⌰⌰ ⏃⌰⌰\n2. ⟟⋏⌇⏁⏃⌰⌰ ⍜⋏⌰⊬ ⍙⊑⏃⏁'⌇ ⋏⟒⟒⎅⟟⎅ (⋔⟟⌇⌇⟟⋏☌ ⎅⟒⌿⟒⋏⎅⟒⋏☊⟟⟒⌇)\n3. ☊⊑⟒☊☍ ⋉⏃⍀☌⏃⏁⟒ ⎍⌿⎅⏃⏁⟒⌇\n4. ⍀⟒⋔⍜⎐⟒ ⋉⏃⍀☌⏃⏁⟒ ⎅⟒⌿⟒⋏⎅⟒⋏☊⟟⟒⌇\n5. ⋉⏃⍀☌⏃⏁⟒ ⍜⋏⟒ ⌇⌿⟒☊⟟⎎⟟☊ ⌿⏃☊☍⏃☌⟒\n6. ☊⊑⏃⋏☌⟒ ⋉⏃⍀☌⏃⏁⟒ ⌰⏃⋏☌⎍⏃☌⟒\n7. ⍀⟒⋔⍜⎐⟒ ⍙⊑⏃⏁⎅\n8. ⏘⟟⏁⏀⏁⏖\n9. ☊⊑⏃⋏☌⟒ ⌰⏃⋏☌⎍⏃☌⟒\n10. ⟟⋏⌇⏁⏃⌰⌰ ⏃⋏⎅ ☊⊑⟒☊☍ ⎎⍜⍀ ⎐⟟⍀⎍⌇⟒⌇\n11. ⟒⌖⟟⏁\n000. ⟒⌖⟟⏁"
            ;;
    esac
}

load_dependencies() {
    dependencies=($(jq -r '.dependencies[]' dependencies.json))
    pip_dependencies=($(jq -r '.pip_dependencies[]' dependencies.json))
    cargo_dependencies=($(jq -r '.cargo_dependencies[]' dependencies.json))
    cpp_dependencies=($(jq -r '.cpp_dependencies[]' dependencies.json))
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
display_banner() {
    curl -s https://raw.githubusercontent.com/naufalprtm/banner/refs/heads/main/banner.sh | bash
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

main_menu() {
    # Present the main menu options based on the current language setting
    while true; do
        display_banner
        display_system_info
        get_main_menu_options
        read -p "Enter your choice: " choice
        
        case $choice in
            1)
                # Install all dependencies
                for pkg in "${dependencies[@]}"; do
                    install_package "$pkg"
                done
                ;;
            2)
                # Install only missing dependencies
                for pkg in "${missing_packages[@]}"; do
                    install_package "$pkg"
                done
                ;;
            3)
                # Check for updates
                print_message "Updating package lists..." "cyan"
                sudo apt update
                ;;
            4)
                # Remove dependencies
                for pkg in "${dependencies[@]}"; do
                    remove_package "$pkg"
                done
                ;;
            5)
                # Install a specific package
                install_specific_pip
                ;;
            6)
                # Install specific Python package
                install_specific_pip
                ;;
            7)
                # Remove specific Python package
                remove_specific_pip
                ;;
            8)
                # View missing packages
                view_missing_packages
                ;;
            9)
                # Change language
                change_language
                ;;
            10)
                # Install and check for viruses
                install_and_check_viruses
                ;;
            11)
                 # Check dependencies
                menu_check_dependencies
                ;;
            000)
                print_message "Exiting the script. Goodbye!" "green"
                exit 0
                ;;

            *)
                print_message "Invalid choice, please select a valid option." "red"
                ;;
        esac
    done
}

main_menu