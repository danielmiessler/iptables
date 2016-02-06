#!/usr/bin/env bash

#############################
#  SETUP
#############################

# Define your hostname
DEMOSTHENES=123.456.789.012

# Clear all rules
/sbin/iptables -F

# Don't forward traffic
/sbin/iptables -P FORWARD DROP 

# Allow outgoing traffic
/sbin/iptables -P OUTPUT ACCEPT

# Allow established traffic
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 

# Allow localhost traffic
/sbin/iptables -A INPUT -i lo -j ACCEPT

#############################
#  MANAGEMENT RULES
#############################

# Allow SSH (alternate port)
/sbin/iptables -A INPUT -p tcp --dport 2222 -j LOG --log-level 7 --log-prefix "Accept 2222 alt-ssh"
/sbin/iptables -A INPUT -p tcp -d $DEMOSTHENES --dport 2222 -j ACCEPT 

#############################
#  ACCESS RULES
#############################

# Allow web server
/sbin/iptables -A INPUT -p tcp --dport 80 -j LOG --log-level 7 --log-prefix "Accept 80 HTTP"
/sbin/iptables -A INPUT -p tcp -d $DEMOSTHENES --dport 80 -j ACCEPT 

# Allow two types of ICMP
/sbin/iptables -A INPUT -p icmp -d $DEMOSTHENES --icmp-type 8/0 -j LOG --log-level 7 --log-prefix "Accept Ping"
/sbin/iptables -A INPUT -p icmp -d $DEMOSTHENES --icmp-type 8/0 -j ACCEPT
/sbin/iptables -A INPUT -p icmp -d $DEMOSTHENES --icmp-type 11/0 -j LOG --log-level 7 --log-prefix "Accept Time Exceeded"
/sbin/iptables -A INPUT -p icmp -d $DEMOSTHENES --icmp-type 11/0 -j ACCEPT

#############################
#  DEFAULT DENY
#############################

/sbin/iptables -A INPUT -d $DEMOSTHENES -j LOG --log-level 7 --log-prefix "Default Deny"
/sbin/iptables -A INPUT -j DROP 
