#!/bin/bash
# turn all the TVs on and set to first HDMI input
for a in `cec-client -l | grep 'com port:' | sed "s/com port:\\s*//"`; do 
	echo "on 0" | cec-client -p 0 -s $a; 
done
sleep 5
xrandr \
  --output DVI-I-1 --mode 1920x1080 --pos 1920x0 --rotate normal \
  --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal \
  --output DVI-D-0 --mode 1920x1080 --pos 0x1080 --rotate normal \
  --output DVI-I-0 --off \
  --output DP-1 --mode 1920x1080 --pos 1920x1080 --rotate normal \
  --output DP-0 --off \
