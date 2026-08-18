CREATE DATABASE happiest_minds_dashboard;
USE happiest_minds_dashboard;
RENAME TABLE `budget vs actual` TO budget_actual;
SELECT * FROM budget_actual LIMIT 5;
SELECT * FROM annual_p_l LIMIT 5;
SELECT * FROM balance_sheet LIMIT 5;
SELECT * FROM cash_flow LIMIT 5;
SELECT * FROM other_metrics LIMIT 5;
SELECT * FROM ratios LIMIT 5;
-- 1st... Department wise Varaiance 
SELECT 
    Department,
    SUM(`Budget Amount`) AS Total_Budget,
    SUM(`Actual Amount`) AS Total_Actual,
    ROUND((SUM(`Actual Amount`) - SUM(`Budget Amount`)) / SUM(`Budget Amount`) * 100, 2) AS Variance_Pct
FROM budget_actual
GROUP BY Department
ORDER BY Variance_Pct DESC;

-- 2nd Region wise
SELECT 
    Region,
    SUM(`Budget Amount`) AS Total_Budget,
    SUM(`Actual Amount`) AS Total_Actual,
    ROUND((SUM(`Actual Amount`) - SUM(`Budget Amount`)) / SUM(`Budget Amount`) * 100, 2) AS Variance_Pct
FROM budget_actual
GROUP BY Region
ORDER BY Variance_Pct DESC;

-- 3rdDept and Reguon
SELECT 
    Department,
    Region,
    SUM(`Budget Amount`) AS Total_Budget,
    SUM(`Actual Amount`) AS Total_Actual,
    ROUND((SUM(`Actual Amount`) - SUM(`Budget Amount`)) / SUM(`Budget Amount`) * 100, 2) AS Variance_Pct
FROM budget_actual
GROUP BY Department, Region
ORDER BY Variance_Pct DESC;

-- 4th peer comparison query — joining the 5 financial tables on Name
SELECT 
    a.Name,
    a.Sales,
    a.`Profit after tax`,
    a.OPM,
    r.`Debt to equity`,
    r.`Return on equity`,
    r.`Quick ratio`,
    o.`Current ratio`,
    b.`Cash Equivalents`
FROM annual_p_l a
JOIN ratios r ON a.Name = r.Name
JOIN other_metrics o ON a.Name = o.Name
JOIN balance_sheet b ON a.Name = b.Name
ORDER BY a.Sales DESC;

-- year-over-year trend
SELECT 
    YEAR(Date) AS Year,
    SUM(`Budget Amount`) AS Total_Budget,
    SUM(`Actual Amount`) AS Total_Actual,
    ROUND((SUM(`Actual Amount`) - SUM(`Budget Amount`)) / SUM(`Budget Amount`) * 100, 2) AS Variance_Pct
FROM budget_actual
GROUP BY YEAR(Date)
ORDER BY Year;
DESCRIBE budget_actual;
SELECT Date FROM budget_actual LIMIT 5;

SELECT 
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS Year,
    SUM(`Budget Amount`) AS Total_Budget,
    SUM(`Actual Amount`) AS Total_Actual,
    ROUND((SUM(`Actual Amount`) - SUM(`Budget Amount`)) / SUM(`Budget Amount`) * 100, 2) AS Variance_Pct
FROM budget_actual
GROUP BY YEAR(STR_TO_DATE(Date, '%d-%m-%Y'))
ORDER BY Year;

ALTER TABLE budget_actual ADD COLUMN Date_fixed DATE;
UPDATE budget_actual SET Date_fixed = STR_TO_DATE(Date, '%d-%m-%Y');
SET SQL_SAFE_UPDATES = 0;
SELECT Date, Date_fixed FROM budget_actual LIMIT 5;