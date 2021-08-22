#!/bin/sh
swaynag -t custom -m 'What would you like to do?' -b 'Sleep' 'systemctl suspend' -b 'Shutdown' 'poweroff' -b 'Restart' 'reboot'
