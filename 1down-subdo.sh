#!/bin/bash
#path
wildcard="wildcard.txt"
if [ -e "index.json" ]; then
    rm "index.json"
fi

wget "https://chaos-data.projectdiscovery.io/index.json"

# cat index.json | grep "URL" | sed 's/"URL": "//;s/",//' | while read -r host; do
#     wget "$host"
#     counter=$((counter + 1))
#     if [ $((counter % 30)) -eq 0 ]; then
#         sleep 10
#         echo "$counter"
#     fi
# done

#cat index.json | jq -c '.[] | select(.URL and .bounty == true and .platform == "bugcrowd" and .change > 1) | .URL' | sed 's/"//g' | while read -r url; do
cat index.json | jq -c '.[] | select(.URL and .bounty == true and .platform == "") | .URL' | sed 's/"//g' | while read -r url; do
    wget "$url"
    counter=$((counter + 1))
    if [ $((counter % 30)) -eq 0 ]; then
        sleep 1
        echo "$counter"
    fi
done

for i in $(ls -1 | grep .zip$); do
    unzip "$i"
done

# Get current date in the format 25_01_24
current_date=$(date +"%d_%m_%y")
new_targets_file="${current_date}.txt"

# Replace slashes with underscores in the new_targets_file variable
new_targets_file_sanitized=$(echo "$new_targets_file" | tr '/' '_')

# Append the contents of all .txt files to the new targets file
cat *.txt >> "$new_targets_file_sanitized"

grep '^*' "$new_targets_file_sanitized" > "$wildcard" && grep -v '^*' "$new_targets_file_sanitized" > temp.txt && mv temp.txt "$new_targets_file_sanitized"
Remove all .txt files except the new targets file
find . -type f -wholename "./$new_targets_file_sanitized" -prune -o -type f -name "*.txt" -exec rm {} +

# Remove all .zip files
rm *.zip
rm *.zip1

echo "Clearing wait"
clear

echo "New targets added to $new_targets_file_sanitized."

sleep 5
echo "Thank You for using our script"
clear
