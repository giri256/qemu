#!/bin/bash
#you must be root
#https://www.spinics.net/linux/fedora/libvir/msg178415.html
#not necessary, this works
#/usr/bin/tunctl -t virbr0-nic
#brctl addbr virbr0
#brctl addif virbr0 virbr0-nic
#brctl stp virbr0 on

#filter table
iptables -t filter -N LIBVIRT_FWI
iptables -t filter -N LIBVIRT_FWO
iptables -t filter -N LIBVIRT_FWX
iptables -t filter -N LIBVIRT_INP
iptables -t filter -N LIBVIRT_OUT
iptables -t filter -A INPUT -j LIBVIRT_INP
iptables -t filter -A FORWARD -j LIBVIRT_FWX
iptables -t filter -A FORWARD -j LIBVIRT_FWI
iptables -t filter -A FORWARD -j LIBVIRT_FWO
iptables -t filter -A OUTPUT -j LIBVIRT_OUT
iptables -t filter -A LIBVIRT_FWI -d 192.168.122.0/24 -o virbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A LIBVIRT_FWI -o virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -t filter -A LIBVIRT_FWO -s 192.168.122.0/24 -i virbr0 -j ACCEPT
iptables -t filter -A LIBVIRT_FWO -i virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -t filter -A LIBVIRT_FWX -i virbr0 -o virbr0 -j ACCEPT
iptables -t filter -A LIBVIRT_INP -i virbr0 -p udp -m udp --dport 53 -j ACCEPT
iptables -t filter -A LIBVIRT_INP -i virbr0 -p tcp -m tcp --dport 53 -j ACCEPT
iptables -t filter -A LIBVIRT_INP -i virbr0 -p udp -m udp --dport 67 -j ACCEPT
iptables -t filter -A LIBVIRT_INP -i virbr0 -p tcp -m tcp --dport 67 -j ACCEPT
iptables -t filter -A LIBVIRT_OUT -o virbr0 -p udp -m udp --dport 68 -j ACCEPT
#nat table
iptables -t nat -N LIBVIRT_PRT
iptables -t nat -A POSTROUTING -j LIBVIRT_PRT
iptables -t nat -A LIBVIRT_PRT -s 192.168.122.0/24 -d 224.0.0.0/24 -j RETURN
iptables -t nat -A LIBVIRT_PRT -s 192.168.122.0/24 -d 255.255.255.255/32 -j RETURN
iptables -t nat -A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
iptables -t nat -A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
iptables -t nat -A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -j MASQUERADE
#mangle table
iptables -t mangle -N LIBVIRT_PRT
iptables -t mangle -A POSTROUTING -j LIBVIRT_PRT
iptables -t mangle -A LIBVIRT_PRT -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill 
