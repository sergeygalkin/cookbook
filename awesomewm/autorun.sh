#!/bin/bash
if [ "$(hostname)" = "gals" ]; then
 xrandr --output HDMI3 --mode 1920x1080  --pos 0x0 --primary --rotate normal \
 --output DP1 --mode 1920x1080 --pos 1920x508 --rotate left \
 --output HDMI2 --mode 1920x1080 --pos 3000x-508 --rotate normal
fi
if [ "$(hostname)" = "home" ]; then
  xmodmap /home/gals/.Xmodmap
fi
setxkbmap -layout us,ru  -option "grp:caps_toggle,grp:alt_space_toggle,grp:rctrl_toggle,grp_led:scroll" -variant ",winkeys"
start-pulseaudio-x11
xscreensaver &
flameshot &
killall conky
conky -c ~/.config/awesome/conkyrc-$(hostname)

