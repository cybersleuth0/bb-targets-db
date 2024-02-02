#!/bin/bash

# Get current date in the format 24_01_24
today=$(date +"%d_%m_%y")

echo "working"

# Calculate yesterday's date
yesterday=$(date -d "yesterday" +"%d_%m_%y")

# File paths
alloldtargets="${yesterday}.txt"
allnewtargets="${today}.txt"
newtargets="newtargets.txt"
wildcard="wildcard.txt"

# Check if alloldtargets.txt exists
if [ ! -e "$alloldtargets" ]; then
    echo "Error: $alloldtargets does not exist."
    exit 1
fi

# Check if allnewtargets.txt exists
if [ ! -e "$allnewtargets" ]; then
    echo "Error: $allnewtargets does not exist."
    exit 1
fi

# Get unique lines from allnewtargets.txt not present in alloldtargets.txt
awk 'NR==FNR { old_targets[$0]; next } !($0 in old_targets) { print; totalNewTargets++ } END { print "Total new targets:", totalNewTargets }' "$alloldtargets" "$allnewtargets" > "$newtargets"


# Display final statistics
echo "Final statistics:"
echo "Total old targets: $(wc -l < "$alloldtargets")"
echo "Total new targets found and added to $newtargets."
# Append the content of newtargets.txt to alloldtargets.txt
cat "$newtargets" >> "$alloldtargets"
echo "Old Database getting Updated $(wc -l < "$alloldtargets")"
# Use awk to extract lines starting with "*"
# awk '/^\*/' "$allnewtargets" >> "$wildcard"
grep '^*' "$allnewtargets" > "$wildcard" && grep -v '^*' "$allnewtargets" > temp.txt && mv temp.txt "$newtargets"
rm $wildcard
echo "Thank You For Using our script..."
