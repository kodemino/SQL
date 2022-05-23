-- SQL Exercises 8 - Subqueries
-- Medium post: https://medium.com/@aadata/sql-exercises-8-subqueries-2b67ba44c7d9

-- Tables
-- customer
-- customer_id |   cust_name    |    city    | grade | salesman_id 
---------------+----------------+------------+-------+-------------
--        3002 | Nick Rimando   | New York   |   100 |        5001
--        3007 | Brad Davis     | New York   |   200 |        5001
--        3005 | Graham Zusi    | California |   200 |        5002
--        3008 | Julian Green   | London     |   300 |        5002
--        3004 | Fabian Johnson | Paris      |   300 |        5006
--        3009 | Geoff Cameron  | Berlin     |   100 |        5003
--        3003 | Jozy Altidor   | Moscow     |   200 |        5007
--        3001 | Brad Guzan     | London     |       |        5005

-- orders
-- ord_no      purch_amt   ord_date    customer_id  salesman_id
-------------  ----------  ----------  -----------  -----------
-- 70001       150.5       2012-10-05  3005         5002
-- 70009       270.65      2012-09-10  3001         5005
-- 70002       65.26       2012-10-05  3002         5001
-- 70004       110.5       2012-08-17  3009         5003
-- 70007       948.5       2012-09-10  3005         5002
-- 70005       2400.6      2012-07-27  3007         5001
-- 70008       5760        2012-09-10  3002         5001
-- 70010       1983.43     2012-10-10  3004         5006
-- 70003       2480.4      2012-10-10  3009         5003
-- 70012       250.45      2012-06-27  3008         5002
-- 70011       75.29       2012-08-17  3003         5007
-- 70013       3045.6      2012-04-25  3002         5001

-- salesman
-- salesman_id  name        city        commission
--------------  ----------  ----------  ----------
-- 5001         James Hoog  New York    0.15
-- 5002         Nail Knite  Paris       0.13
-- 5005         Pit Alex    London      0.11
-- 5006         Mc Lyon     Paris       0.14
-- 5003         Lauson Hen  San Jose    0.12
-- 5007         Paul Adam   Rome        0.13

-- company_mast
-- COM_ID COM_NAME
--------- -------------
--     11 Samsung
--     12 iBall
--     13 Epsion
--     14 Zebronics
--     15 Asus
--     16 Frontech

-- item_mast
-- PRO_ID PRO_NAME                       PRO_PRICE    PRO_COM
--------- ------------------------- -------------- ----------
--    101 Mother Board                    3200.00         15
--    102 Key Board                        450.00         16
--    103 ZIP drive                        250.00         14
--    104 Speaker                          550.00         16
--    105 Monitor                         5000.00         11
--    106 DVD drive                        900.00         12
--    107 CD drive                         800.00         12
--    108 Printer                         2600.00         13
--    109 Refill cartridge                 350.00         13
--    110 Mouse                            250.00         12

-- emp_department
-- DPT_CODE DPT_NAME        DPT_ALLOTMENT
---------- --------------- -------------
--      57 IT                      65000
--      63 Finance                 15000
--      47 HR                     240000
--      27 RD                      55000
--      89 QC                      75000

-- emp_details
-- EMP_IDNO EMP_FNAME       EMP_LNAME         EMP_DEPT
----------- --------------- --------------- ----------
--   127323 Michale         Robbin                  57
--   526689 Carlos          Snares                  63
--   843795 Enric           Dosio                   57
--   328717 Jhon            Snares                  63
--   444527 Joseph          Dosni                   47
--   659831 Zanifer         Emily                   47
--   847674 Kuleswar        Sitaraman               57
--   748681 Henrey          Gabriel                 47
--   555935 Alex            Manuel                  57
--   539569 George          Mardy                   27
--   733843 Mario           Saule                   63
--   631548 Alan            Snappy                  27
--   839139 Maria           Foster                  57

-- Queries
-- 1. From the salesman and orders tables, find all the orders issued by the salesman ‘Paul Adam’. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT *
FROM orders
WHERE salesman_id = (SELECT salesman_id FROM salesman WHERE name = ‘Paul Adam’)

-- 2. From the salesman and orders tables, find all the orders, which are generated by those salespeople, who live in the city of London.Return ord_no, purch_amt, ord_date, customer_id, salesman_id.
SELECT *
FROM orders
WHERE salesman_id IN (SELECT salesman_id FROM salesman WHERE city = ‘London’)

-- 3. From the orders table, find the orders generated by the salespeople who works for customers whose id is 3007. Return ord_no, purch_amt, ord_date, customer_id, salesman_id. A customer can works only with a salespeople.
SELECT *
FROM orders
WHERE salesman_id = (SELECT salesman_id FROM orders WHERE customer_id = 3007)

