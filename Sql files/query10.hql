INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_10.txt' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT emp_id, name, salary, department 
FROM (
    SELECT emp_id, name, salary, department, 
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk 
    FROM employees
) ranked 
WHERE rnk <= 3;