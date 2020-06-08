#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5


if [ $# -ne 5 ]; then
  echo "Error: Illegal number of parameters. Usage: ./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password"
  exit 1
fi

lscpu_out=`lscpu`
meminfo_out=`cat /proc/meminfo`


hostname=$(hostname -f)
cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}')
cpu_model=$(echo "($lscpu_out)" | egrep "^Model name:" | awk '{for (i=3; i<NF; i++) print $i}' | xargs)
cpu_mhz=$(echo "($lscpu_out)" | egrep "^CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "($lscpu_out)" | egrep "^L2 cache:" | awk '{print $3}' | xargs | sed 's/[^0-9]*//g')
total_mem=$(echo "($meminfo_out)" | egrep "MemTotal:" | awk '{print $2}' | xargs)

# current timestamp in `2019-11-26 14:40:19` format
timestamp=$(date '+%Y-%m-%d %H:%M:%S')