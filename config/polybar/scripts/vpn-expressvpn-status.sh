#!/bin/sh

STATUS=$(expressvpn status | grep -i "connected")

expressvpn_toggle() {
    if [ "$STATUS" != 'Not connected' ]; then
        expressvpn disconnect
    else
        expressvpn connect
    fi
}

expressvpn_status() {
    if [ "$STATUS" != 'Not connected' ]; then
        server=`echo $STATUS | cut -d '-' -f 2`
        echo Express: $server
    fi
}

case "$1" in
    --toggle)
        expressvpn_toggle
    ;;
    *)
        expressvpn_status
    ;;
esac
