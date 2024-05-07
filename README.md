# ROS2 via Tailscale (or other non Multicast Networks)

- manually run `setup_run_once.sh`, which adds the env variables for FastDDS to your bashrc and the command to automaticly run the `update_fastdds_xml.sh` file everytime you open a shell, it's super fast and has no output if it works.
- `update_fastdds_xml.sh` looks for IPv4 adresses in the output of `tailscale status` and writes the `fastdds_tailscale_simple.xml` for you which is used by FastDDS to find remote nodes.
- should work independent of the specific ros2 version.