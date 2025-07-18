-- Common Table Expressions (CTE's)
/* CTEs are a way to define a temporary result set that you can only use within the scope of that query. 
   They are subsets of larger data sets and you can treat them just like a regular table*/
/* In other words, CTEs are like little data sets that you define first and then refer to 
   later on in your main query.*/

-- Advantages of CTE
/* CTE's are reusable. 
   a) Can refrence your CTE mutiple times in the same query.
   b) Can use a CTE inside other CTE's./*
/* CTE's offer greater readability.
   Essential for collaboration, code sharing, advancing to more senior level roles. */

SELECT version(); /*to select sql version*/

-- Calculating Descriptive statistics for monthly revenue of product

WITH monthly_revs AS (
SELECT date_trunc('month', s.orderdate) AS ordermonth, p.productname,
sum(s.revenue) AS revenue  
FROM subscription AS s
JOIN products AS p
ON s.productid = p.productid
WHERE s.orderdate BETWEEN '2022-01-01' and '2022-12-31'
GROUP BY date_trunc('month', s.orderdate), p.productname
)

SELECT productname,
min(revenue) AS min_rev,
max(revenue) AS max_rev,
avg(revenue) AS avg_rev,
stddev(revenue) AS std_dev_rev
FROM monthly_revs
GROUP BY productname; 

-- Exploring variable distributions with CTE's
WITH email_link_clicks AS( 
SELECT userid, count(*) AS num_link_clicks
FROM frontendeventlog AS el
WHERE eventid = 5
GROUP BY userid
)

SELECT num_link_clicks, count(*) AS num_users
FROM email_link_clicks
GROUP BY num_link_clicks;

-- CASE Statements
/* 
a) Consists of a collection of conditions
b) Returns values designated by WHEN and THEN
c) Smilar to an IF/THEN statement that can have multiple conditions
d) goes through each condition in order 
e) After the first condition is met, 
the CASE statement stops and returns the value after THEN.
*/

-- Syntax
/* 
CASE 
WHEN employees > 500 THEN 'LARGE'
WHEN employees > 100 THEN 'medium'
ELSE 'small'
END AS CompanySize
*/

-- Creating Binary columns (1's and 0's as ON/OFF)with case
SELECT customerid,
count(productid) AS num_products,
sum(numberofusers) AS total_users,
CASE 
WHEN count(productid) = 1
OR sum(numberofusers) >= 5000
     THEN 1 
     ELSE 0
     END AS upsell_opportunity
FROM subscriptions
GROUP BY customerid;

-- Create aggregated columns with case
SELECT
userid,
sum(CASE WHEN el.eventid = 1 THEN 1 else 0 END) AS VIEWEDhelppage,
sum(CASE WHEN el.eventid = 2 THEN 1 else 0 END) AS VIEWEDhelppage2,
sum(CASE WHEN el.eventid = 3 THEN 1 else 0 END) AS VIEWEDhelppage3,
sum(CASE WHEN el.eventid = 4 THEN 1 else 0 END) AS VIEWEDhelppage4 
FROM frontendeventlog AS el
JOIN frontendeventdefinitions AS def
ON el.eventid = def.eventid
WHERE eventtype = 'Customer Support'
GROUP BY userid;

-- Introduction to UNION
/*Union Combine two tables vertically
Rule1: Each result set or SELECT statements must contain same 
number of columns. (should create another column if not equal)
Rule2: The columns of each dataset in the UNION must be in the same order
Rule3: Each culumn must have the same data type as the corresponding columns
in other datasets.
*/
-- UNION removes all duplicate rows from final output whereas UNION ALL
-- doesn't remove duplicate rows.

-- Combine product tables with UNION
WITH all_subscptions AS(
SELECT subscriptionid, expirationdate
FROM subscriptionsproduct1
WHERE active = 1
UNION ALL
SELECT subscriptionid, expirationdate
FROM subscriptionsproduct2
WHERE active = 1
)
SELECT
date_trunc('year',expirationdate) AS exp_year,
count(*) AS subscriptions
FROM all_subscriptions
GROUP BY date_trunc('year',expirationdate);

-- Unpivoting column into rows
with all_cancelation_reasons as(
SELECT subscriptionid, cancelationreason1 AS cancelationreason
FROM cancelations
UNION
SELECT subscriptionid, cancelationreason2 AS cancelationreason
FROM cancelations
UNION
SELECT subscriptionid, cancelationreason3 AS cancelationreason
FROM cancelations
)

SELECT 
 cast(count(
      CASE WHEN cancelationreason = 'Expensive' 
      THEN subscriptionid end) as float)
 /count(distinct subscriptionid) as percent_expensive
FROM all_cancelation_reasons;
 
-- Introduction to self joins
SELECT 
employees.employeeid,
employees.name AS employee_name,
manager.name AS manager_name,
coalesce(manager.email, employees.email) AS contact_email 
FROM employees
LEFT JOIN employees manager
ON employees.managerid = manager.employeeid 
WHERE employees.department = 'Sales';

-- Comparing two rows within the same table
WITH monthly_revs AS(
select 
    date_trunc('month', orderdate) as order_month, 
    sum(revenue) as monthly_revenue
from 
    subscriptions
group by 
    date_trunc('month', orderdate)
)

SELECT 
current.order_month AS current_month,
previous.order_month AS previous_month,
cuurent.monhly_revenue AS current_revenue,
previous.monthly_revenue AS previous_revenue 
FROM monthly_revs AS current JOIN monthly_revs AS previous
WHERE 
current.monthly_revenue > previous.monthly_revenue
and dateddiff('month', previous.order_month, current_month)=1;

-- WINDOW functions
/*
PARTITION BY: Split up the rows into windows
Order BY: Order the rows within the window(If applicable)*/
/*
Three window functions to rank values
row_number() [1,2,3,4,5,6]
rank() [1,2,2,2,5,6]
dense_rank() [1,2,2,2,3,4] */

-- Calculate running total
SELECT
salesemployeeid,
salesdate,
saleamount,
sum(saleamount) 
 over(partition by salesemployeeid
      ORDER BY saledate) AS running_total,
cast (sum(saleamount) 
 over(partition by salesemployeeid
      ORDER BY saledate) AS flt)
      /
      quota AS percent_quota

FROM sale AS s
JOIN employees AS e
ON s.employeeid = employeeid
ORDER BY salesemployeeid, saledate; 

-- Timestamp differences with LEAD()
SELECT
*,
LEAD(movementdate, 1)
     over(PARTITION BY subscriptionid
          order by movementdate)
             AS NEXTSTATUSmovementdate,
LEAD(movementdate,1)
     over(partition by subscriptionid
          order by movementdate)
     - movementdate AS Timeinstatus     
FROM paymentstatuslog
WHERE subscptionid = '38844'
ORDER BY movementdate;    