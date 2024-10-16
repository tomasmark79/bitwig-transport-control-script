#!/bin/bash
# Copyright (c) 2024 Tomas Mark (tomas@digitalspace.name)

# Check if a key parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <key>"
  exit 1
fi

KEY=$1

# Get window information using xwininfo
WINDOW_INFO=$(xwininfo -root -tree | grep "com.bitwig.BitwigStudio")

# Extract window IDs from the information
WINDOW_IDS=$(echo "$WINDOW_INFO" | awk '{print $1}')

# Loop through each window ID
for WINDOW_ID in $WINDOW_IDS; do
  # Get the window name
  WINDOW_NAME=$(xdotool getwindowname $WINDOW_ID)

  # Check if the window name contains "Bitwig Studio"
  if [[ "$WINDOW_NAME" == *"Bitwig Studio"* ]]; then
    # Activate Bitwig Studio
    xdotool windowactivate --sync $WINDOW_ID

    # Send the specified key to Bitwig Studio if not onlyfocus request
    if [ "$KEY" != "onlyfocus" ]; then
        xdotool key --window $WINDOW_ID $KEY
    fi
   
    # todo - multi alt. keys support
    # clear modifiers maybe required for cross pass alt. keys differents in Bitwig Studio and xbindkeys
    # xdotool key --clearmodifiers --window $WINDOW_ID $KEY
    exit 0
  fi
done

notify-send "Bitwig Studio window not found"
exit 1