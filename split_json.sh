#!/bin/bash

# Input and output directories
input_dir="${INPUT_DIR:-/replace-with-directory/input}"
output_dir="${OUTPUT_DIR:-/replace-with-directory/output}"
mkdir -p "$output_dir"

# Message header and body fields
message_header="${MESSAGE_HEADER:-Amazon_POS}"
message_body="${MESSAGE_BODY:-orderLines}"

# Field to split the JSON files by, with default value of 'SaleDate'
split_field="${SPLIT_FIELD:-Date}"

# Sender and receiver values
sender="${SENDER:-Replace with sender name}"
receiver="${RECEIVER:-Replace with receiver name}"

# Output file name prefix
output_file_prefix="${OUTPUT_FILE_PREFIX:-name-of-outputfile}"

# Iterate over all JSON files in the input directory
for input_file in "$input_dir"/*.json; do
    # Read and process each JSON file using jq
    jq -c --arg message_header "$message_header" --arg message_body "$message_body" '.[$message_header][$message_body][]' "$input_file" | while read -r line; do
        # Extract the date part (before 'T') from the specified split field
        date=$(echo "$line" | jq -r --arg split_field "$split_field" '.[$split_field]' | cut -d'T' -f1)

        # Define the output file name
        output_file="${output_dir}/${output_file_prefix}_${date}.json"

        # Create the initial structure if the file does not exist
        if [ ! -f "$output_file" ]; then
            echo "{\"$message_header\": {\"sender\": \"$sender\", \"receiver\": \"$receiver\", \"$message_body\": []}}" > "$output_file"
        fi

        # Add the line to the appropriate JSON file
        jq --argjson newLine "$line" --arg message_header "$message_header" --arg message_body "$message_body" '.[$message_header][$message_body] += [$newLine]' "$output_file" > temp.json && mv temp.json "$output_file"
    done
done

echo "All JSON files in the input directory have been processed and split based on $split_field."


