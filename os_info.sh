#!/bin/bash

# OS Information Script
# This script displays comprehensive operating system information

echo "====================================="
echo "        SYSTEM INFORMATION"
echo "====================================="
echo

# Operating System Information
echo "📋 Operating System:"
if command -v lsb_release &> /dev/null; then
    lsb_release -a 2>/dev/null
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "  Name: $NAME"
    echo "  Version: $VERSION"
    echo "  ID: $ID"
elif [ -f /etc/redhat-release ]; then
    echo "  $(cat /etc/redhat-release)"
elif command -v sw_vers &> /dev/null; then
    echo "  $(sw_vers -productName) $(sw_vers -productVersion)"
else
    echo "  $(uname -s)"
fi
echo

# Kernel Information
echo "🔧 Kernel Information:"
echo "  Kernel: $(uname -s)"
echo "  Version: $(uname -r)"
echo "  Architecture: $(uname -m)"
echo

# System Information
echo "🖥️  System Information:"
echo "  Hostname: $(hostname)"
echo "  Username: $(whoami)"
echo "  Date: $(date)"
echo

# Uptime
echo "⏰ System Uptime:"
uptime
echo

# CPU Information
echo "💻 CPU Information:"
if [ -f /proc/cpuinfo ]; then
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//')
    cpu_cores=$(grep -c ^processor /proc/cpuinfo)
    echo "  Model: $cpu_model"
    echo "  Cores: $cpu_cores"
elif command -v sysctl &> /dev/null; then
    echo "  Model: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown")"
    echo "  Cores: $(sysctl -n hw.ncpu 2>/dev/null || echo "Unknown")"
else
    echo "  Architecture: $(uname -m)"
fi
echo

# Memory Information
echo "💾 Memory Information:"
if command -v free &> /dev/null; then
    free -h
elif command -v vm_stat &> /dev/null; then
    echo "  Memory Statistics:"
    vm_stat
else
    echo "  Memory information not available"
fi
echo

# Disk Usage
echo "💿 Disk Usage:"
df -h 2>/dev/null | head -10
echo

# Network Information
echo "🌐 Network Interfaces:"
if command -v ip &> /dev/null; then
    ip addr show | grep -E "^[0-9]+:|inet " | head -10
elif command -v ifconfig &> /dev/null; then
    ifconfig | grep -E "^[a-z]|inet " | head -10
else
    echo "  Network interface information not available"
fi
echo

echo "====================================="
echo "     END OF SYSTEM INFORMATION"
echo "====================================="