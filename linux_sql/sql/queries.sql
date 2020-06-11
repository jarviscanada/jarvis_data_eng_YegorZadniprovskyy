-- Group hosts by hardware info
SELECT
  cpu_number,
  id AS host_id,
  total_mem
FROM
  host_info
ORDER BY
  cpu_number ASC,
  total_mem DESC;

-- Average memory usage
-- https://stackoverflow.com/questions/7299342/what-is-the-fastest-way-to-truncate-timestamps-to-5-minutes-in-postgres
SELECT
  host_id,
  hostname,
  time_interval AS timestep,
  total_mem,
  memory_free,
  AVG(used_mem_percentage) OVER (PARTITION BY time_interval) AS avg_used_mem_percentage
FROM
  (
    SELECT
      host_id,
      hostname,
      total_mem,
      memory_free,
      (total_mem - memory_free * 1024)::float / total_mem AS used_mem_percentage,
      date_trunc('hour', host_usage.timestamp) + date_part('minute', host_usage.timestamp):: int / 5 * interval '5 min' AS time_interval
    FROM
      host_usage
      JOIN host_info ON host_usage.host_id = host_info.id
  ) AS sub_table;
