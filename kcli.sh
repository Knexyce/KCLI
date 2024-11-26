
#!/bin/bash
# Knexyce Command Line.

kcli-help() {
    echo " "
    echo "KNEXYCE COMMANDS: "
    echo "browser: Access TOR"
    echo "system-info: Info on the system."
    echo "capture: Clone a github repository."
    echo "connect-site <Site URL> <Amount of Requests> <Amount of Seconds Running>: Connects to a website."
    echo "exit: Return to normal the Linux terminal."
    echo " "
}

system-info() {
    echo "### System Information ###"
    uname -a
    echo -e "\n### CPU Information ###"
    lscpu
    echo -e "\n### Memory Information ###"
    free -h
    echo -e "\n### Disk Information ###"
    df -h
    echo -e "\n### Disk Partitions ###"
    sudo fdisk -l
    echo -e "\n### Hardware Information ###"
    sudo lshw -short
    echo -e "\n### Network Information ###"
    ip addr
    echo -e "\n### Network Connections ###"
    netstat -tulnp
    echo -e "\n### System Performance (top) ###"
    top -n 1 -b
    echo -e "\n### Temperature and Health ###"
    sensors
    echo -e "\n### CPU Load ###"
    uptime
    echo -e "\n### All System Summary ###"
    inxi -Fxz
}

capture() {
    echo "Enter the GitHub username. "
    read username
    echo "Enter the GitHub repository name. "
    read repo_name
    repo_url="https://github.com/$username/$repo_name.git"
    git clone "$repo_url"
    echo "Repository $repo_name by $username has been cloned. If this repository has not been cloned: One or both provided inputs may be invalid."
    echo "Check your file system to find the repository contents that were downloaded."
}

connect-site() {
    pids=()
    local url=$1
    local connections=$2
    local duration=$3
    if ! [[ "$connections" =~ ^[0-9]+$ ]] || ! [[ "$duration" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid numbers for connections and duration."
        return 1
    fi
    echo "Sending requests to $url with $connections connections for $duration seconds..."
    send_requests() {
        end_time=$((SECONDS + duration))
        while (( SECONDS < end_time )); do
            curl -s -o /dev/null "$url" &
            pids+=($!)
        done
    }
    for ((i = 0; i < connections; i++)); do
        send_requests &
        pids+=($!)
    done
    sleep "$duration"
    pkill -f "curl -s -o /dev/null $url"
    for pid in "${pids[@]}"; do
        kill "$pid" 2>/dev/null && echo "Killed PID: $pid" || echo "Failed to kill PID: $pid"
    done
    echo "Connections completed."
}

browser() {
    wget https://raw.githubusercontent.com/Knexyce/Knexyce-Script-to-Install-TOR/main/install_tor.sh
    chmod +x install_tor.sh
    ./install_tor.sh
    rm -vfr install_tor.sh
}

listen_for_commands() {
    while true; do
        echo -n "KCLI@Knexyce: "
        read -r input
        case "$input" in
            "system-info")
                system-info
                ;;
            "browser")
                browser
                ;;
            "capture")
                capture
                ;;
            "attack-site")
                attack-site
                ;;
            "kcli-help")
                kcli-help
                ;;
            "exit")
                echo "Exiting."
                break
                ;;
            *)
                $input
                ;;
        esac
    done
}

clear
echo "[=_________]"
sleep 0.5
clear
echo "[==________]"
sudo apt-get install -y -qq sudo
clear
echo "[===_______]"
sleep 0.5
clear
echo "[====______]"
sudo apt-get install -y -qq coreutils
sudo apt-get -y -qq update
sudo apt-get -y -qq dist-upgrade
sudo apt-get -y -qq full-upgrade
clear
echo "[=====_____]"
sleep 0.5
clear
echo "[======____]"
sudo apt-get install -y -qq lshw
sudo apt-get install -y -qq net-tools
sudo apt-get install -y -qq inxi
sudo apt-get install -y -qq lm-sensors
sudo apt-get install -y -qq cpu-checker
sudo apt-get install -y -qq sysstat
sudo apt-get install -y -qq util-linux
sudo apt-get install -y -qq fdisk
sudo apt-get install -y -qq iproute2
sudo apt-get install -y -qq procps 
clear
echo "[=======___]"
sleep 0.5
clear
echo "[========__]"
sudo apt-get install -y -qq curl
sudo apt-get install -y -qq grep
sudo apt-get install -y -qq wget
sudo apt-get install -y -qq tar
sudo apt-get install -y -qq xz-utils
sudo apt-get install -y -qq xdg-utils
clear
echo "[=========_]"
sleep 0.5
clear
echo "[==========]: Upgraded and updated systems."
sleep 0.5
echo "Knexyce Command Line Interface"
echo " "
echo "KnexyceCLI, KCLI, or Knexyce Command Line Interface is built by a group known as Knexyce. The purpose of this software is to add some extra commands and shortcuts to Linux."
echo " "
echo "Some features may include accessing TOR, cloning github repositories, and sending connections/requests to websites."
echo " "
echo "Enter the command 'kcli-help' into KCLI for a list of commands."
echo " "

listen_for_commands

# Script made by Ayan Alam/Knexyce-003 in 2024 AD.
# All rights reserved by Knexyce.
