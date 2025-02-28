INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_4.txt' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' SELECT job_role, COUNT(*) FROM employees GROUP BY job_role;