-- 4. From the orders table, find the order values greater than the average order value of 10th October 2012. Return ord_no, purch_amt, ord_date, customer_id, salesman_id.
SELECT *
FROM orders
WHERE purch_amt > (SELECT AVG(purch_amt) FROM orders WHERE ord_date = ‘2012–10–10’)

-- 5. From the salesman and orders tables, find all the orders generated in New York city. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT *
FROM orders
WHERE salesman_id IN (SELECT salesman_id FROM salesman WHERE city = ‘New York’)

-- 6. From the customer and salesman tables, find the commission of the salespeople work in Paris City. Return commission.
SELECT commission
FROM salesman
WHERE salesman_id IN (SELECT salesman_id FROM customer WHERE city = ‘Paris’)

-- 7. Write a query to display all the customers whose id is 2001 bellow the salesman ID of Mc Lyon.
SELECT *
FROM customer
WHERE customer_id = (SELECT salesman_id — 2001 FROM salesman WHERE name = ‘Mc Lyon’)

-- 8. From the customer table, count number of customers with grades above the average grades of New York City. Return grade and count.
SELECT grade, COUNT(grade)
FROM customer
WHERE grade > (SELECT AVG(grade) FROM customer WHERE city = ‘New York’)
GROUP BY grade

-- 9. From the salesman and orders tables, find those salespeople who earned the maximum commission. Return ord_no, purch_amt, ord_date, and salesman_id.
SELECT ord_no, purch_amt, ord_date, salesman_id
FROM orders
WHERE salesman_id IN (SELECT salesman_id FROM salesman WHERE commission = (SELECT MAX(commission) FROM salesman))

-- 10. From the customer and orders tables, find the customers whose orders issued on 17th August, 2012. Return ord_no, purch_amt, ord_date, customer_id, salesman_id and cust_name.
SELECT o.*, c.cust_name
FROM orders AS o
JOIN customer AS c
ON o.customer_id = c.customer_id
AND o.salesman_id = c.salesman_id
WHERE o.customer_id IN (SELECT customer_id FROM orders WHERE ord_date = '2012-08-17')
AND o.ord_date = '2012-08-17'

-- 11. From the customer and salesman tables, find the salespeople who had more than one customer. Return salesman_id and name.
SELECT salesman_id, name
FROM salesman
WHERE salesman_id IN (SELECT salesman_id FROM customer GROUP BY salesman_id HAVING COUNT(salesman_id) > 1)

-- 12. From the orders table, find those orders, which amount is higher than the average amount of the related customer. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT o.* FROM
orders AS o
JOIN
(
SELECT customer_id, AVG(purch_amt) AS avg
FROM orders
GROUP BY customer_id
) AS c
ON o.customer_id = c.customer_id
WHERE o.purch_amt > c.avg

-- 13. From the orders table, find those orders, which are equal or higher than average amount of the orders. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT *
FROM orders
WHERE purch_amt >= (SELECT AVG(purch_amt) FROM orders)

-- 14. Write a query to find the sums of the amounts from the orders table, grouped by date, eliminating all those dates where the sum was not at least 1000.00 above the maximum order amount for that date.
SELECT s.*
FROM
(
SELECT ord_date, SUM(purch_amt) AS sum
FROM orders
GROUP BY ord_date
) AS s
JOIN
(
SELECT ord_date, MAX(purch_amt) + 1000 AS pmax
FROM orders
GROUP BY ord_date
) AS m
ON s.ord_date = m.ord_date
WHERE s.sum >= m.pmax

-- 15. Write a query to extract all data from the customer table if and only if one or more of the customers in the customer table are located in London.
SELECT *
FROM customer
WHERE EXISTS (SELECT city FROM customer WHERE city = ‘London’)

-- 16. From the customer and salesman tables, find the salespeople who deal multiple customers. Return salesman_id, name, city and commission.
SELECT *
FROM salesman
WHERE salesman_id IN (SELECT salesman_id FROM customer GROUP BY salesman_id HAVING COUNT(salesman_id) > 1)

-- 17. From the customer and salesman tables, find the salespeople who deal a single customer. Return salesman_id, name, city and commission.
SELECT *
FROM salesman
WHERE salesman_id IN (SELECT salesman_id FROM customer GROUP BY salesman_id HAVING COUNT(salesman_id) = 1)

-- 18. From the salesman and orders tables, find the salespeople who deal the customers with more than one order. Return salesman_id, name, city and commission.
SELECT *
FROM salesman
WHERE salesman_id IN (SELECT salesman_id FROM orders GROUP BY salesman_id HAVING COUNT(salesman_id) > 1)

-- 19. From the customer and salesman tables, find the salespeople who deals those customers who live in the same city. Return salesman_id, name, city and commission.
SELECT *
FROM salesman
WHERE salesman_id IN (SELECT s.salesman_id FROM salesman AS s JOIN customer AS c ON s.salesman_id = c.salesman_id WHERE s.city = c.city)

