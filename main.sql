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
-- More salary than manager
SELECT e1.empname,e1.salary,e2.empname as manager,e2.salary as manager_salary FROM employee e1,employee e2 WHERE e1.mgr=e2.empid AND e1.salary>e2.salary;
-- Employee and his manager
SELECT e1.empname as employee,e2.empname as manager FROM employee e1,employee e2 WHERE e1.mgr=e2.emp_no;

-- LEFT JOIN SQL
-- All rows from left table
-- Macthing values from right table
-- Null values in place of non macthing rows in other table
SELECT rownum,empno,empname,employee.deptno,dname,loc,job FROM employee LEFT JOIN dept ON employee.deptno = dept.deptno and dname="chaichao";

-- RIGHT JOIN SQL
-- All rows from right table    
-- Macthing values from left table
-- Null values in place of non macthing rows in other table
SELECT empname,job,sal,loc,dname,dept.deptno FROM employee RIGHT JOIN dept ON dept.deptno=employee.deptno;

-- FULL JOIN SQL
-- All rows from both tables
-- Macthing values from both tables
-- Null values in place of non macthing rows in tables
SELECT empname ,sal,d.deptno,e.deptno,dname,loc FROM employee e FULL JOIN dept d ON d.deptno = e.deptno;


-- Cross Join in SQL
-- Cartesian product of both tables
-- cross product operation performed
SELECT empname,d.deptno,sal,dname,loc FROM employee e CROSS JOIN dept d;


-- Display first n rows or last n rows in SQL
SELECT * FROM employee WHERE rownum<=3; -- first 3 rows
SELECT * FROM (SELECT * FROM employee ORDER BY empid DESC) WHERE rownum<=3; -- last 3 rows


-- Nth highest salary
SELECT DISTINCT salary FROM employee ORDER BY salary DESC OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY; -- 2nd highest
SELECT DISTINCT salary FROM employee ORDER BY salary DESC OFFSET 3 ROWS FETCH NEXT 1 ROWS ONLY; -- 4th highest
SELECT DISTINCT salary FROM employee ORDER BY salary DESC OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY; -- 5th highest


--Intersection in SQL
-- return common records from both tables
SELECT city FROM customer1 INTERSECT SELECT city FROM customer2;


--MINUS in SQL
-- return records from first table which are not in second table
SELECT city FROM customer1 MINUS SELECT city FROM customer2;


--Frist Normal Form (1NF)
-- Atomic values
-- No repeating groups
-- Each column contains unique values
-- Each record is unique
-- Each column contains values of a single type
-- Each column must contain values of a single type


---You have 4 tables - customer(name),hotel(name),bookings(customer_id,hotel_id) and booking charges(hotel_id,amount). Write SQL query to perform top 2 customer who has spent the most money in hotel ABC.
---# Tables 
--# guest - name, email, country, guest_id 
--# hotels - name, city, star_rating, hotel_id 
--# bookings - guest_id, hotel_id, check_in, check_out, status 
---# booking_charges - booking_id, charge_date, amount