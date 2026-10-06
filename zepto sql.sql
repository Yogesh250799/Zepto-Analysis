create database zepto;
use zepto;
select * from zepto_data;
select count(*) from zepto_data;

select * from zepto_data
where category is null
or name is null
or mrp is null
or discountPercent is null
or availableQuantity is null
or discountedsellingprice is null
or weightingms is null
or outofstock is null
or quantity is null;

select distinct category
from zepto_data
order by category;

-- products in stock vs out of stock
select outofstock, count(*)
from zepto_data
group by outofstock;

-- products name present multiple times
select name, count(*) as Number_of_Products
from zepto_data
group by name
having Number_of_Products > 1
order by Number_of_Products desc;

-- data cleaning
-- products with price = 0
select * from zepto_data
where mrp = 0 or discountedsellingprice = 0;

-- Disable Safe Updates Temporarily
SET SQL_SAFE_UPDATES = 0;

delete from zepto_data
where mrp = 0;

-- Enable Safe Updates Temporarily
SET SQL_SAFE_UPDATES = 1;

-- converting paise to ruppees
Update zepto_data
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp,discountedsellingprice from zepto_data;

-- Q1. Find the top 10 best-value products based on the discount percentage.
select name,mrp,discountpercent from zepto_data
order by discountpercent desc
limit 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto_data
WHERE outofstock = 'TRUE' AND mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
select category,sum(discountedsellingprice * availablequantity) as Total_revenue
from zepto_data
group by category
order by Total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name ,mrp,discountpercent
from zepto_data
where mrp > 500 and discountpercent < 10
order by mrp desc, discountpercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,round(avg(discountpercent),2) as hadp
from zepto_data
group by category
order by hadp desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weightingms,discountedsellingprice,round(discountedsellingprice/weightingms,2) as price_per_gram
from zepto_data
where weightingms >= 100
order by price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weightingms,
case when weightingms < 500 then 'Low'
	when weightingms < 1000 then 'Medium'
    else 'Bulk'
    End as weight_category
from zepto_data;

-- Q8.What is the Total Inventory Weight Per Category 
select category,
sum(weightingms * availablequantity) as Total_weight
from zepto_data
group by category
order by Total_weight;