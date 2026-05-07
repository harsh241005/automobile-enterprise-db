-- 1. Total revenue by Company (ROLLUP)
SELECT 
    NVL(c.company_name, 'GRAND TOTAL') AS company_name,
    COUNT(sv.sold_id) AS units_sold,
    SUM(sv.sale_price) AS total_revenue
FROM Sold_Vehicle sv
JOIN Vehicle v ON sv.VIN = v.VIN
JOIN Model m ON v.model_id = m.model_id
JOIN Brand b ON m.brand_id = b.brand_id
JOIN Company c ON b.company_id = c.company_id
GROUP BY ROLLUP(c.company_name)
ORDER BY total_revenue DESC;

-- 2. Revenue by Body Style (ROLLUP)
SELECT 
    NVL(bs.style_name, 'GRAND TOTAL') AS body_style,
    COUNT(sv.sold_id) AS units_sold,
    SUM(sv.sale_price) AS total_revenue
FROM Sold_Vehicle sv
JOIN Vehicle v ON sv.VIN = v.VIN
JOIN Model m ON v.model_id = m.model_id
JOIN Bodystyle bs ON m.body_style_id = bs.body_style_id
GROUP BY ROLLUP(bs.style_name)
ORDER BY total_revenue DESC;


-- 3. Cumulative revenue over time
SELECT 
    sv.sale_date,
    m.model_name,
    sv.sale_price,
    SUM(sv.sale_price) OVER (ORDER BY sv.sale_date) AS cumulative_revenue
FROM Sold_Vehicle sv
JOIN Vehicle v ON sv.VIN = v.VIN
JOIN Model m ON v.model_id = m.model_id
ORDER BY sv.sale_date;


-- 4. Rank customers by annual income
SELECT 
    cu.customer_name,
    cu.gender,
    cu.annual_income,
    RANK() OVER (ORDER BY cu.annual_income DESC) AS income_rank
FROM Customer cu
ORDER BY cu.annual_income DESC;

-- 5. Customer count and avg income by Gender (ROLLUP)
SELECT 
    NVL(cu.gender, 'ALL GENDERS') AS gender,
    COUNT(cu.customer_id) AS total_customers,
    ROUND(AVG(cu.annual_income), 2) AS avg_income,
    MIN(cu.annual_income) AS min_income,
    MAX(cu.annual_income) AS max_income
FROM Customer cu
GROUP BY ROLLUP(cu.gender)
ORDER BY avg_income DESC;


-- 6. Vehicle inventory: Sold vs Unsold per Model
SELECT 
    NVL(m.model_name, 'TOTAL') AS model_name,
    COUNT(v.VIN) AS total_produced,
    COUNT(sv.VIN) AS sold,
    COUNT(v.VIN) - COUNT(sv.VIN) AS unsold
FROM Vehicle v
JOIN Model m ON v.model_id = m.model_id
LEFT JOIN Sold_Vehicle sv ON v.VIN = sv.VIN
GROUP BY ROLLUP(m.model_name)
ORDER BY m.model_name;
 
 
-- 7. Colour popularity across all vehicles
SELECT 
    cl.colour_name,
    COUNT(v.VIN) AS vehicles_with_colour,
    DENSE_RANK() OVER (ORDER BY COUNT(v.VIN) DESC) AS colour_rank
FROM Vehicle v
JOIN Colours cl ON v.colour_id = cl.colour_id
GROUP BY cl.colour_name
ORDER BY colour_rank;


-- 8. Parts supplied per Supplier (ROLLUP)
SELECT 
    NVL(s.supplier_name, 'ALL SUPPLIERS') AS supplier_name,
    COUNT(sp.serial_id) AS parts_supplied
FROM Serializing_Part sp
JOIN Supplier s ON sp.supplier_id = s.supplier_id
GROUP BY ROLLUP(s.supplier_name)
ORDER BY parts_supplied DESC;
 
 
-- 9. Most used parts across all models (DENSE_RANK)
SELECT 
    p.part_name,
    p.part_type,
    COUNT(mp.model_id) AS used_in_models,
    DENSE_RANK() OVER (ORDER BY COUNT(mp.model_id) DESC) AS part_rank
FROM Model_Parts mp
JOIN Parts p ON mp.part_id = p.part_id
GROUP BY p.part_name, p.part_type
ORDER BY part_rank;


-- 10. Customers who bought SUVs
SELECT cu.customer_name, m.model_name, bs.style_name, sv.sale_price
FROM Sold_Vehicle sv
JOIN Customer cu ON sv.customer_id = cu.customer_id
JOIN Vehicle v ON sv.VIN = v.VIN
JOIN Model m ON v.model_id = m.model_id
JOIN Bodystyle bs ON m.body_style_id = bs.body_style_id
WHERE bs.style_name = 'SUV';

