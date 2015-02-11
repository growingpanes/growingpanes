#!/bin/bash
echo "on 0" | cec-client -s
sleep 5
xrandr --output DVI-I-1 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-D-0 --mode 1920x1080 --pos 1920x1080 --rotate normal --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off
