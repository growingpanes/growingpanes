#!/bin/bash
while :
do
	matchbox-window-manager &
	google-chrome --remote-debugging-port=2345 --noerrdialogs --no-first-run --kiosk http://localhost/presentations/next --start-maximized --user-data-dir=/tmp/panesd-chrome-profile --proxy-server="http://localhost:8118"
	sleep 2s
done
