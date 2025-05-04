#!/bin/bash
# Loop through all .eps files in the current directory and all subdirectories
find . -type f -name "*.eps" -print0 | while IFS= read -r -d '' file; do
    epstopdf "$file"
done
