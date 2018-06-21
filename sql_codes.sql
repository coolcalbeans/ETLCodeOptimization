-- 1. How many unique customers does the Bebop have?
-- Assuming only looking at Customers with valid Customer ID. Ignoring Unknown Users

Select 
	count(distinct t."Customer_ID") 
from transactions as t
where 
	t."Customer_ID" != 'Unknown';

-- 2. Which customer is the second biggest customer by revenue, excluding cancellations?
-- Assuming the Quantity <=0 are cancellations by the customers

Select
	tmp."Rank",
	tmp."Customer_ID",
	tmp."Revenue"
from
(
	Select
		row_number() over (order by sum(inv."Quantity" * inv."UnitPrice")  desc) as "Rank",
		t."Customer_ID",
		sum(inv."Quantity" * inv."UnitPrice") as "Revenue"
	from transactions	as t
	left join invoices as inv on inv."InvoiceNo" = t."InvoiceNo"
	where
		inv."Quantity" >0
		and t."Customer_ID" != 'Unknown'
	Group by
		t."Customer_ID"
) as tmp
where tmp."Rank" = 2

-- 3. How many customers have visited the Bebop on multiple planets?
-- Assuming only looking at Customers with valid Customer ID. Ignoring Unknown Users

select
	count(*) as Total_Customers_with_Multiple_PlanetVisits
from
(
	Select
		t."Customer_ID",
		count(distinct t."Planet")
	from transactions as t
	where
		t."Customer_ID" != 'Unknown'
	Group by
		t."Customer_ID"
	Having
		count(distinct t."Planet") > 1
) as tmp

-- 4. Which product has had the most price changes?
-- Looking at products that have only valid Item No# i.e. only numeric ItemNumbers

Select
	inv."ItemNo",
	itm."Description",
	count (distinct inv."UnitPrice")
from invoices as inv
left join items as itm on itm."ItemNo" = inv."ItemNo"
where
	inv."ItemNo" ~ '^[0-9]*$'
Group by
	inv."ItemNo", itm."Description"
Order by
	count (distinct inv."UnitPrice") desc

-- 5. Which item attracts the most new customers?
-- Only looking at Customers with valid Customer ID. Ignoring Unknown Users
-- Looking at products that have only valid Item No# i.e. only numeric ItemNumbers

Select
	inv."ItemNo",
	itm."Description",
	count (distinct t."Customer_ID")
from invoices as inv
left join transactions as t on t."InvoiceNo" = inv."InvoiceNo"
								and t."Customer_ID" != 'Unknown'
left join items as itm on itm."ItemNo" = inv."ItemNo"
where
	inv."ItemNo" ~ '^[0-9]*$'
Group by
	inv."ItemNo", itm."Description"
Order by
	count (distinct t."Customer_ID") desc;

-- 6. Which customer has the shortest average length of time between purchases?
-- Only looking at Customers with valid Customer ID. Ignoring Unknown Users
-- Assuming minimum time between Purchases for a given customer is greater than a day

Select
	tmp."Customer_ID",
	avg(PurchaseTimeDiff) as AvgPurchaseTime
from
(
	Select
		t."Customer_ID",
		coalesce((LEAD(t."TransactionDate") OVER(partition by t."Customer_ID" ORDER BY t."TransactionDate")),t."TransactionDate") - t."TransactionDate" as PurchaseTimeDiff
	from transactions as t
	where
		t."Customer_ID" != 'Unknown' 
) as tmp
where
	tmp.PurchaseTimeDiff > '1 days'
Group by
	tmp."Customer_ID"
Order by
	avg(PurchaseTimeDiff) Asc;
	
-- 7. For each invoice, calculate the total revenue for each item and return the combined revenue of the top 3 items by revenue. You can ignore invoices that have fewer than 3 items.
-- Assuming the Quantity <=0 are cancellations by the customers

Select
	tmp."InvoiceNo",
	sum(tmp."Revenue") as "Top3ItemRevenue"
from
(
	Select 
		inv."InvoiceNo",
		inv."ItemNo",
		sum(inv."Quantity" * inv."UnitPrice") as "Revenue",
		row_number() over (partition by inv."InvoiceNo" order by sum(inv."Quantity" * inv."UnitPrice")  desc) as "Rank"
	from invoices as inv
	where
			inv."Quantity" >0
	Group by
		inv."InvoiceNo",
		inv."ItemNo"
	Order by
		inv."InvoiceNo",
		sum(inv."Quantity" * inv."UnitPrice") desc
) as tmp
left join 
		(
			Select 
				inv."InvoiceNo",
				count(inv."ItemNo") as "ItemCount"
			from invoices as inv
			where
					inv."Quantity" >0
			Group by
				inv."InvoiceNo"	
			Order by
				inv."InvoiceNo"
		) as itemcount on itemcount."InvoiceNo" = tmp."InvoiceNo"
where
	tmp."Rank" <=3	
	and itemcount."ItemCount" >=3
Group by
	tmp."InvoiceNo"
Order by
	sum(tmp."Revenue") desc;
	