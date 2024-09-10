#!/bin/sh


# Set Keyboard layouts
setxkbmap -layout us,ir -variant ,pes_keypad -option 'grp:alts_toggle' &

# background
# feh --bg-scale ~/.config/awesome/theme/bg &

# Compositor
picom --config $HOME/.config/picom/picom.conf &

# sxhkd (keyboard shortcut daemon)
sxhkd -c $HOME/.config/sxhkd/sxhkdrc &

# NetworkManager Applet
nm-applet &

# Notification
dunst &
