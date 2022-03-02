#!/bin/sh

STATUS="running exited"

for stat in $STATUS; do
    output="$output $(podman ps -qf status="$stat" | wc -l) |"
done

echo "|$output"docker