#!/bin/bash

# Define the lines to be added to ~/.bashrc
line1='export RMW_IMPLEMENTATION=rmw_fastrtps_cpp'
line2='export FASTRTPS_DEFAULT_PROFILES_FILE=/home/user/dds_scripts/fastdds_tailscale_simple.xml'
line3='source ~/dds_scripts/update_fastdds_xml.sh'

# Define the target file
bashrc="$HOME/.bashrc"

# Function to add lines to ~/.bashrc if they are not already present
add_if_not_present() {
    local line="$1"
    if ! grep -Fxq "$line" "$bashrc"; then
        echo "$line" >> "$bashrc"
        echo "Added '$line' to $bashrc"
    else
        echo "'$line' is already in $bashrc"
    fi
}

# Check and add the lines if they are not present
add_if_not_present "$line1"
add_if_not_present "$line2"
add_if_not_present "$line3"

# Inform the user to source the .bashrc or restart their terminal
echo "Please source your .bashrc or restart your terminal to apply changes."
