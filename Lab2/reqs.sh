#!/bin/bash

INPUT_FILE="request_lab2.sql"
HEADER_PREFIX="Request"
request_number=1
in_query=0
current_query=""

while IFS= read -r line; do
  if [[ "$line" =~ ^--ex ]]; then
    in_query=1
    current_query=""
    current_query+="\\echo --------------------------------------------------"$'\n'
    current_query+="\\echo $HEADER_PREFIX $request_number"$'\n'
    current_query+="\\echo --------------------------------------------------"$'\n'
  elif [[ "$line" =~ ^--end ]]; then
    in_query=0
    if [ -n "$current_query" ]; then
      temp_file=$(mktemp)
      echo "$current_query" > "$temp_file"
      notice=""
          notice+="The request No"
          notice+="$request_number"
          notice+=" is executing... \n"
          echo -e "$notice"
      psql -h pg -d ucheb -f "$temp_file" > "ex$request_number.txt" 2>&1
      notice=""
          notice+="The request No"
          notice+="$request_number"
          notice+=" was executed!\n"
          echo -e "$notice"
      rm "$temp_file"
      request_number=$((request_number + 1))
    fi
  elif [ $in_query -eq 1 ]; then
    current_query+="$line"$'\n'
  fi
done < "$INPUT_FILE"

echo "Done! The results are in files from ex1.txt to ex$((request_number-1)).txt"