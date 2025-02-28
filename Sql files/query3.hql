INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_3.txt' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' SELECT * FROM employees WHERE project = 'Alpha';
