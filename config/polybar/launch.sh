#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar(s)
echo "---" | tee -a /tmp/polybar-bottom.log
polybar primary 2>&1 | tee -a /tmp/polybar-bottom & disown

echo "Bars launched..."
