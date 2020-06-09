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

# Helper function for extracting data of interest (use the same pipeline of cmd line tools)
function echo_egrep_awk_xargs {
  cmd_out=$1
  egrep_arg=$2
  awk_arg=$3
  echo "$cmd_out" | egrep "$egrep_arg" | awk "$awk_arg" | xargs
}

hostname=$(hostname -f)

cpu_number=$(echo_egrep_awk_xargs "$lscpu_out" "^CPU\(s\):" '{print $2}')
cpu_architecture=$(echo_egrep_awk_xargs "$lscpu_out" "^Architecture:" '{print $2}')
cpu_model=$(echo_egrep_awk_xargs "$lscpu_out" "^Model name:" '{for (i=3; i<NF+1; i++) print $i}')
cpu_mhz=$(echo_egrep_awk_xargs "$lscpu_out" "^CPU MHz:" '{print $3}')
l2_cache=$(echo_egrep_awk_xargs "$lscpu_out" "^L2 cache:" '{print $3}' | sed 's/[^0-9]*//g')
total_mem=$(echo_egrep_awk_xargs "$meminfo_out" "MemTotal:" '{print $2}')

# current timestamp in `2019-11-26 14:40:19` format
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Insert a row into host_info table
sql_insert="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp) VALUES  ('$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, $total_mem, '$timestamp')"
PGPASSWORD=$psql_password psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -c "$sql_insert"

exit $?