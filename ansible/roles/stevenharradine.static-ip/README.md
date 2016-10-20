# ansible-static-ip
Ansible role to create a static ip address

[![Licence](https://img.shields.io/badge/Licence-ISC-blue.svg)](https://opensource.org/licenses/ISC)

## Tunables
 * `static_ip_address` (string) - the ip address
 * `static_ip_netmask` (string) - the netmask
 * `static_ip_gateway` (string) - the gateway
 * `static_ip_dns` (string) - space delimited list of dns
 * `static_ip_interface_name` (string) - the interface name to assign the static ip too
