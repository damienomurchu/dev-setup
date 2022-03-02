#!/bin/sh

time=$((20 - $(date '+%-M') % 20))

echo " $time"

if [ $time -eq 20 ]; then
  echo " break"
  notify-send 'Eye-Break' &
  #  ogg123 beep.ogg &> /dev/null &
fi
