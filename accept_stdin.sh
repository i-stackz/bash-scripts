#!/bin/bash

# this script accepts input that is provided as a parameter ($1) if $1 is emtpy, then it is assigned /dev/stdin (standard input)

# for more info see: https://stackoverflow.com/questions/6980090/how-to-read-from-a-file-or-standard-input-in-bash

# code
while read line
do
  echo "$line";
done < "${1:-/dev/stdin}"

# NOTE: the line "${1:-/dev/stdin}" is a way to check if $1 is empty, if it is, then it is assigned the input from /dev/stdin (standard input).
