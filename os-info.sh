#!/bin/bash

# OS Information Script
# This script displays comprehensive operating system information

echo "=================================================================================="
echo "                              OS Information                                      "
echo "=================================================================================="

# Basic OS Information
echo "OS Name and Version:"
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    echo "  $NAME $VERSION"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  $(sw_vers -productName) $(sw_vers -productVersion)"
elif [[ -f /etc/redhat-release ]]; then
    echo "  $(cat /etc/redhat-release)"
else
    echo "  $(uname -s) $(uname -r)"
fi

echo ""
echo "Kernel Information:"
echo "  Kernel: $(uname -s)"
echo "  Version: $(uname -r)"
echo "  Architecture: $(uname -m)"

echo ""
echo "System Information:"
echo "  Hostname: $(hostname)"
echo "  Current User: $(whoami)"
echo "  Uptime: $(uptime | sed 's/.*up \([^,]*\).*/\1/')"

echo ""
echo "CPU Information:"
if [[ -f /proc/cpuinfo ]]; then
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')
    cpu_cores=$(grep -c "^processor" /proc/cpuinfo)
    echo "  CPU: $cpu_model"
    echo "  Cores: $cpu_cores"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cpu_model=$(sysctl -n machdep.cpu.brand_string)
    cpu_cores=$(sysctl -n hw.ncpu)
    echo "  CPU: $cpu_model"
    echo "  Cores: $cpu_cores"
else
    echo "  CPU: $(uname -p)"
fi

echo ""
echo "Memory Information:"
if [[ -f /proc/meminfo ]]; then
    mem_total=$(grep "MemTotal" /proc/meminfo | awk '{printf "%.2f GB", $2/1024/1024}')
    mem_available=$(grep "MemAvailable" /proc/meminfo | awk '{printf "%.2f GB", $2/1024/1024}')
    echo "  Total Memory: $mem_total"
    echo "  Available Memory: $mem_available"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mem_total=$(sysctl -n hw.memsize | awk '{printf "%.2f GB", $1/1024/1024/1024}')
    echo "  Total Memory: $mem_total"
else
    echo "  Memory information not available"
fi

echo ""
echo "Disk Usage:"
echo "  Root filesystem:"
df -h / | tail -1 | awk '{printf "    Size: %s, Used: %s (%s), Available: %s\n", $2, $3, $5, $4}'

echo ""
echo "Network Information:"
if command -v ip >/dev/null 2>&1; then
    echo "  IP Addresses:"
    ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -3 | while read ip; do
        echo "    $ip"
    done
elif command -v ifconfig >/dev/null 2>&1; then
    echo "  IP Addresses:"
    ifconfig | grep -E 'inet [0-9]' | grep -v '127.0.0.1' | awk '{print "    " $2}' | head -3
else
    echo "  Network information not available"
fi

echo ""
echo "Current Date/Time:"
echo "  $(date)"

echo ""
echo "=================================================================================="