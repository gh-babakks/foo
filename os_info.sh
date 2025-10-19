#!/bin/bash

# OS Information Script
# Displays comprehensive system and OS information

echo "====================================="
echo "        OS INFORMATION REPORT        "
echo "====================================="
echo ""

# Date and Time
echo "📅 Date & Time:"
echo "   $(date)"
echo ""

# Current User
echo "👤 Current User:"
echo "   $(whoami)"
echo ""

# Hostname
echo "🖥️  Hostname:"
echo "   $(hostname)"
echo ""

# Operating System
echo "🐧 Operating System:"
if command -v lsb_release &> /dev/null; then
    lsb_release -d | sed 's/Description:/   /'
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "   $PRETTY_NAME"
elif [ -f /etc/redhat-release ]; then
    echo "   $(cat /etc/redhat-release)"
else
    echo "   $(uname -s)"
fi
echo ""

# Kernel Information
echo "🔧 Kernel Information:"
echo "   $(uname -sr)"
echo ""

# System Architecture
echo "🏗️  Architecture:"
echo "   $(uname -m)"
echo ""

# CPU Information
echo "💻 CPU Information:"
if command -v lscpu &> /dev/null; then
    cpu_model=$(lscpu | grep "Model name" | sed 's/Model name:[[:space:]]*/   /')
    cpu_cores=$(lscpu | grep "^CPU(s):" | sed 's/CPU(s):[[:space:]]*/   Cores: /')
    echo "$cpu_model"
    echo "$cpu_cores"
elif [ -f /proc/cpuinfo ]; then
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^[[:space:]]*/   /')
    cpu_count=$(grep -c "^processor" /proc/cpuinfo)
    echo "$cpu_model"
    echo "   Cores: $cpu_count"
else
    echo "   CPU information not available"
fi
echo ""

# Memory Information
echo "🧠 Memory Information:"
if command -v free &> /dev/null; then
    free -h | awk '
    /^Mem:/ { 
        printf "   Total: %s, Used: %s, Available: %s\n", $2, $3, $7 
    }'
elif [ -f /proc/meminfo ]; then
    total_kb=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
    available_kb=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')
    total_mb=$((total_kb / 1024))
    available_mb=$((available_kb / 1024))
    used_mb=$((total_mb - available_mb))
    echo "   Total: ${total_mb}MB, Used: ${used_mb}MB, Available: ${available_mb}MB"
else
    echo "   Memory information not available"
fi
echo ""

# Disk Usage
echo "💾 Disk Usage:"
if command -v df &> /dev/null; then
    df -h / | awk 'NR==2 { printf "   Root (/): %s total, %s used, %s available (%s used)\n", $2, $3, $4, $5 }'
else
    echo "   Disk information not available"
fi
echo ""

# Uptime
echo "⏰ System Uptime:"
if command -v uptime &> /dev/null; then
    uptime_info=$(uptime | sed 's/^[[:space:]]*/   /')
    echo "$uptime_info"
else
    echo "   Uptime information not available"
fi
echo ""

# Network Information (basic)
echo "🌐 Network Information:"
if command -v hostname &> /dev/null; then
    ip_addr=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ -n "$ip_addr" ]; then
        echo "   IP Address: $ip_addr"
    else
        echo "   IP Address: Not available"
    fi
else
    echo "   Network information not available"
fi
echo ""

echo "====================================="
echo "         END OF REPORT               "
echo "====================================="