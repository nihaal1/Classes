#!/bin/bash

# Input CSV file path
input_file="tcpprobe.csv"

# Output CSV file path for matched lines
output_file="output_34.csv"

# Check if input file exists
if [ -e "$input_file" ]; then
    # Use awk to extract lines where the second column matches the IP address and port
    awk -F, '$2 == "10.10.1.2:59234"' "$input_file" > "$output_file"

    echo "Matching lines extracted and saved to $output_file"
else
    echo "Error: Input file not found."
fi

