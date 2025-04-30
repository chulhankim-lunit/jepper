#!/bin/bash

args=($@)
token=${args[0]}
submodules=$(git submodule status)
echo $submodules

while read -r line || [[ -n $line ]]; do
    name=$(awk -F '[ ]' '{print $2}' <<< $line)
    version=$(awk -F '[()]' '{print $2}' <<< $line)
    echo "Deploying $name:$version..."
    curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${token}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/chulhankim-lunit/$name/dispatches \
        -d "{\"event_type\":\"deploy\",\"client_payload\":{\"version\":\"$version\"}}"
done <<< "$submodules"
