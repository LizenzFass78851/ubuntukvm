#!/bin/bash
set -eou pipefail

chown root:kvm /dev/kvm
service libvirtd start
service virtlogd start
VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up

#sleep 3m

iptables-save > $HOME/firewall.txt
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A FORWARD -i eth0 -o virbr1 -p tcp --syn --dport 3389 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -i eth0 -o virbr1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i virbr1 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3389 -j DNAT --to-destination $(nmap -v  192.168.121.1/24 -p 3389 | grep "Scanning 192.168.121." | cut -c 10-24 | head -1)
iptables -t nat -A POSTROUTING -o virbr1 -p tcp --dport 3389 -d $(nmap -v  192.168.121.1/24 -p 3389 | grep "Scanning 192.168.121." | cut -c 10-24 | head -1) -j SNAT --to-source 192.168.121.1

iptables -D FORWARD -o virbr1 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -i virbr1 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable

exec "$@"
