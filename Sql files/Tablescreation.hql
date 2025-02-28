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

CREATE TABLE temp_departments (
    dept_id INT,
    department_name STRING,
    location STRING
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE 
LOCATION '/user/hive/warehouse/temp_departments';


LOAD DATA INPATH '/user/hive/warehouse/employees.csv' INTO TABLE temp_employees;
LOAD DATA INPATH '/user/hive/warehouse/departments.csv' INTO TABLE temp_departments;

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

SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT INTO TABLE employees PARTITION(department)
SELECT emp_id, name, age, job_role, salary, project, join_date, department
FROM temp_employees;
