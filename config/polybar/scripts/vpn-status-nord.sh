#!/bin/sh

CITY=$(nordvpn status | grep City | tr -d ' ' | cut -d ':' -f2)

if [ -n "$CITY" ]; then
    echo "[Nord:$CITY]"
else
    echo ""
fi