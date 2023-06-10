#=================================
#     Author: MI SHAJIB
#=================================

# Import necessary library for run command on OS(operating system)
import os

# Constants
NS1 = 'red'
NS2 = 'blue'
VETH1 = 'veth-red'
VETH2 = 'veth-blue'
IP_NS1 = '10.0.0.1/24'
IP_NS2 = '10.0.0.2/24'
IP1 = '10.0.0.1'
IP2 = '10.0.0.2'

# Create network namespaces
os.system('sudo ip netns add ' + NS1)
os.system('sudo ip netns add ' + NS2)

# Create veth(virtual ethernet) pair and move one end to each namespace
os.system('sudo ip link add ' + VETH1 + ' type veth peer name ' + VETH2)
os.system('sudo ip link set ' + VETH1 + ' netns ' + NS1)
os.system('sudo ip link set ' + VETH2 + ' netns ' + NS2)

# Configure/add IP addresses of veth interfaces in each network namespace
os.system('sudo ip netns exec ' + NS1 + ' ip addr add ' + IP_NS1 + ' dev ' + VETH1)
os.system('sudo ip netns exec ' + NS2 + ' ip addr add ' + IP_NS2 + ' dev ' + VETH2)

# Enable/up/active veth interfaces/cables
os.system('sudo ip netns exec ' + NS1 + ' ip link set ' + VETH1 + ' up')
os.system('sudo ip netns exec ' + NS2 + ' ip link set ' + VETH2 + ' up')

# Ping ip from one to another ip
os.system('sudo ip netns exec ' + NS1 + ' ping ' + IP2)

#Cleanup
os.system('sudo ip netns delete ' + NS1)
os.system('sudo ip netns delete ' + NS2)
