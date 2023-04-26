#! /usr/bin/bash

hosts_file_location="/etc/hosts";

# Get arguments from CLI.
while getopts m:h:f: flag
do

    case "${flag}" in
        m) master_ipv4=${OPTARG};;
        h) master_hostname=${OPTARG};;
        f) new_hosts_file_location=${OPTARG};;
    esac 

done

# echo $master_ipv4;
# echo $master_hostname;
# echo $new_hosts_file_location;

if [ -z ${master_ipv4+x} ]; 
then 
    
    echo "No master ip provided.";
    exit -1;
fi

if [ -z ${new_hosts_file_location+x} ];
then
    hosts_file_location="/etc/hosts";
else
    hosts_file_location=$new_hosts_file_location;
fi

this_pc_hostname=$(hostname)
ipv4_addr=$(hostname -I)

line_to_search_host=$master_ipv4;
line_to_search_host+=" ";
line_to_search_host+=$master_hostname; 

if grep -Fxq "${line_to_search_host}" $hosts_file_location
then
echo "Master information already present in the hosts file.\n Skipping...";
else
# Write to hosts file.
# Require sudo access.
echo $line_to_search_host >> $hosts_file_location;
fi

export ROS_MASTER_URI=http://${master_ipv4}:11311
export ROS_IP=${ipv4_addr}
#echo export ROS_IP=${master_ipv4}
