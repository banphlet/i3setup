#!/bin/bash
# Wrapper around i3status to add custom output

set -e

# Command to run i3status with
I3STATUS_CMD="i3status -c $HOME/tconf/i3/i3status.conf"

function kbd_layout() {
  LAYOUT="$(setxkbmap -query | awk '/layout:/ {print $2}')"
  printf '{"full_text":"%s","short_text":"%.2s"}' "$LAYOUT" "$LAYOUT"
}

# Generate the output
eval "$I3STATUS_CMD" | (
  # Print the header content
  read HDR && echo "$HDR"     # { "version": 1 }
  read START && echo "$START" # [

  while :
  do
    read I3STATUS
    I3STATUS="${I3STATUS#*[}" # strip ,[
    I3STATUS="${I3STATUS%]*}" # strip ],

    # Filter out hidden components.
    I3STATUS="$(echo "$I3STATUS" | sed -r 's/\{[^}]*"<HIDE>"[^}]*\},?//g')"

    # TODO: Add local & priv modules
    OUTPUT="[$(kbd_layout),${I3STATUS}],"
    echo "$OUTPUT"
  done
)
