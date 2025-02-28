INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_8.txt' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT e.*, d.location 
FROM employees e 
JOIN temp_departments d 
ON e.department = d.department_name;
