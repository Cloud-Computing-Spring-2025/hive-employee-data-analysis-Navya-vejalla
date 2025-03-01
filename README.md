# Hive Setup and Query Execution Guide

This guide provides the necessary steps for setting up Hive on Docker, creating tables, loading data, and executing queries for employee and department data.


### Step 1: Start Docker
Make sure Docker is installed and running on your system. You can verify by running:
```sh
docker --version
```

```sh
docker-compose up -d
```

### Step 2: Access Hive CLI
Once Hive is up, access the Hive CLI using the following:
```sh
docker exec -it hive-server bash
hive
```


## Step 3: Creating Tables and Loading Data

### Create `temp_employees` Table
```sql
CREATE TABLE temp_employees (
    emp_id INT,
    name STRING,
    age INT,
    job_role STRING,
    salary DOUBLE,
    project STRING,
    join_date STRING,
    department STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/temp_employees';
```

### Create `temp_departments` Table
```sql
CREATE TABLE temp_departments (
    dept_id INT,
    department_name STRING,
    location STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/temp_departments';
```

### Load Data into Tables
```sql
LOAD DATA INPATH '/user/hive/warehouse/employees.csv' INTO TABLE temp_employees;
LOAD DATA INPATH '/user/hive/warehouse/departments.csv' INTO TABLE temp_departments;
```

### Create `employees` Table (Partitioned by department)
```sql
CREATE TABLE employees (
    emp_id INT,
    name STRING,
    age INT,
    job_role STRING,
    salary DOUBLE,
    project STRING,
    join_date STRING
)
PARTITIONED BY (department STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```
```sql
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
```

### Insert Data from `temp_employees` into `employees`
```sql
INSERT INTO TABLE employees PARTITION(department)
SELECT emp_id, name, age, job_role, salary, project, join_date, department
FROM temp_employees;
```

### Manually Add Partitions Based on Department Values
```sql
ALTER TABLE employees ADD PARTITION (department='Sales');
ALTER TABLE employees ADD PARTITION (department='Engineering');
ALTER TABLE employees ADD PARTITION (department='HR');
ALTER TABLE employees ADD PARTITION (department='Finance');
ALTER TABLE employees ADD PARTITION (department='Marketing');
ALTER TABLE employees ADD PARTITION (department='Operations');
```

## Step 4 : Running Queries and Exporting Results

### Query 1: Employees Who Joined After 2015
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_1.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees WHERE year(join_date) > 2015;
```

### Query 2: Average Salary by Department
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_2.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department;
```

### Query 3: Employees Working on 'Alpha' Project
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_3.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees WHERE project = 'Alpha';
```

### Query 4: Count of Employees by Job Role
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_4.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT job_role, COUNT(*) FROM employees GROUP BY job_role;
```

### Query 5: Employees Earning More Than Department Average Salary
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_5.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT e.*
FROM employees e
JOIN (
    SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department
) avg_dept
ON e.department = avg_dept.department
WHERE e.salary > avg_dept.avg_salary;
```

### Query 6: Department with Most Employees
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_6.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT department, emp_count
FROM (
    SELECT department, COUNT(*) AS emp_count
    FROM employees
    GROUP BY department
) subquery
ORDER BY emp_count DESC
LIMIT 1;
```

### Query 7: Filter Out Employees with Null Values
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_7.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees
WHERE emp_id IS NOT NULL
AND name IS NOT NULL
AND age IS NOT NULL
AND job_role IS NOT NULL
AND salary IS NOT NULL
AND project IS NOT NULL
AND join_date IS NOT NULL
AND department IS NOT NULL;
```

### Query 8: Employees with Department Locations
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_8.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT e.*, d.location
FROM employees e
JOIN temp_departments d
ON e.department = d.department_name;
```

### Query 9: Salary Rank of Employees
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_9.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT emp_id, name, salary, department,
RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees;
```

### Query 10: Top 3 Highest Paid Employees in Each Department
```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/output_results/query_10.txt'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT emp_id, name, salary, department
FROM (
    SELECT emp_id, name, salary, department,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) ranked
WHERE rnk <= 3;
```

