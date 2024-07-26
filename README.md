# Split_json
A script writen in Bash used to Split Json files based on a multitude of variables

To run the script, set the environment variables as needed. For example:

chmod +x split_json.sh

INPUT_DIR="/path/to/input" OUTPUT_DIR="/path/to/output" SPLIT_FIELD="desiredField" MESSAGE_HEADER="custom_header" MESSAGE_BODY="custom_body" SENDER="custom_sender" RECEIVER="custom_receiver" OUTPUT_FILE_PREFIX="custom_prefix" ./split_json.sh