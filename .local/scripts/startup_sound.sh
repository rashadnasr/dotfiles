#!/usr/bin/env bash
sleep 3
# make pipewire to$HOME/Podcasts play a startup tone so that the service doesn't go to suspend
pw-cat -p /home/rashad/Backup/login-sound.ogg &
