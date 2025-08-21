#!/bin/bash

# Script to create a text file with current date and time
echo "Current date and time: $(date)" > timestamp.txt
echo "Generated on: $(date '+%Y-%m-%d at %H:%M:%S %Z')" >> timestamp.txt
echo "Timestamp file created: timestamp.txt"