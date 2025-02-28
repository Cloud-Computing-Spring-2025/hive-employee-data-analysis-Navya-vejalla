INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_1.txt' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' SELECT * FROM employees WHERE year(join_date) > 2015;
