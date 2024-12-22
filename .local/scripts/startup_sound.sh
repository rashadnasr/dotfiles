#!/usr/bin/env bash
sleep 3
# make pipewire to play a tone at starup so that the service doesn't go to suspend
pw-cat -p /home/rashad/Backup/login-sound.ogg &
