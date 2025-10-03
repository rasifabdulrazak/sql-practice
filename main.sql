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
SELECT ename, COUNT(*) from employee GROUP BY ename ORDER BY COUNT(*) HAVING COUNT(*)>1;

-- 5.Pattern matching in using LIKE operator
-- starts with M
SELECT * FROM employee WHERE enamm LIKE 'M%';
-- ends with N
SELECT * FROM employee WHERE ename LIKE "%N";
-- contains M
SELECT * FROM employee WHERE ename LIKE "%M%";
-- Doesnt contains M at position
SELECT * FROM employee WHERE ename NOT LIKE "%M%";
-- contains M at position 2
SELECT * FROM employee WHERE ename LIKE "_M%";
-- Display name having 4 Characters
SELECT * FROM employee WHERE ename LIKE "____";
-- Display names 2nd letter as L and 4th letter as i
SELECT * FROM employee WHERE ename LIKE "_L_I%";
-- Display enpmloyee name and hire date who had joined in December month
SELECT * FROM employee,hire_date  WHERE hire_date LIKE "%DEC%"
-- Display the names of employee whos name contains exactly 2 'A's
SELECT * FROM employee WHERE ename LIKE "%A%A%" AND ename NOT LIKE "%A%A%A%";
SELECT * FROM employee WHERE ename LIKE "%LL%";
-- Display names of employee whos name starts with S and ends with I
SELECT * FROM employee WHERE ename LIKE "S%I";

-- Display nth row in SQL
SELECT * FROM employee WHERE rownum<=4 MINUS SELECT * FROM employee WHERE rownum<=3;
SELECT * FROM (SELECT rownum r,ename,sal FROM employee) WHERE r=4;
SELECT * FROM (SELECT rownum r,employee.* FROM employee)WHERE r=4;
SELECT * FROM (SELECT rownum r,employee.* FROM employee)WHERE r in (2,3,4);

-- UNION and UNION ALL
SELECT city from customer1 UNION SELECT city from customer2;
SELECT city from customer1 UNION ALL SELECT city from customer2; ---all duplicates are also retruned
SELECT city from customer1 INTERSECT SELECT city from customer2;
SELECT city from customer1 MINUS SELECT city from customer2;

-- INNER JOIN
SELECT empname,sal,dept.deptno,dname,loc FROM employee,dept WHERE employee.deptno=dept.deptno;
-- Display empname and location chichago
SELECT empname,salary,d.deptno,dname,loc FROM employee e, dept d WHERE e.deptno=d.deptno and loc='CHICHAGO';
-- Display total salary from each dept
SELECT d.deptno,dname,SUM(salary) FROM employee e dept d WHERE e.deptno=d.deptno GROUP BY deptno;

-- SELF JOIN
