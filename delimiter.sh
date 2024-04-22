#!/bin/bash


# this is an example of setting a delimiter using bash script.
# this example was provided from chatgpt. see: https://chat.openai.com/c/a4c49e0a-669a-4b6d-97ea-3188bd0546f9


# Your string with commas
my_string="item1,item2,item3,item4"

# Set the Internal Field Separator to comma
IFS=','

# Iterate through each item in the string
for item in $my_string; do
    echo "$item"
done

