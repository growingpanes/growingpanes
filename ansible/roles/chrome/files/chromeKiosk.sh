#!/bin/bash
while :
do
	matchbox-window-manager &
	google-chrome --remote-debugging-port=2345 --noerrdialogs --no-first-run --kiosk about:blank --start-maximized --user-data-dir=/tmp/panesd-chrome-profile
	sleep 2s
done