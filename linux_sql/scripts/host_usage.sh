#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ $# -ne 5 ]; then
  echo "Error: Illegal number of parameters. Usage: ./scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
"
  exit 1
fi

# current timestamp in `2019-11-26 14:40:19` format
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
host_id=1
memory_free=256
cpu_idle=95
cpu_kernel=0
disk_io=0
disk_available=31220

# Insert a row into host_usage table
sql_insert="INSERT INTO host_usage (timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES ('$timestamp', $host_id, $memory_free, $cpu_idle, $cpu_kernel, '$disk_io', $disk_available)"
PGPASSWORD=$psql_password psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -c "$sql_insert"