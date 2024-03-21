#!/bin/bash

# Path to the file containing the list of values
VALUES_FILE=EF_chopchop_input/"EF.accessionid.txt"

# Check if the values file exists
if [ ! -f "$VALUES_FILE" ]; then
    echo "File not found: $VALUES_FILE"
    exit 1
fi

# Loop through each line in the values file
while IFS= read -r variable
do
    # Execute the Python script with the current variable
    # Redirect the output to a file named after the variable
    ./chopchop.py --scoringMethod DOENCH_2016 -G Efaecalis_OG1RF -T 1 -o temp/ -Target "${variable}" > EF_chopchop_output/"${variable}.txt"
done < "$VALUES_FILE"
