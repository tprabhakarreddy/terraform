#!/bin/bash

# Specify the file name
DATA_FILE="data.tf"

# Extract the value of data.aws_ami.example.id
data_name_id=$(grep -oP 'data\.aws_ami\.name\.id' "$DATA_FILE")

# Print the result
if [ -n "$data_name_id" ]; then
  echo "Value found: $data_name_id"
else
  echo "Value not found."
fi
