-- 1. Second hihest salay
SELECT MAX(salary) from employee where salary not in (select MAX(salary) from employee);
SELECT MAX(salary) from employee where salary < (select MAX(salary) from employee);

-- 2. Display highest paid employee of each department
SELECT MAX(salary),department from employee GROUP BY department;
SELECT COUNT(*),department from employee GROUP BY department;

-- 3. Display alternate records in sql
SELECT rownum ,employee_id,salary,employee_name FROM employee ORDER BY employee_id;
SELECT * FROM (SELECT emp_no,ename,sal,rownum as rn from employee ORDER BY rn) WHERE mod (rn,2)=0;

-- 4.Find duplicates values and its frequency