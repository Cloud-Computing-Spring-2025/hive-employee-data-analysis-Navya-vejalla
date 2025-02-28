INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_7.txt' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT * FROM employees 
WHERE emp_id IS NOT NULL 
AND name IS NOT NULL 
AND age IS NOT NULL 
AND job_role IS NOT NULL 
AND salary IS NOT NULL 
AND project IS NOT NULL 
AND join_date IS NOT NULL 
AND department IS NOT NULL;
