#!/bin/bash

directory="/etc"
count_files=$(find "$directory" -type f | wc -l)
echo "[?] Amt of regular files in $directory: $count_files"
