#!/usr/bin/env bash

while read -r package; do
    while read -r curFile; do
        ldd "$curFile" &> /dev/null

        if (( ! $? )); then
            while read -r libFile; do
                printf '%s: %s - %s\n' "$package" "$curFile" "$(awk '{print $1}' <<< "$libFile")"
            done < <(ldd "$curFile" 2>/dev/null | grep 'not found')
        fi
    done < <(pacman -Ql "$package" | egrep -v '(.gz|.html|.h|.hxx|/)$' | awk '{print $2}')
done < <(pacman -Qqm)
