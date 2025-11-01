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
--# guest - name, email, country, guest_id -g
--# hotels - name, city, star_rating, hotel_id -ht
--# bookings - guest_id, hotel_id, check_in, check_out, status  -b
---# booking_charges - booking_id, charge_date, amount  -bc
----- SQL Query
SELECT g.name,SUM(bc.amount) as total_amount
FROM guest g
JOIN bookings b ON g.guest_id=b.guest_id
JOIN hotels ht ON b.hotel_id=ht.hotel_id
JOIN booking_charges bc on bc.booking_id=b.bookung_id
WHERE ht.name='ABC' AND b.status='completed'
GROUP BY g.guest_id,g.name
ORDER BY total_amount DESC
LIMIT 2;



-- Most number of bookings in Taj Hotel
-- SQL Query
SELECT g.name,COUNT(b.booking_id) as total_bookings
FROM guest g
JOIN bookings b on b.guest_id = g.guest_id
JOIN hotels ht on ht.hotel_id = b.hotel_id
WHERE ht.name="Taj Hotel" and b.status="completed"
GROUP BY g.guest_id,g.name
ORDER BY total_bookings DESC
LIMIT 1;

-- Guests activesly staying in any hotel today
-- SQL Query
SELECT g.name,b.check_in,b.check_out,ht.name
FROM guest g
JOIN bookings b on b.guest_id = g.guest_id
WHERE CURRENT_DATE() BETWEEN b.check_in AND b.check_out

-- Total revenue generated by city wise
-- SQL Query
SELECT ht.city,SUM(bc.amount) as total_amount
FROM hotels ht
JOIN bookings b on b.hotel_id = ht.hotel_id
JOIN booking_charges bc on bc.booking_id = b.booking_id
GROUP BY ht.city
ORDER BY total_amount DESC


-- Guest with longest stay in any hotel
-- SQL Query
SELECT g.guest_id,g.guest_name,(b.check_out - b.check_in) as stay_length
FROM guest g 
JOIN bookings b on b.guest_id = g.guest_id
ORDER BY stay_length DESC
LIMIT 1;

-- Average stay duration for guests in each hotel
-- SQL Query
SELECT ht.name,AVG(b.check_out - b.check_in) as avg_stay_duration
FROM hotels ht
JOIN bookings b on b.hotel_id = ht.hotel_id
GROUP BY ht.hotel_id,ht.name
ORDER BY avg_stay_duration DESC;


-- Hotels with highest number of cancelled bookings
-- SQL Query
SELECT ht.name,COUNT(b.booking_id) as total_bbokings
FROM hotels ht
JOIN bookings b on b.hotel_id = ht.hotel
WHERE b.status="cancelled"
GROUP BY ht.hotel_id,ht.name
ORDER BY total_bookings DESC;

-- Guests who have stayed in more than 3 different hotels
-- SQL Query
SELECT g.name,COUNT(DISTINCT b.hotel_id) as hotel_count
FROM guest g
JOIN bookings b on b.guest_id = g.guest_id
GROUP BY g.guest_id,g.name
HAVING hotel_count>3
ORDER BY hotel_count DESC;


-- Hotels that have never had a booking
-- SQL Query
SELECT ht.name,ht.city
FROM hotels ht
LEFT JOIN bookings b on b.hotel_id = ht.hotel_id
WHERE b.booking_id IS NULL;



----Matching values to a seperate coloumn in SQL ("rasif","apple,orange,banana") => person=>rasif ,apple=>yes,orange=>yes,banana=>yes
SELECT person
CASE WHEN basket LIKE "%apple%" THEN "yes" ELSE "no" END AS apple,
CASE WHEN basket LIKE "%orange%" THEN "yes" ELSE "no" END AS orange,
CASE WHEN basket LIKE "%banana%" THEN "yes" ELSE "no" END AS banana
FROM fruits;

SELECT person,
IF (FIND_IN_SET("apple",basket)>0,"Yes","No") AS appple,
IF (FIND_IN_SET("orange",basket)>0,"Yes","No") AS orange
IF (FIND_IN_SET("banana",basket)>0,"Yes","No") AS banana
FROM fruits;


