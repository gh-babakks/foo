#!/bin/bash

# OS Information Script
# Prints comprehensive system and OS information

echo "=============================="
echo "    SYSTEM INFORMATION"
echo "=============================="
echo

# Basic system information
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Current Date: $(date)"
echo

# OS and kernel information
echo "Operating System: $(uname -s)"
echo "Kernel Release: $(uname -r)"
echo "Kernel Version: $(uname -v)"
echo "Machine Architecture: $(uname -m)"
echo "Processor: $(uname -p 2>/dev/null || echo "Unknown")"
echo

# Distribution information (Linux)
if [ -f /etc/os-release ]; then
    echo "Distribution Information:"
    . /etc/os-release
    echo "  Name: $NAME"
    echo "  Version: $VERSION"
    echo "  ID: $ID"
    echo "  Version ID: $VERSION_ID"
    echo
elif [ -f /etc/lsb-release ]; then
    echo "Distribution Information:"
    . /etc/lsb-release
    echo "  Distribution: $DISTRIB_ID"
    echo "  Version: $DISTRIB_RELEASE"
    echo "  Description: $DISTRIB_DESCRIPTION"
    echo
elif command -v lsb_release >/dev/null 2>&1; then
    echo "Distribution Information:"
    echo "  $(lsb_release -d | cut -f2-)"
    echo "  $(lsb_release -r | cut -f2-)"
    echo
fi

# Memory information
if command -v free >/dev/null 2>&1; then
    echo "Memory Information:"
    free -h
    echo
elif [ -f /proc/meminfo ]; then
    echo "Memory Information:"
    echo "  Total Memory: $(grep MemTotal /proc/meminfo | awk '{print $2 " " $3}')"
    echo "  Available Memory: $(grep MemAvailable /proc/meminfo | awk '{print $2 " " $3}' 2>/dev/null || echo "N/A")"
    echo
fi

# Disk space information
echo "Disk Space Information:"
df -h / 2>/dev/null || df /
echo

# Uptime information
if command -v uptime >/dev/null 2>&1; then
    echo "System Uptime:"
    uptime
    echo
fi

# CPU information (basic)
if [ -f /proc/cpuinfo ]; then
    cpu_count=$(grep -c "^processor" /proc/cpuinfo 2>/dev/null)
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//' 2>/dev/null)
    if [ -n "$cpu_count" ] && [ -n "$cpu_model" ]; then
        echo "CPU Information:"
        echo "  Processors: $cpu_count"
        echo "  Model: $cpu_model"
        echo
    fi
fi

echo "=============================="