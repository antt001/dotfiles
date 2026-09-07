#!/usr/bin/env bash
# Waybar power menu. Switched from wofi to rofi 2026-09-02 (wofi is no longer
# installed, and is unmaintained upstream). $NF takes the label after the
# Nerd Font glyph.

op=$( echo -e "  Poweroff\n  Reboot\n  Suspend\n Hibernate\n  Lock\n  Logout" | rofi -dmenu -i -p Power -l 6 -theme-str 'window { width: 300px; }' | awk '{print tolower($NF)}' )

case $op in 
  poweroff)
    ;&
  reboot)
    ;&
  hibernate)
    ;&
  suspend)
    echo "systemctl $op"
    systemctl $op
    ;;
  lock)
    hyprlock
    ;;
  logout)
    hyprctl dispatch exit
    ;;
esac