SELECT name,
CONCAT(name,"-",substring(job,1,1)) AS new_name
FROM employee;


-- Question
-- Tables:
    -- 1️⃣ employees(emp_id, emp_name, manager_id, dep_id, salary, hire_date)
    -- 2️⃣ departments(dep_id, dep_name, location)
    -- 3️⃣ customers(cust_id, cust_name, city,email)
    -- 4️⃣ products(prod_id, prod_name, category, price)
    -- 5️⃣ orders(order_id, cust_id, emp_id, order_date, amount)
    -- 6️⃣ order_items(order_item_id, order_id, prod_id, quantity)
    -- 7️⃣ payments(payment_id, order_id, payment_date, amount, payment_method)
    -- 7️⃣ productsreview(review_id, product_id, cust_id, rating, review_text)

-- Questions:
-- 🟢 Level 1 – Basic Joins

-- 1️⃣ List all orders with customer names and order dates.
-- (JOIN: orders + customers)

SELECT c.cust_name,o.order_date FROM customers c
INNER JOIN orders o on o.cust_id = c.cust_id

-- 2️⃣ Fetch all employees along with their department names.
-- (JOIN: employees + departments)
SELECT e.*,d.dep_name from employees e 
INNER JOIN department d on d.dep_id = e.dep_id

-- 3️⃣ Show product name, category, and quantity sold in each order.
-- (JOIN: order_items + products)
SELECT p.product_name,o.category,SUM(oi.quantity) FROM orders o
JOIN order_items oi on oi.order_id=o.order_id
JOIN products p on p.prod_id = oi.prod_id

-- 🟡 Level 2 – Intermediate Joins

-- 4️⃣ List customer names and their total order amount.
-- (JOIN: customers + orders, use SUM and GROUP BY)
SELECT c.customer_name,SUM(o.amount) FROM customers c 
JOIN orders o on o.customer_id = c.customer_id
GROUP BY c.customer_name

-- 5️⃣ Get all orders handled by employees working in the 'Marketing' department.
-- (JOIN: orders + employees + departments)
SELECT * from orders o
JOIN employees e on e.emp_id = o.emp_id
JOIN departments d on d.dept_id=e.dept_id
WHERE d.name ='Marketing'


-- 6️⃣ Find all customers who ordered at least one 'Electronics' product.
-- (JOIN: customers + orders + order_items + products, DISTINCT)
SELECT * FROM customers WHERE cust_id IN ( 
SELECT DISTINCT cust_id from orders
)
-- 7️⃣ Show each product’s average review rating.
-- (JOIN: product_reviews + products, GROUP BY)
SELECT p.name AVG(pr.rating) FROM products p
JOIN product_reviews pr on pr.prod_id=p.prod_id
GROUP BY p.name

-- 8️⃣ Find all employees who have subordinates (self join on employees).
-- (JOIN: employees e1 + employees e2 WHERE e1.emp_id = e2.manager_id)
SELECT e1.name FROM employees e1
JOIN employees e2 on e1.emp_id = e2.emp_id
WHERE e1.emp_id = e2.manager_id

-- 🟠 Level 3 – Advanced Analytical Joins

-- 9️⃣ Get top 3 customers by total amount spent.
-- (JOIN: customers + orders, GROUP BY + ORDER BY + LIMIT)
SELECt c.cust_id,c.name,SUM(o.total_amount) as total_spent FROM customers c 
JOIN orders o on o.customer_id = c.customer_id
GROUP BY c.cust_id,c.name
ORDER BY total_spent DESC
LIMIT 3

-- 🔟 List all customers who made payments using ‘UPI’.
-- (JOIN: customers + orders + payments)
SELECT c.customer_id,c.name FROM customers c 
JOIN orders o on o.customer_id = c.customer_id
JOIN payments p on p.order_id = o.order_id
WHERE p.method = 'UPI'

-- 11️⃣ Find products never ordered by any customer.
-- (LEFT JOIN: products LEFT JOIN order_items WHERE order_id IS NULL)
SELECT prod_id,name FROM products WHERE prod_id NOT IN(
SELECT DISTINCT prod_id FROM orderitems
)
SELECT p.name FROM products p 
LEFT JOIN order_items oi on oi.product_id=p.product_id
WHERE p.product_id=NULL

