#!/bin/bash

# OS Information Script
# This script displays comprehensive operating system information

echo "===========================================" 
echo "           OS INFORMATION REPORT"
echo "==========================================="
echo

# Basic OS Information
echo "📋 BASIC SYSTEM INFO:"
echo "  Hostname: $(hostname)"
echo "  Operating System: $(uname -s)"
echo "  OS Release: $(uname -r)"
echo "  Architecture: $(uname -m)"
echo "  Kernel Version: $(uname -v)"
echo

# Detailed OS Information (if available)
echo "🖥️  DETAILED OS INFO:"
if command -v lsb_release &> /dev/null; then
    echo "  Distribution: $(lsb_release -d | cut -f2)"
    echo "  Release: $(lsb_release -r | cut -f2)"
    echo "  Codename: $(lsb_release -c | cut -f2)"
elif [ -f /etc/os-release ]; then
    source /etc/os-release
    echo "  Distribution: $NAME"
    echo "  Version: $VERSION"
    echo "  ID: $ID"
elif [ -f /etc/redhat-release ]; then
    echo "  Distribution: $(cat /etc/redhat-release)"
elif [ -f /etc/debian_version ]; then
    echo "  Distribution: Debian $(cat /etc/debian_version)"
else
    echo "  Distribution: Unknown"
fi
echo

# CPU Information
echo "💻 CPU INFO:"
if [ -f /proc/cpuinfo ]; then
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')
    cpu_cores=$(grep -c "^processor" /proc/cpuinfo)
    echo "  CPU Model: $cpu_model"
    echo "  CPU Cores: $cpu_cores"
else
    echo "  CPU Info: Not available"
fi
echo

# Memory Information
echo "🧠 MEMORY INFO:"
if [ -f /proc/meminfo ]; then
    total_mem=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
    available_mem=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')
    if [ -n "$total_mem" ]; then
        total_mem_gb=$((total_mem / 1024 / 1024))
        echo "  Total Memory: ${total_mem_gb} GB"
    fi
    if [ -n "$available_mem" ]; then
        available_mem_gb=$((available_mem / 1024 / 1024))
        echo "  Available Memory: ${available_mem_gb} GB"
    fi
else
    echo "  Memory Info: Not available"
fi
echo

# Disk Usage Information
echo "💾 DISK USAGE:"
if command -v df &> /dev/null; then
    df -h / 2>/dev/null | tail -1 | awk '{print "  Root filesystem: " $2 " total, " $3 " used, " $4 " available (" $5 " used)"}'
else
    echo "  Disk Info: Not available"
fi
echo

# Uptime Information
echo "⏰ UPTIME:"
if command -v uptime &> /dev/null; then
    echo "  $(uptime)"
else
    echo "  Uptime: Not available"
fi
echo

# Current Date and Time
echo "📅 CURRENT TIME:"
echo "  $(date)"
echo

echo "==========================================="
echo "           END OF REPORT"
echo "==========================================="