-- 20. From the customer and salesman tables, find the salespeople whose place of living (city) matches with any of the city where customers live. Return salesman_id, name, city and commission.
SELECT *
FROM salesman
WHERE city IN (SELECT city FROM customer)

-- 21. From the orders table, find all those orders whose order amount greater than at least one of the orders of September 10th 2012. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT *
FROM orders
WHERE purch_amt > ANY(SELECT purch_amt FROM orders WHERE ord_date = ‘2012–09–10’)

-- 22. From the customer and orders tables, find those orders where an order amount less than any order amount of a customer lives in London City. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT *
FROM orders
WHERE purch_amt < ANY(SELECT purch_amt FROM orders AS o JOIN customer AS c ON o.customer_id = c.customer_id WHERE c.city = ‘London’)

-- 23. From the customer and orders tables, find those orders where every order amount less than the maximum order amount of a customer lives in London City. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT *
FROM orders
WHERE purch_amt < (SELECT MAX(purch_amt) FROM orders WHERE customer_id IN (SELECT customer_id FROM customer WHERE city = 'London'))

-- 24. From the customer table, find those customers whose grade are higher than customers living in New York City. Return customer_id, cust_name, city, grade and salesman_id.
SELECT *
FROM customer
WHERE grade > ALL(SELECT grade FROM customer WHERE city = ‘New York’)

-- 25. From the customer, salesman, and orders tables, calculate the total order amount generated by a salesman. The salesman should belong to the cities where any of the customer living. Return salesman name, city and total order amount.
SELECT s.name, s.city, SUM(o.purch_amt) AS total_order
FROM salesman AS s
JOIN orders AS o
ON s.salesman_id = o.salesman_id
WHERE s.city IN (SELECT city FROM customer)
GROUP BY s.name, s.city

-- 26. From the customer table, find those customers whose grade doesn’t same of those customers live in London City. Return customer_id, cust_name, city, grade and salesman_id.
SELECT *
FROM customer
WHERE grade <> ALL(SELECT grade FROM customer WHERE city = ‘London’ AND grade IS NOT NULL)

-- 27. From the customer table, find those customers whose grade are not same of those customers living in Paris. Return customer_id, cust_name, city, grade and salesman_id.
SELECT *
FROM customer
WHERE grade NOT IN (SELECT grade FROM customer WHERE city = ‘Paris’)

-- 28. From the company master and item master tables, find the average price of each manufacturer’s product along with their name. Return Average Price and Company.
SELECT (SELECT com_name FROM company_mast WHERE com_id = pro_com) AS company, AVG(pro_price) AS average
FROM item_mast
GROUP BY pro_com
ORDER BY company

-- 29. From the company master and item master tables, calculate the average price of the products and find price which are more than or equal to 350. Return Average Price and Company.
SELECT (SELECT com_name FROM company_mast WHERE com_id = pro_com) AS company, AVG(pro_price) AS average
FROM item_mast
GROUP BY pro_com
HAVING AVG(pro_price) >= 350
ORDER BY company

-- 30. From the company master and item master tables, find the most expensive product of each company. Return Product Name, Price and Company.
SELECT i.pro_name AS product, i.pro_price AS price, c.com_name AS company
FROM item_mast AS i
JOIN company_mast AS c
ON i.pro_com = c.com_id
AND i.pro_price = (SELECT MAX(i.pro_price) FROM item_mast AS i WHERE i.pro_com = c.com_id)
ORDER BY company

-- 31. From the employee department and employee details tables, find those employees who work for the department where the department allotment amount is more than Rs. 50000. Return emp_fname and emp_lname.
SELECT emp_fname, emp_lname
FROM emp_details
WHERE emp_dept IN (SELECT dpt_code FROM emp_department WHERE dpt_allotment > 50000)

-- 32. From the employee department table, find the departments where the sanction amount is higher than the average sanction amount of all the departments. Return dpt_code, dpt_name and dpt_allotment.
SELECT *
FROM emp_department
WHERE dpt_allotment > (SELECT AVG(dpt_allotment) FROM emp_department)

-- 33. From the employee department and employee details tables, find the departments where more than two employees work. Return dpt_name.
SELECT dpt_name
FROM emp_department
WHERE dpt_code IN (SELECT emp_dept FROM emp_details GROUP BY emp_dept HAVING COUNT(emp_idno) > 2)

-- 34. From the employee department and employee details tables, find the departments where the sanction amount is second lowest. Return emp_fname and emp_lname.
SELECT emp_fname, emp_lname
FROM emp_details
WHERE emp_dept = (SELECT t2.dpt_code FROM (SELECT t1.dpt_code, MAX(t1.dpt_allotment) AS ord FROM (SELECT dpt_code, dpt_allotment FROM emp_department ORDER BY dpt_allotment ASC LIMIT 2) AS t1 GROUP BY t1.dpt_code ORDER BY ord DESC LIMIT 1) AS t2)