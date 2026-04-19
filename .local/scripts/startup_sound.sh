#!/usr/bin/env bash
# A simple script to play a song at startup

# wait for login process to complete
sleep 1

jingle="/home/rashad/Backup/login-sound.ogg"

if [ -f /usr/bin/pacat ]; then                   #Pulseaudio
    pacat -p --file-format=oga "$jingle"
    
elif [ -f /usr/bin/pwcat ]; then                 #Pipewire
    pw-cat -p "$jingle"
fi

