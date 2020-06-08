#!/bin/bash

# Setup arguments
cmd=$1
db_username=$2
db_password=$3

# if docker deamon is not running start it
systemctl status docker || systemctl start docker

if [ "$cmd" == "create" ]; then
  # if jrvs-psql is already created
  if [ $(docker container ls -a -f name=jrvs-psql | wc -l) -eq 2 ]; then
    echo "jrvs-psql already created"
    exit 1
  fi

  if [ "$#" -lt 3 ]; then
    echo "Error: Illegal number of parameters. Usage: ./scripts/psql_docker.sh start|stop|create [db_username][db_password]"
    exit 1
  fi

  docker pull postgres
  docker volume create pgdata
  docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
  exit $?
fi

# TODO: better option would be to use switch
if [ $(docker container ls -a -f name=jrvs-psql | wc -l) -eq 1 ]; then
    echo "Error: jrvs-psql is not created"
    exit 1
  fi

if [ "$cmd" == "start" ]; then
  docker container start jrvs-psql
  exit $?
fi

if [ "$cmd" == "stop" ]; then
  docker container stop jrvs-psql
  exit $?
fi

echo "Error: Invalid command name. Usage: ./scripts/psql_docker.sh start|stop|create [db_username][db_password]"
exit 1