-- 12️⃣ Find average rating for each product category (need multi-join).
-- (JOIN: product_reviews + products GROUP BY category)
SELECT p.category , AVG(pr.rating) FROM products p 
JOIN product_reviews pr ON pr.product_id = p.product_id
GROUP BY p.category


-- 13️⃣ Get total revenue per department (based on orders handled by their employees).
-- (JOIN: orders + employees + departments, GROUP BY department)
SELECT dept.dept_name , SUM(o.total_amount)  FROM departments dept
JOIN employees e ON e.dept_id = dept.dept_id
JOIN orders o ON o.emp_id = e.emp_id
GROUP BY dept.dept_name

-- 🔵 Level 4 – Expert Multi-Joins

-- 14️⃣ For each customer, show: total orders, total amount spent, and average payment amount.
-- (JOIN: customers + orders + payments, GROUP BY customer_id)
SELECT c.customer_id,c.name,COUNT(o.order_id) as total_order,SUM(o.total_amount) as total_amount,AVG(p.amount) as avg_paid FROM customers c 
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments p ON p.order_id = o.order_id
GROUP BY c.customer_id, c.name;

-- 15️⃣ Show the best-selling product (highest total quantity sold).
-- (JOIN: order_items + products, GROUP BY product_id ORDER BY SUM(quantity))
SELECT p.product_id,p.product_name,SUM(oi.quantity) as qauntity_sold FROM products p 
JOIN order_items oi on oi.product_id = p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY qauntity_sold DESC


-- 16️⃣ Find the employee with the highest total sales (sum of order amounts).
-- (JOIN: employees + orders, GROUP BY emp_id)
SELECT e.employee_id,e.name ,SUM(o.total_amount) as total_sales FROM employees e 
JOIN orders o ON o.emp_id = e.emp_id
GROUP BY e.employee_id,e.name
ORDER BY total_sales;

-- 17️⃣ Show all employees who have handled orders for customers from their own city (cross join logic).
-- (JOIN: employees + orders + customers, match by location/city)

-- 18️⃣ List departments that have not made any sales (via their employees).
-- (LEFT JOIN: departments LEFT JOIN employees LEFT JOIN orders WHERE order_id IS NULL)

-- 🟣 Level 5 – Expert Challenges

-- 19️⃣ Find customers who reviewed a product but never purchased it.
-- (LEFT JOIN product_reviews + orders → FILTER missing match)

-- 20️⃣ Get top-rated product in each category (use window function).
-- 21️⃣ Get cumulative revenue by month (window function).

-- 22️⃣ Find the manager who manages employees with the highest combined salary.
-- (Self JOIN employees on manager_id, GROUP BY manager)

-- 23️⃣ Show the most profitable product category based on sales amount.
-- (JOIN: order_items + products, SUM(price * quantity), GROUP BY category)

-- 24️⃣ Get the average order value per city.
-- (JOIN: orders + customers, GROUP BY city)

-- 25️⃣ Find employees who handled orders worth more than their own salary.
-- (JOIN: employees + orders, HAVING SUM(total_amount) > salary)


-- Window functions
-- -----------------------------------------------------------------------------------------------------
-- sale_id	    employee_id	    region	    sale_date	    amount
--      1	            101	      East	    2024-01-02	       200
--      2	            101	      East	    2024-01-05	       500
--      3	            102	      West	    2024-01-03	       400
--      4	            102	      West	    2024-01-10	       600
--      5	            103	      East	    2024-01-04	       300
--      6	            101       East	    2024-02-01	       700
--      7	            102	      West	    2024-02-05	       800
--      8	            103	      East	    2024-02-08	       1000

-- 🔹 Q1. Find the top 2 sales per region by amount.
-- Goal: Rank sales within each region and return the top 2 per region.

-- 🔹 Q2. Compute the running total of sales per employee ordered by date.
-- Goal: Show how much each employee has cumulatively sold up to each date.

-- 🔹 Q4. Find employees whose latest sale is their personal highest.
-- Goal: Use both MAX() and FIRST_VALUE() window logic.

