#!/bin/bash

# You can also use: killall notify-osd

# Toggle microphone mute
pactl set-source-mute @DEFAULT_SOURCE@ toggle #\

# Display notification
if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q 'yes' ; then
    notify-send \
        -i microphone-sensitivity-muted \
        -a microphone-mute-toggle \
        -h string:x-canonical-private-synchronous:anything \
        "Microphone" "Microphone Muted"
else
    notify-send \
        -i microphone-sensitivity-high \
        -a microphone-mute-toggle \
        -h string:x-canonical-private-synchronous:anything \
        "Microphone" "Microphone Unmuted"
fi
