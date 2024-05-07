#!/bin/bash

# Define the path for the output XML file
output_xml="$HOME/dds_scripts/fastdds_tailscale_simple.xml"

# Set debug mode (true or false)
debug=false

# Function to handle debug output
debug_echo() {
  if $debug; then
    echo "$@"
  fi
}

# Fetch tailscale status
tailscale_output=$(tailscale status)

# Debug output for tailscale status
debug_echo "Debug: Tailscale status output:"
debug_echo "$tailscale_output"
debug_echo "-----------------------------------"

# Extract IP addresses
ip_addresses=$(echo "$tailscale_output" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

# Debug output for captured IP addresses
debug_echo "Debug: Captured IP addresses:"
debug_echo "$ip_addresses"
debug_echo "-----------------------------------"

# XML parts before and after IP addresses
xml_header='<?xml version="1.0" encoding="UTF-8" ?>
<profiles xmlns="http://www.eprosima.com/XMLSchemas/fastRTPS_Profiles">
    <transport_descriptors>
        <transport_descriptor>
            <transport_id>TailscaleTransport</transport_id>
            <type>UDPv4</type>
        </transport_descriptor>
    </transport_descriptors>
    <participant profile_name="TailscaleSimple" is_default_profile="true">
        <rtps>
            <userTransports>
                <transport_id>TailscaleTransport</transport_id>
            </userTransports>
            <useBuiltinTransports>true</useBuiltinTransports>
            <builtin>
                <initialPeersList>
' # New line is important!

xml_footer='                </initialPeersList>
            </builtin>
        </rtps>
    </participant>
</profiles>'

# Initialize locator entries variable
locator_entries=""

# Loop through each IP and construct the locator XML part
for ip in $ip_addresses; do
    locator_entries+="                    <locator>
                        <udpv4>
                            <address>$ip</address>
                        </udpv4>
                    </locator>
"
done

# Check if any IP addresses were found
if [ -z "$locator_entries" ]; then
    echo "Warning by ~/dds_scripts/update_fastdds_xml.sh: TAILSCALE NOT AVAILABLE!"
else
    ip_count=$(echo "$ip_addresses" | wc -w)
    debug_echo "$ip_count valid IP addresses found."

    # Combine all parts to form the final XML content
    final_xml_content="$xml_header$locator_entries$xml_footer"

    # Write the final XML content to the specified file
    echo "$final_xml_content" > "$output_xml"

    debug_echo "fastdds_tailscale_simple.xml file updated successfully."
fi


# if debug=true, output should look like this:
# user@SurfaceLS:~/dds_scripts$ ./update_fastdds_xml.sh 
# Debug: Tailscale status output:
# 100.82.37.41    surfacels            ai.lab.unibw@ linux   -
# 100.95.117.19   holycompanion        ai.lab.unibw@ linux   active; relay "ams"; offline, tx 7252 rx 0
# 100.123.103.88  wsl-20-unibwdoeschbj ai.lab.unibw@ linux   active; relay "par", tx 145428 rx 117468

# # Health check:
# #     - Linux DNS config not ideal. /etc/resolv.conf overwritten. See https://tailscale.com/s/dns-fight
# -----------------------------------
# Debug: Captured IP addresses:
# 100.82.37.41
# 100.95.117.19
# 100.123.103.88
# -----------------------------------
# 3 valid IP addresses found.
# fastdds_tailscale_simple.xml file updated successfully.
# user@SurfaceLS:~/dds_scripts$ 