-- 🔹 Q5. Compute the % contribution of each sale to monthly regional total.
-- Goal: Find how much each sale contributes to its region’s monthly sales sum.

-- 🔹Q6. Find 3-month rolling average sales per region (by sale_date).




-- Master window functions
-- employees(emp_id, emp_name, department, salary, join_date)
-- sales(sale_id, emp_id, sale_amount, sale_date, region)
-- orders(order_id, customer_id, order_date, total_amount)
-- customers(customer_id, customer_name, city)

-- 🧠 Beginner Level (Understand Ranking and Row Numbering)

-- Find the top 3 highest-paid employees per department.
-- 👉 Use: RANK() or DENSE_RANK() with PARTITION BY department ORDER BY salary DESC.

-- Assign a unique sequence number to each employee ordered by salary (within their department).
-- 👉 Use: ROW_NUMBER() vs RANK() — note the difference when duplicates exist.

-- List employees whose salary rank is within top 10 across the whole company.
-- 👉 Use: RANK() without partition.

-- Show the employee with the second-highest salary per department.
-- 👉 Use: Subquery with RANK() or DENSE_RANK() filter WHERE rank = 2.

-- Find employees who joined earliest in each department.
-- 👉 Use: FIRST_VALUE(join_date) or MIN(join_date) with OVER(PARTITION BY).

-- ⚙️ Intermediate Level (Lead/Lag and Moving Aggregates)

-- Find the previous and next salary for each employee (based on salary order within department).
-- 👉 Use: LAG(salary) and LEAD(salary) with partition.

-- Calculate the difference between each employee’s salary and the previous employee’s salary (within department).
-- 👉 Use: salary - LAG(salary).

-- Find each month’s sales and the growth compared to the previous month per region.
-- 👉 Use: LAG(sales_amount) and compute growth percentage.

-- Find customers whose current order amount is less than their previous order amount.
-- 👉 Use: LAG(total_amount) and compare.

-- For each salesperson, show their total sales and the running total by sale_date.
-- 👉 Use: SUM(sale_amount) OVER(PARTITION BY emp_id ORDER BY sale_date).

-- 💡 Advanced Level (NTILE, FIRST_VALUE, LAST_VALUE, Cumulative & Sliding Windows)

-- Divide employees in each department into 4 salary bands (quartiles).
-- 👉 Use: NTILE(4) OVER(PARTITION BY department ORDER BY salary DESC).

-- Find the first and last sale amount per employee in each region.
-- 👉 Use: FIRST_VALUE(sale_amount) and LAST_VALUE(sale_amount) with frame specification.

-- Calculate the rolling 3-month average sales for each region.
-- 👉 Use: AVG(sale_amount) OVER(PARTITION BY region ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW).

-- Find for each employee, how many employees earn more than them in their department.
-- 👉 Use: COUNT(*) OVER(PARTITION BY department ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) or self join.

-- Compute the cumulative percentage of salary by department.
-- 👉 Use: SUM(salary) OVER(PARTITION BY department ORDER BY salary) divided by total per department.

-- 🧮 Expert Level (Combining Multiple Window Functions)

-- Find the employee who contributed the highest sales each month.
-- 👉 Combine: SUM(sale_amount) OVER(PARTITION BY emp_id, month) + RANK().

-- Compare each employee’s salary with department average and company average.
-- 👉 Use two window aggregates:
-- AVG(salary) OVER(PARTITION BY department) and AVG(salary) OVER().

-- For each department, show employees who have more than average salary of that department.
-- 👉 Use: AVG(salary) OVER(PARTITION BY department) and filter.

-- Find customers who are in the top 10% of total order value.
-- 👉 Use: NTILE(10) and filter tile = 1.

-- Show month-over-month cumulative sales trend for each region and percentage change from previous month.
-- 👉 Use:

-- SUM(sales_amount) OVER(PARTITION BY region ORDER BY month)

-- LAG() for previous cumulative

-- % growth = (current - previous)/previous * 100

-- 🧩 Bonus Challenge:

-- Create your own metric:

-- “For each employee, compute the difference between their salary and the median salary in their department.”

-- 👉 Hint: Use a CTE with PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) + OVER (PARTITION BY department) (supported in PostgreSQL, Snowflake, etc.)