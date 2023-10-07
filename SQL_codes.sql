-- We explored the data using SQL, where we will find more insights and trends.

-- You can find the code below.

SELECT * FROM [Sport_Store].[dbo].[orders]

-- 1. KPI's for Total Revenue, Profit, Num of Orders, Profit Margin

SELECT 
  SUM(revenue) as total_revenue,
  SUM(profit) as total_profit,
  COUNT(*) as total_orders,
  SUM(profit) / SUM(revenue) * 100.0 as profit_margin

FROM 
  [Sport_Store].[dbo].[orders]

-- 2. Total Revenue, Profit, Num of Orders, Profit Margin for each sport

SELECT 
  sport,
  ROUND(SUM(revenue),2) as total_revenue,
  ROUND(SUM(profit),2) as total_profit,
  COUNT(*) as total_orders,
  SUM(profit) / SUM(revenue) * 100.0 as profit_margin
FROM 
  [Sport_Store].[dbo].[orders]
GROUP BY 
  sport
ORDER BY 
  profit_margin DESC

-- 3. Number of customer ratings and the average rating

SELECT 
  (SELECT COUNT(*) FROM [Sport_Store].[dbo].[orders] WHERE rating IS NOT NULL) as number_of_reviews,
  ROUND(AVG(rating),2) as average_rating
FROM
  [Sport_Store].[dbo].[orders]

-- 4. Number of people for each rating and its revenue, profit, profit margin 

SELECT 
  rating,
  SUM(revenue) as total_revenue,
  SUM(profit) as total_profit,
  SUM(profit) / SUM(revenue) * 100.0 as profit_margin
FROM 
  [Sport_Store].[dbo].[orders]
WHERE 
  rating IS NOT NULL
GROUP BY 
  rating
ORDER BY
  rating DESC

-- 5. State revenue, profit, and profit margin

SELECT 
  c.state,
  ROW_NUMBER() over (ORDER BY SUM(o.revenue) DESC) as revenue_rank,
  SUM(o.revenue) as total_revenue,
  ROW_NUMBER() over (ORDER BY SUM(o.profit) DESC) as profit_rank,
  SUM(o.profit) as total_profit,
  ROW_NUMBER() over (ORDER BY SUM(o.profit) / SUM(o.revenue) * 100.0 DESC) as margin_rank,
  SUM(o.profit) / SUM(o.revenue) * 100.0 as profit_margin
FROM
  [Sport_Store].[dbo].[orders] as o
JOIN
  [Sport_Store].[dbo].[customers] as c
ON
  o.customer_id = c.customer_id
GROUP BY 
  c.State
ORDER BY
  margin_rank

-- 6. monthly profits

WITH monthly_profit AS (
  SELECT
    MONTH(date) AS month,
    SUM(profit) AS total_profit
  FROM 
    [Sport_Store].[dbo].[orders]
  GROUP BY 
    MONTH(date)
)
SELECT
  month,
  total_profit,
  LAG(total_profit) OVER (ORDER BY month) AS previous_month_profit,
  ROUND(total_profit - LAG(total_profit) OVER (ORDER BY month),2) AS profit_difference
FROM 
  monthly_profit
ORDER BY
  month;




