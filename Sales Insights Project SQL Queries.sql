
/* Queries used for Tableau Project */


/* To get all customer records */
SELECT * FROM customers;



/* To get total number of customers */
SELECT count(*) FROM customers;



/* To get transactions for only Chennai market (market code for chennai is Mark001) */
SELECT * FROM transactions 
WHERE market_code='Mark001';



/* To get just the distrinct product codes that were sold in chennai */
SELECT distinct product_code FROM transactions 
WHERE market_code='Mark001';



/* To get transactions where currency is US dollars */
SELECT * from transactions 
WHERE currency="USD";



/* To get transactions in 2020 join by date table */
SELECT * 
FROM transactions 
INNER JOIN date 
ON transactions.order_date=date.date 
WHERE date.year=2020;



/* To get total revenue in year 2020 */
SELECT SUM(transactions.sales_amount) 
FROM transactions
INNER JOIN date 
ON transactions.order_date=date.date 
WHERE date.year=2020 AND (transactions.currency="%INR%" OR transactions.currency="%USD%");



/* To get total revenue in year 2020, January Month  */
SELECT SUM(transactions.sales_amount) 
FROM transactions 
INNER JOIN date 
ON transactions.order_date=date.date 
WHERE (date.year=2020) AND (date.month_name="January");          




/* To get total revenue in year 2020 in Chennai */
SELECT SUM(transactions.sales_amount) 
FROM transactions 
INNER JOIN date 
ON transactions.order_date=date.date 
WHERE date.year=2020 and transactions.market_code="Mark001";


