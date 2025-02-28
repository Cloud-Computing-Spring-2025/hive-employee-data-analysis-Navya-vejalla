INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_6.txt' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT department, emp_count 
FROM (
    SELECT department, COUNT(*) AS emp_count 
    FROM employees 
    GROUP BY department 
) subquery 
ORDER BY emp_count DESC 
LIMIT 1;
