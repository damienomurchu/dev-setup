#!/bin/bash

DISPLAYS=$(xrandr | grep " connected" | cut -d ' ' -f 1)
#EXTERNAL_DISPLAYS=${(SDISPLAYS[1])}

echo ${$EXTERNAL_DISPLAYS[1]}

if [ $DISPLAYS == "eDP-1" ]; then
  echo $DISPLAYS
fi


