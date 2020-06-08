psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ $? -ne 5 ]; then
  echo "Error: Illegal number of parameters. Usage: ./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password
"
  exit 1
fi

