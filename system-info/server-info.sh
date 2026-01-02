#!/bin/bash

#Description: Collects disk usage, CPU usage, RAM usage, and kernel version
# Author: Suraj Wadikar
# Usage: ./server-info.sh

#Fetch host name
server_name=$(hostname)

#Current Disk usage
function memory_check(){
    echo ""
    echo "The current memory usage on ${server_name} is:"
    free -h
    echo ""
}

#Current CPU usage
function cpu_check(){
    echo ""
    echo "CPU load on ${server_name} is : $(uptime)"
    echo ""
}

#Current tcp connection
function tcp_check(){
    echo ""
    echo "TCP connections on ${server_name}: $(cat  /proc/net/tcp | wc -l)"
    echo ""
}

#Check the exact Kernel version
function kernal_check(){
    echo ""
    echo "Kernel version on ${server_name} is : $(uname -r)"
    echo ""
}

function all_check(){
    memory_check
    cpu_check
    tcp_check
    kernal_check
}

all_check
