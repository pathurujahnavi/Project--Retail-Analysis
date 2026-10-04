-- =====================================================================
-- Project : Retail Business Performance & Profitability Analysis
-- Dataset : Sample Superstore (9,994 rows, 2014-2017)
-- Database: SQLite  |  Table: retail_sales
-- =====================================================================

-- 1. Preview data
SELECT * FROM retail_sales LIMIT 10;

-- 2. Total records
SELECT COUNT(*) AS total_records FROM retail_sales;

-- 3. Missing / null value check
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN [Order ID]    IS NULL OR [Order ID]    = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN [Customer ID] IS NULL OR [Customer ID] = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN [Category]    IS NULL OR [Category]    = '' THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN [Sales]  IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN [Profit] IS NULL THEN 1 ELSE 0 END) AS missing_profit
FROM retail_sales;

-- 4. Orders with multiple line items
SELECT [Order ID], COUNT(*) AS order_count
FROM retail_sales
GROUP BY [Order ID]
HAVING COUNT(*) > 1
LIMIT 10;

-- 5. Records per category
SELECT [Category], COUNT(*) AS records
FROM retail_sales
GROUP BY [Category]
ORDER BY records DESC;

-- 6. Overall KPIs
SELECT
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    SUM([Quantity])         AS total_quantity,
    COUNT(DISTINCT [Order ID])    AS total_orders,
    COUNT(DISTINCT [Customer ID]) AS total_customers
FROM retail_sales;

-- 7. Overall profit margin
SELECT
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    ROUND((SUM([Profit]) * 100.0) / SUM([Sales]), 2) AS profit_margin_percentage
FROM retail_sales;

-- 8. Profit margin by category
SELECT
    [Category],
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    SUM([Quantity])         AS total_quantity,
    ROUND((SUM([Profit]) * 100.0) / SUM([Sales]), 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY [Category]
ORDER BY total_profit DESC;

-- 9. Profit margin by sub-category
SELECT
    [Category], [Sub-Category],
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    SUM([Quantity])         AS total_quantity,
    ROUND((SUM([Profit]) * 100.0) / SUM([Sales]), 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY [Category], [Sub-Category]
ORDER BY total_profit DESC;

-- 10. Regional performance
SELECT
    [Region],
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    SUM([Quantity])         AS total_quantity,
    COUNT(DISTINCT [Order ID]) AS total_orders,
    ROUND((SUM([Profit]) * 100.0) / SUM([Sales]), 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY [Region]
ORDER BY total_profit DESC;

-- 11. Average discount vs profitability by category
SELECT
    [Category],
    ROUND(AVG([Discount]) * 100, 2) AS average_discount_percentage,
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    ROUND((SUM([Profit]) * 100.0) / SUM([Sales]), 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY [Category]
ORDER BY average_discount_percentage DESC;

-- 12. Profitability by discount level
SELECT
    ROUND([Discount] * 100, 0) AS discount_percentage,
    COUNT(*) AS transactions,
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    ROUND((SUM([Profit]) * 100.0) / SUM([Sales]), 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY [Discount]
ORDER BY [Discount];

-- 13. Top 20 loss-making products
SELECT
    [Category], [Sub-Category], [Product Name],
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    SUM([Quantity])         AS total_quantity,
    ROUND(AVG([Discount]) * 100, 2) AS average_discount_percentage
FROM retail_sales
GROUP BY [Category], [Sub-Category], [Product Name]
HAVING SUM([Profit]) < 0
ORDER BY total_profit ASC
LIMIT 20;

-- 14. Slow-moving products (lowest quantity sold)
SELECT
    [Category], [Sub-Category], [Product Name],
    SUM([Quantity]) AS total_quantity,
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit,
    ROUND(AVG([Discount]) * 100, 2) AS average_discount_percentage
FROM retail_sales
GROUP BY [Category], [Sub-Category], [Product Name]
ORDER BY total_quantity ASC
LIMIT 20;

-- 15. Seasonal / monthly performance
SELECT
    strftime('%Y-%m', [Order Date]) AS order_month,
    ROUND(SUM([Sales]), 2)  AS total_sales,
    ROUND(SUM([Profit]), 2) AS total_profit
FROM retail_sales
GROUP BY order_month
ORDER BY order_month;
