/*
Created By: Jarrett Bruno
Date: 03/21/2023
Description: WSDA Music Final Project
*/

--  1. How many transactions took place between the years 2011 and 2012?

SELECT 
	COUNT(*)
FROM 
	Invoice
WHERE 
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
	

	
-- 2. How much money did WSDA Music make during the same period?

SELECT 
	SUM(total)
FROM
	Invoice
WHERE	
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
	
	
-- 3. Get a list of customers whoe made a purchase between 2011 and 2012.

SELECT 
	c.FirstName,
	c.LastName,
	i.total
FROM
	Invoice AS i 
INNER JOIN
	Customer AS c
ON 
	c.CustomerId = i.CustomerId
WHERE 
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
ORDER BY
	i.total DESC
	
	
-- 4. Get a list of customers, sales reps, and total transaction amounts for each customer between 2011 and 2012.

SELECT
	c.FirstName AS 'Customer First Name',
	c.LastName AS 'Customer Last Name',
	e.FirstName AS 'Employee First Name',
	e.LastName AS 'Employee Last Name',
	i.total
FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON
	i.CustomerId = c.CustomerId
INNER JOIN
	Employee AS e
ON 
	c.SupportRepId = e.EmployeeId
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
ORDER BY
	i.total DESC
	
-- 5. How many transactions are above the average transaction amount during the same time? 

-- Find the average transaction amount between 2011 and 2012
SELECT 
	round(AVG(total),2) AS 'Average Transaction Amount'
FROM
	Invoice
WHERE 
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
	
-- Get the number of transactions above the average transaction amount
SELECT	
	COUNT(total) AS '# of transactions above avg'
FROM 
	Invoice
WHERE 
	total >
				(SELECT 
					round(AVG(total),2) AS 'Average Transaction Amount'
				FROM
					Invoice
				WHERE 
					InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31')
AND 
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
	
-- 6. What was the average transaction amount for each year that WSDA Music has been in business?
SELECT
	round(AVG(total),2) AS 'Avg Transaction Amount',
	strftime('%Y', InvoiceDate) AS 'Year'
FROM 
	Invoice
GROUP BY
	strftime('%Y', InvoiceDate	)
	
-- 7. Get a list of employees who exceeded the average transaction amount from sales they generated during 2011 and 2012.
SELECT
	e.FirstName,
	e.LastName,
	sum(i.total) AS 'Total Sales'
	FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON 
	i.CustomerId = c.CustomerId
INNER JOIN
	Employee AS e
ON
	e.EmployeeId = c.SupportRepId
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
AND 
	i.total > 11.66
GROUP BY
	e.FirstName,
	e.LastName
ORDER BY
	e.LastName
	
-- 8. Create a Commission Payout column that displays each employee's commission based on15% of the sales transaction amount.
SELECT
	e.FirstName,
	e.LastName,
	SUM(i.total) AS 'Total Sales',
	round(sum(i.total)*.15,2) AS 'Commission Payout'
FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON
	i.CustomerId = c.CustomerId
INNER JOIN
	Employee AS e
ON 
	e.EmployeeId = c.SupportRepId
WHERE 
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
GROUP BY
	e.FirstName,
	e.LastName
ORDER BY
	e.LastName
 
 -- 9. Which employee made the highest commission?
 -- Jane Peacock : $199.77
 
 -- 10. List the customers that the employee identified in the last question
 SELECT
	c.FirstName AS 'Customer First Name',
	c.LastName AS 'Customer Last Name',
	e.FirstName AS 'Employee First Name',
	e.LastName	AS 'Employee Last Name',
	sum(i.total) AS [Total Sales],
	round(sum(i.total)*.15,2) AS 'Commission Payout'
 FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON 
	c.CustomerId = i.CustomerId
INNER JOIN
	employee AS e
ON 
	e.EmployeeId = c.SupportRepId
 WHERE 
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
AND
	c.SupportRepId = '3'
GROUP BY
	c.FirstName,
	c.LastName,
	e.FirstName, 
	e.LastName
ORDER BY 
	[Total Sales] DESC
	
-- 11. Which customers made the highest purchases?
-- John Doeein: $1000.86

--12. Look at this customer record - do you see anything suspicious?
SELECT 
	*
FROM 
	Customer AS c
WHERE
	c.LastName = 'Doeein'
	
--Yes, there are no other records pertaining to John Doeein. Our Primary person of interest is Jane Peacock. 