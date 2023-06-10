#!/bin/bash

NS1="red"
NS2="blue"
VETH1="veth-red"
VETH1_BR="veth-red-br"
VETH2="veth-blue"
VETH2_BR="veth-blue-br"
VETH_BR="veth-br"
IP_ADDR1="10.0.0.1/24"
IP_ADDR2="10.0.0.2/24"
IP2="10.0.0.2"

# Create namespaces
sudo ip netns add $NS1
sudo ip netns add $NS2

# Create bridge
sudo ip link add $VETH_BR type bridge
sudo ip link set $VETH_BR up

# Create veth pairs
sudo ip link add $VETH1 type veth peer name $VETH1_BR
sudo ip link add $VETH2 type veth peer name $VETH2_BR

# Add veth pairs to namespaces
sudo ip link set $VETH1 netns $NS1
sudo ip link set $VETH1_BR master $VETH_BR
sudo ip link set $VETH2 netns $NS2
sudo ip link set $VETH2_BR master $VETH_BR

# Add IP addresses
sudo ip -n $NS1 addr add $IP_ADDR1 dev $VETH1
sudo ip -n $NS2 addr add $IP_ADDR2 dev $VETH2

# Bring up interfaces
sudo ip -n $NS1 link set $VETH1 up
sudo ip -n $NS2 link set $VETH2 up
sudo ip link set $VETH1_BR up
sudo ip link set $VETH2_BR up

# Bring up loopback interfaces
sudo ip -n red link set lo up
sudo ip -n blue link set lo up

sudo ip netns exec $NS1 ping $IP2

#Cleanup
sudo ip netns delete $NS1
sudo ip netns delete $NS2
