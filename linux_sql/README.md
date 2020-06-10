# Introduction
(about 150-200 words)
Cluster Monitor Agent is an internal tool that monitors the cluster resources.
It helps the infrastructure team to...

# Quick Start
Use markdown code block for your quick start commands
- Start a psql instance using psql_docker.sh
```bash
DB_USERNAME=postgres
DB_PASSWORD=password
PSQL_HOST=localhost
PSQL_PORT=5432

# Start a psql instance
./scripts/psql_docker.sh create DB_USERNAME DB_PASSWORD"
# Create tables
psql -h PSQL_HOST -U DB_USERNAME DB_PASSWORD
# Insert hardware specs data into host_info table
./scripts/host_info.sh PSQL_HOST PSQL_PORT host_agent DB_USERNAME DB_PASSWORD
# Insert hardware usage data into host_usage table
./scripts/host_usage.sh PSQL_HOST PSQL_PORT host_agent DB_USERNAME DB_PASSWORD
```

We can automate the collection of host usage statistic using crontab.
Open the current crontab for editing by typing `crontab -e`. 
In order to schedule host usage statistic collection every minute type `crontab -e` and input the following

```bash
* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```

`crontab` manual page: https://www.man7.org/linux/man-pages/man5/crontab.5.html

# Architecture Diagram
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to `assets` directory.

# Database Modeling
- `host_info`

| Column name      | Description                                                |
|------------------|------------------------------------------------------------|
| id               | Host's unique identifier                                   |
| hostname         | Host's name                                                |
| cpu_number       | Number of CPUs                                             |
| cpu_architecture | Architecture of CPU                                        |
| cpu_model        | CPU model                                                  |
| cpu_mhz          | CPU frequency (in MHz)                                     |
| L2_cache         | Size of Level 2 cache (in KB)                              |
| total_mem        | Total memory (in KB)                                       |
| timestamp        | Timestamp when host info was taken (time in UTC time zone) |

- `host_usage`

| Column name    | Description                                                            |
|----------------|------------------------------------------------------------------------|
| timestamp      | Timestamp when host usage statistics was taken (time in UTC time zone) |
| host_id        | Host's unique identifier                                               |
| memory_free    | The amount of idle memory (in MB)                                      |
| cpu_idle       | Percentage of time CPU spent idle                                      |
| cpu_kernel     | Percentage of time CPU spent running kernel code                       |
| disk_io        | Number of disk I/O                                                     |
| disk_available | Memory available in the root directory of the hard disk (in MB)        |

## Scripts
Shell script descirption and usage (use markdown code block for script usage)
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql (describe what business problem you are trying to resolve)

## Improvements 

- Visualize cluster resource usage.
- Automatically detect node failures.
- Make a Slack/Discord chat bot for easy monitoring/querying resource usage of Linux nodes.