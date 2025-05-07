#!/usr/bin/env bash

result=$(echo "" | tofi --require-match=false)
echo "$result"
if [[ -n "$result" ]]; then
    query=$(echo "$result" | sed 's/ /+/g')
    link="https://www.google.com/search?q=$query"
    echo "$link"
fi

