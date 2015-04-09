#!/bin/bash
# turn all the TVs on and set to first HDMI input
for a in `cec-client -l | grep 'com port:' | sed "s/com port:\\s*//"`; do 
	echo "standby 0" | cec-client -p 0 -s $a &
done
