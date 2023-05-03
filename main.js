//=================================
//#     Author: MI SHAJIB
//=================================

// Import execSync for execute os command
const { execSync } = require("child_process");

// Init data
const NS1 = "red";
const NS2 = "blue";
const VETH1 = "veth-red";
const VETH2 = "veth-blue";
const IP_NS1 = "10.0.0.1/24";
const IP_NS2 = "10.0.0.2/24";

// Create two network namespaces
execSync(`sudo ip netns add ${NS1}`);
execSync(`sudo ip netns add ${NS2}`);

// Create two veth(virtual ethernet) cable and link to each/specific namespaces
execSync(`sudo ip link add ${VETH1} type veth peer name ${VETH2}`);
execSync(`sudo ip link set ${VETH1} netns ${NS1}`);
execSync(`sudo ip link set ${VETH2} netns ${NS2}`);

// Configure/assign ip address of the veth interfaces for each namespace
execSync(`sudo ip netns exec ${NS1} ip addr add ${IP_NS1} dev ${VETH1}`);
execSync(`sudo ip netns exec ${NS2} ip addr add ${IP_NS2} dev ${VETH2}`);

// Now enable/up/active the veth interfaces/cables
execSync(`sudo ip netns exec ${NS1} ip link set ${VETH1} up`);
execSync(`sudo ip netns exec ${NS2} ip link set ${VETH2} up`);

// Now check the connection by ping ip address from one to another
execSync(`sudo ip netns exec ${NS1} ping 10.0.0.2`);
