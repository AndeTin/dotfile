#!/bin/bash
file="$1"
if [[ -d "$file" ]]; then
    # It's a directory, can't handle this from script easily
    # Just do nothing - let yazi handle it
    exit 0
elif [[ "$file" =~ \.pdf$ ]] || [[ "$file" =~ \.PDF$ ]]; then
    onlyoffice "$file" >/dev/null 2>&1 &
else
    xdg-open "$file" >/dev/null 2>&1 &
fi
