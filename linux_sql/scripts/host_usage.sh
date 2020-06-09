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

df_out=`df -BM /`
vmstat_out=`vmstat -t --unit M`

hostname=$(hostname -f)

# current timestamp in `2019-11-26 14:40:19` format
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
memory_free=$(echo "$vmstat_out" | awk '{print $4}' | egrep -o '[0-9]*')
cpu_idle=$(echo "$vmstat_out" | awk '{print $15}' | egrep -o '[0-9]*')
cpu_kernel=$(echo "$vmstat_out" | awk '{print $14}' | egrep -o '[0-9]*')
disk_io=$(vmstat -d | awk '{print $10}' | egrep -o '[0-9]*')
disk_available=$(echo "$df_out" | awk '{print $4}' | egrep -o '[0-9]*')

# Precondition: corresponding host_info row exists
sql_select="SELECT id FROM host_info WHERE hostname='$hostname'"

# Insert a row into host_usage table
sql_insert="INSERT INTO host_usage (timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES ('$timestamp', ($sql_select), $memory_free, $cpu_idle, $cpu_kernel, '$disk_io', $disk_available)"
PGPASSWORD=$psql_password psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -c "$sql_insert"

exit $?