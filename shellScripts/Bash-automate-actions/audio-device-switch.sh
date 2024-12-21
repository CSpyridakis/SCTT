#!/bin/bash

# See for the original script:
# https://gist.github.com/kbravh/1117a974f89cc53664e55823a55ac320

sinks_to_exclude=("hdmi") # TODO: update this list
exclude_pattern=$(printf "|%s" "${sinks_to_exclude[@]}")
exclude_pattern=${exclude_pattern:1}

# Check which sound server is running
if pgrep pulseaudio >/dev/null; then
  sound_server="pulseaudio"
elif pgrep pipewire >/dev/null; then
  sound_server="pipewire"
else
  echo "Neither PulseAudio nor PipeWire is running."
  exit 1
fi

# Grab a count of how many audio sinks we have
if [[ "$sound_server" == "pulseaudio" ]]; then
  sink_count=$(pacmd list-sinks | grep -c "index:[[:space:]][[:digit:]]")
  # Create an array of the actual sink IDs
  sinks=()
  sinks=($(pacmd list-sinks | grep 'index:[[:space:]][[:digit:]]' | sed -n -e 's/.*index:[[:space:]]\([[:digit:]]\)/\1/p'))
  # Get the ID of the active sink
  active_sink=$(pacmd list-sinks | sed -n -e 's/[[:space:]]*\*[[:space:]]index:[[:space:]]\([[:digit:]]\)/\1/p')
elif [[ "$sound_server" == "pipewire" ]]; then
  sink_count=$(pactl list sinks | grep -c "Sink #[[:digit:]]")
  # Create an array of the actual sink IDs
  sinks=($(pactl list sinks short | grep -v -E "${exclude_pattern}" | awk '{print $1}'))
  # Get the ID of the active sink
  active_sink_name=$(pactl info | grep 'Default Sink:' | sed -n -e 's/.*Default Sink:[[:space:]]\+\(.*\)/\1/p')
  active_sink=$(pactl list sinks | grep -B 2 "$active_sink_name" | sed -n -e 's/Sink #\([[:digit:]]\)/\1/p' | head -n 1)
fi

# Get the ID of the last sink in the array
final_sink=${sinks[$((sink_count - 1))]}

# Find the index of the active sink
for index in "${!sinks[@]}"; do
  if [[ "${sinks[$index]}" == "$active_sink" ]]; then
    active_sink_index=$index
  fi
done

# Default to the first sink in the list
next_sink=${sinks[0]}
next_sink_index=0

# If we're not at the end of the list, move up the list
if [[ $active_sink -ne $final_sink ]]; then
  next_sink_index=$((active_sink_index + 1))
  next_sink=${sinks[$next_sink_index]}
fi

#change the default sink
if [[ "$sound_server" == "pulseaudio" ]]; then
  pacmd "set-default-sink ${next_sink}"
elif [[ "$sound_server" == "pipewire" ]]; then
  # Get the name of the next sink
  next_sink_name=$(pactl list sinks | grep -C 2 "Sink #$next_sink" | sed -n -e 's/.*Name:[[:space:]]\+\(.*\)/\1/p' | head -n 1)
  pactl set-default-sink "$next_sink_name"
fi

#move all inputs to the new sink
# if [[ "$sound_server" == "pulseaudio" ]]; then
#   for app in $(pacmd list-sink-inputs | sed -n -e 's/index:[[:space:]]\([[:digit:]]\)/\1/p'); do
#     pacmd "move-sink-input $app $next_sink"
#   done
# elif [[ "$sound_server" == "pipewire" ]]; then
#   for app in $(pactl list sink-inputs | sed -n -e 's/.*Sink Input #\([[:digit:]]\)/\1/p'); do
#     pactl "move-sink-input $app $next_sink"
#   done
# fi

# Create a list of the sink descriptions
sink_descriptions=""
if [[ "$sound_server" == "pulseaudio" ]]; then
    sink_description="TODO"
elif [[ "$sound_server" == "pipewire" ]]; then
    sink_description="$(pactl info | grep 'Default Sink' | awk -F': ' '{print $2}' | cut -d'.' -f3- | tr '_' ' ' | tr '-' ' ')"
fi

notify-send -i audio-volume-high \
    -h string:x-canonical-private-synchronous:anything \
    -a audio-output-change \
    "Sound output switched to:" "${sink_description}"
