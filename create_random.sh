#!/bin/bash

# Script to create a text file with random numbers
echo "Random number: $RANDOM" > random.txt
echo "Another random number: $RANDOM" >> random.txt
echo "Generated on: $(date '+%Y-%m-%d at %H:%M:%S %Z')" >> random.txt
echo "Random file created: random.txt"
