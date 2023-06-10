#!/bin/bash

NS1="red"
NS2="blue"
VETH1="veth-red"
VETH2="veth-blue"
IP_ADDR1="10.0.0.1/24"
IP_ADDR2="10.0.0.2/24"
IP1="10.0.0.1"
IP2="10.0.0.2"

sudo ip netns add $NS1
sudo ip netns add $NS2

sudo ip link add $VETH1 type veth peer name $VETH2

sudo ip link set $VETH1 netns $NS1
sudo ip link set $VETH2 netns $NS2

sudo ip -n $NS1 addr add $IP_ADDR1 dev $VETH1
sudo ip -n $NS2 addr add $IP_ADDR2 dev $VETH2

sudo ip -n $NS1 link set $VETH1 up
sudo ip -n $NS2 link set $VETH2 up

sudo ip netns exec $NS1 ip route add default via $IP1 dev $VETH1
sudo ip netns exec $NS2 ip route add default via $IP2 dev $VETH2

sudo ip netns exec $NS1 ping $IP2

#Cleanup
sudo ip netns delete $NS1
sudo ip netns delete $NS2