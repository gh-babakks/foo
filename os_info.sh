#!/bin/bash

# OS Information Script
# Displays comprehensive operating system and hardware information

set -e  # Exit on any error

# Colors for better output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${NC}"
}

# Function to print key-value pairs
print_info() {
    printf "%-20s: %s\n" "$1" "$2"
}

echo -e "${BOLD}${GREEN}Operating System Information${NC}"
echo "==============================="

# Basic OS Information
print_header "Basic System Information"
print_info "Hostname" "$(hostname)"
print_info "Operating System" "$(uname -s)"
print_info "Kernel Release" "$(uname -r)"
print_info "Kernel Version" "$(uname -v)"
print_info "Machine Hardware" "$(uname -m)"
print_info "Processor Type" "$(uname -p)"

# Platform-specific information
case "$(uname -s)" in
    Linux*)
        print_header "Linux Distribution Information"
        
        # Try different methods to get distribution info
        if command -v lsb_release >/dev/null 2>&1; then
            print_info "Distribution" "$(lsb_release -d | cut -f2)"
            print_info "Release" "$(lsb_release -r | cut -f2)"
            print_info "Codename" "$(lsb_release -c | cut -f2)"
        elif [ -f /etc/os-release ]; then
            . /etc/os-release
            print_info "Distribution" "$NAME"
            print_info "Version" "$VERSION"
            print_info "ID" "$ID"
            print_info "Version ID" "$VERSION_ID"
        elif [ -f /etc/redhat-release ]; then
            print_info "Distribution" "$(cat /etc/redhat-release)"
        elif [ -f /etc/debian_version ]; then
            print_info "Distribution" "Debian $(cat /etc/debian_version)"
        fi
        
        # Additional Linux info
        if [ -f /proc/version ]; then
            print_header "Kernel Details"
            print_info "Kernel Info" "$(cat /proc/version)"
        fi
        ;;
        
    Darwin*)
        print_header "macOS Information"
        print_info "Product Name" "$(sw_vers -productName)"
        print_info "Product Version" "$(sw_vers -productVersion)"
        print_info "Build Version" "$(sw_vers -buildVersion)"
        ;;
        
    CYGWIN*|MINGW*|MSYS*)
        print_header "Windows Information"
        print_info "Windows Version" "$(uname -s)"
        ;;
        
    *)
        print_header "Unknown OS"
        print_info "OS Type" "$(uname -s)"
        ;;
esac

# System uptime and load
print_header "System Status"
if command -v uptime >/dev/null 2>&1; then
    print_info "Uptime" "$(uptime | sed 's/.*up //' | sed 's/, *[0-9]* user.*//')"
fi

# Memory information (if available)
if [ -f /proc/meminfo ]; then
    print_header "Memory Information"
    total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    free_mem=$(grep MemFree /proc/meminfo | awk '{print $2}')
    if [ -n "$total_mem" ] && [ -n "$free_mem" ]; then
        total_gb=$((total_mem / 1024 / 1024))
        free_gb=$((free_mem / 1024 / 1024))
        print_info "Total Memory" "${total_gb} GB"
        print_info "Free Memory" "${free_gb} GB"
    fi
elif command -v free >/dev/null 2>&1; then
    print_header "Memory Information"
    free -h | head -2
fi

# CPU information (if available)
if [ -f /proc/cpuinfo ]; then
    print_header "CPU Information"
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//')
    cpu_cores=$(grep -c "^processor" /proc/cpuinfo)
    if [ -n "$cpu_model" ]; then
        print_info "CPU Model" "$cpu_model"
    fi
    if [ -n "$cpu_cores" ]; then
        print_info "CPU Cores" "$cpu_cores"
    fi
elif command -v sysctl >/dev/null 2>&1 && [ "$(uname -s)" = "Darwin" ]; then
    print_header "CPU Information"
    cpu_brand=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown")
    cpu_cores=$(sysctl -n hw.ncpu 2>/dev/null || echo "Unknown")
    print_info "CPU Model" "$cpu_brand"
    print_info "CPU Cores" "$cpu_cores"
fi

# Disk space (if available)
if command -v df >/dev/null 2>&1; then
    print_header "Disk Space (Root Filesystem)"
    df -h / | tail -1 | awk '{print "Used: " $3 " / " $2 " (" $5 " full)"}'
fi

echo -e "\n${GREEN}System information gathering complete!${NC}"