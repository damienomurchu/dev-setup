#!/bin/sh

KB_LAYOUT="$(setxkbmap -query | grep layout | cut -d ':' -f 2 | xargs)"

echo  $KB_LAYOUT
