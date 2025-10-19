#!/bin/bash

# OS Information Script
# This script displays comprehensive operating system information

echo "=========================================="
echo "           OS INFORMATION"
echo "=========================================="
echo

# Operating System Information
echo "📊 Operating System:"
if command -v lsb_release &> /dev/null; then
    lsb_release -d | sed 's/Description:\s*/  /'
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "  $PRETTY_NAME"
elif [ -f /etc/redhat-release ]; then
    echo "  $(cat /etc/redhat-release)"
elif [ -f /etc/debian_version ]; then
    echo "  Debian $(cat /etc/debian_version)"
else
    echo "  $(uname -s) $(uname -r)"
fi
echo

# Kernel Information
echo "🔧 Kernel Information:"
echo "  Version: $(uname -r)"
echo "  Architecture: $(uname -m)"
echo

# System Information
echo "💻 System Information:"
echo "  Hostname: $(hostname)"
echo "  Username: $(whoami)"
echo "  Date/Time: $(date)"
echo

# Uptime Information
echo "⏰ Uptime:"
if command -v uptime &> /dev/null; then
    echo "  $(uptime)"
else
    echo "  uptime command not available"
fi
echo

# Memory Information
echo "💾 Memory Information:"
if [ -f /proc/meminfo ]; then
    total_mem=$(grep '^MemTotal:' /proc/meminfo | awk '{print $2}')
    available_mem=$(grep '^MemAvailable:' /proc/meminfo | awk '{print $2}')
    if [ -n "$total_mem" ] && [ -n "$available_mem" ]; then
        total_gb=$((total_mem / 1024 / 1024))
        available_gb=$((available_mem / 1024 / 1024))
        used_gb=$((total_gb - available_gb))
        echo "  Total: ${total_gb} GB"
        echo "  Used: ${used_gb} GB"
        echo "  Available: ${available_gb} GB"
    fi
else
    echo "  Memory information not available"
fi
echo

# CPU Information
echo "⚡ CPU Information:"
if [ -f /proc/cpuinfo ]; then
    cpu_model=$(grep '^model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')
    cpu_cores=$(grep -c '^processor' /proc/cpuinfo)
    if [ -n "$cpu_model" ]; then
        echo "  Model: $cpu_model"
    fi
    if [ -n "$cpu_cores" ]; then
        echo "  Cores/Threads: $cpu_cores"
    fi
else
    echo "  CPU information not available"
fi
echo

# Disk Usage Information
echo "💿 Disk Usage:"
if command -v df &> /dev/null; then
    df -h / 2>/dev/null | awk 'NR==2 {printf "  Root partition: %s used of %s (%s full)\n", $3, $2, $5}'
    if [ -d /home ]; then
        df -h /home 2>/dev/null | awk 'NR==2 {printf "  Home partition: %s used of %s (%s full)\n", $3, $2, $5}'
    fi
else
    echo "  Disk usage information not available"
fi
echo

# Network Information
echo "🌐 Network Information:"
if command -v hostname &> /dev/null; then
    ip_addr=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ -n "$ip_addr" ]; then
        echo "  IP Address: $ip_addr"
    fi
fi

# Check for common network interfaces
if [ -d /sys/class/net ]; then
    interfaces=$(ls /sys/class/net | grep -v lo | head -3)
    if [ -n "$interfaces" ]; then
        echo "  Network Interfaces:"
        for iface in $interfaces; do
            echo "    $iface"
        done
    fi
fi
echo

echo "=========================================="
echo "        End of OS Information"
echo "=========================================="