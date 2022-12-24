#!/bin/sh

if [ ! -f /var/lib/libvirt/dnsmasq/virbr1.status ]; then
        echo waiting for ip connecting vm;
	sleep 2m
	if [ ! -f /var/lib/libvirt/dnsmasq/virbr1.status ]; then
		echo waiting for ip connecting vm;
		sleep 2m
		if [ ! -f /var/lib/libvirt/dnsmasq/virbr1.status ]; then
			echo waiting for ip connecting vm;
			sleep 2m
			if [ ! -f /var/lib/libvirt/dnsmasq/virbr1.status ]; then
				echo ip of vm not found;
				exit -1;
			fi
		fi
	fi
fi

RDPPORT="$(cat /var/lib/libvirt/dnsmasq/virbr1.status | grep "ip-address" | cut -c 20-99 | head -c -3)"
RDPPORTRequirements=192.168.121.
if [ $RDPPORTRequirements > $RDPPORT ]; then
        echo folowing ip of vm found $RDPPORT;
        echo $RDPPORT > testdebug.txt;
	echo apply iptables;
	iptables-save > $HOME/firewall.txt;
	iptables -X;
	iptables -t nat -F;
	iptables -t nat -X;
	iptables -t mangle -F;
	iptables -t mangle -X;
	iptables -P INPUT ACCEPT;
	iptables -P FORWARD ACCEPT;
	iptables -P OUTPUT ACCEPT;
	iptables -A FORWARD -i eth0 -o virbr1 -p tcp --syn --dport 3389 -m conntrack --ctstate NEW -j ACCEPT;
	iptables -A FORWARD -i eth0 -o virbr1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT;
	iptables -A FORWARD -i virbr1 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT;
	iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3389 -j DNAT --to-destination $RDPPORT;
	iptables -t nat -A POSTROUTING -o virbr1 -p tcp --dport 3389 -d $RDPPORT -j SNAT --to-source 192.168.121.1;
	iptables -D FORWARD -o virbr1 -j REJECT --reject-with icmp-port-unreachable;
	iptables -D FORWARD -i virbr1 -j REJECT --reject-with icmp-port-unreachable;
	iptables -D FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable;
	iptables -D FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable
else
	echo waiting for data output of ip of vm at output;
	sleep 2m
	RDPPORT="$(cat /var/lib/libvirt/dnsmasq/virbr1.status | grep "ip-address" | cut -c 20-99 | head -c -3)"
	if [ $RDPPORTRequirements > $RDPPORT ]; then
		echo folowing ip of vm found $RDPPORT;
		echo $RDPPORT > testdebug.txt;
		echo apply iptables;
		iptables-save > $HOME/firewall.txt;
		iptables -X;
		iptables -t nat -F;
		iptables -t nat -X;
		iptables -t mangle -F;
		iptables -t mangle -X;
		iptables -P INPUT ACCEPT;
		iptables -P FORWARD ACCEPT;
		iptables -P OUTPUT ACCEPT;
		iptables -A FORWARD -i eth0 -o virbr1 -p tcp --syn --dport 3389 -m conntrack --ctstate NEW -j ACCEPT;
		iptables -A FORWARD -i eth0 -o virbr1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT;
		iptables -A FORWARD -i virbr1 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT;
		iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3389 -j DNAT --to-destination $RDPPORT;
		iptables -t nat -A POSTROUTING -o virbr1 -p tcp --dport 3389 -d $RDPPORT -j SNAT --to-source 192.168.121.1;
		iptables -D FORWARD -o virbr1 -j REJECT --reject-with icmp-port-unreachable;
		iptables -D FORWARD -i virbr1 -j REJECT --reject-with icmp-port-unreachable;
		iptables -D FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable;
		iptables -D FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable
	else
		echo ip adress of vm not found;
		exit -1
	fi
fi

