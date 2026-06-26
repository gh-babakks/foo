#!/bin/bash

# Shell script to display current time, date, and day of the week

echo "Current Date and Time Information:"
echo "=================================="
echo "Date: $(date '+%Y-%m-%d')"
echo "Time: $(date '+%H:%M:%S')"
echo "Day of Week: $(date '+%A')"
echo "Full Date/Time: $(date '+%A, %B %d, %Y at %H:%M:%S')"