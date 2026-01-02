#!/bin/bash

# Description: Collects disk usage, CPU usage, RAM usage, and kernel version
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
function kernel_check(){
    echo ""
    echo "Kernel version on ${server_name} is : $(uname -r)"
    echo ""
}

function all_check(){
    memory_check
    cpu_check
    tcp_check
    kernel_check
}

##
# color variables
##
green='\e[32m'
blue='\e[34m'
red='\e[31m'
clear='\e[0m'

##
# color functions
##

function color_green(){
    echo -ne ${green}${1}${clear}
}

function color_blue(){
    echo -ne ${blue}${1}${clear}
}

function menu(){
    echo -ne "
    My First Menu
    $(color_green '1)') Memory usage
    $(color_green '2)') CPU load
    $(color_green '3)') Number of TCP connections 
    $(color_green '4)') Kernel version
    $(color_green '5)') Check All
    $(color_green '0)') Exit
    $(color_blue 'Choose an option:') "
    read a

    case $a in
        0) exit 0 ;;
        1) memory_check ; menu ;;
        2) cpu_check ; menu ;;
        3) tcp_check ; menu ;;
        4) kernel_check ; menu ;;
        5) all_check ; menu ;;
        *) echo -e "${red}Wrong option.${clear}"; menu ;;
    esac
}

# Call the menu function
menu
