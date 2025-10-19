#!/bin/bash

# OS Information Script
# This script displays comprehensive operating system information

echo "=================================================="
echo "         OPERATING SYSTEM INFORMATION"
echo "=================================================="
echo

# OS Name and Version
echo "📋 Operating System:"
if command -v lsb_release &> /dev/null; then
    lsb_release -d | cut -d: -f2 | sed 's/^\s*//'
elif [ -f /etc/os-release ]; then
    grep PRETTY_NAME /etc/os-release | cut -d= -f2 | sed 's/"//g'
elif [ -f /etc/redhat-release ]; then
    cat /etc/redhat-release
else
    uname -s
fi
echo

# Kernel Information
echo "🔧 Kernel Information:"
echo "  Version: $(uname -r)"
echo "  Architecture: $(uname -m)"
echo

# CPU Information
echo "💻 CPU Information:"
if [ -f /proc/cpuinfo ]; then
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^\s*//')
    cpu_cores=$(grep -c "processor" /proc/cpuinfo)
    echo "  Model: $cpu_model"
    echo "  Cores: $cpu_cores"
else
    echo "  Architecture: $(uname -m)"
fi
echo

# Memory Information
echo "💾 Memory Information:"
if [ -f /proc/meminfo ]; then
    total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    available_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    if [ -n "$total_mem" ]; then
        total_gb=$((total_mem / 1024 / 1024))
        available_gb=$((available_mem / 1024 / 1024))
        echo "  Total: ${total_gb}GB"
        echo "  Available: ${available_gb}GB"
    fi
else
    echo "  Memory information not available"
fi
echo

# Disk Space Information
echo "💽 Disk Space Information:"
df -h / 2>/dev/null | awk 'NR==2 {print "  Root filesystem: " $2 " total, " $3 " used, " $4 " available (" $5 " used)"}' || echo "  Disk information not available"
echo

# System Uptime
echo "⏰ System Uptime:"
if command -v uptime &> /dev/null; then
    uptime -p 2>/dev/null || uptime | cut -d, -f1 | sed 's/.*up //'
else
    echo "  Uptime information not available"
fi
echo

# Current Date and Time
echo "📅 Current Date and Time:"
date
echo

echo "=================================================="