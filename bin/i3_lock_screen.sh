#!/bin/bash
dunst set-paused true
i3lock -c 000000
dunst set-paused false 
exit

if [[ $(pactl list | grep RUNNING) ]]; then
  exit
fi

dunst set-paused true

img=$(mktemp /tmp/XXXXXXXXXX.png)
import -window root $img 
convert $img -scale 10% -scale 1000% $img

i3lock -n -u -i $img
rm $img

dunst set-paused false
