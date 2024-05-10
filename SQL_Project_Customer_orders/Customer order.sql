select * from [dbo].[MANAGER]
select * from [dbo].[ORDERS]
select * from [dbo].[Profiles]
select * from [dbo].[Returns]

--The number of orders according to order_priority.
select order_priority, count(distinct order_id) as num_of_orders
from [dbo].[ORDERS]
group by order_priority

----ANALYZE ACCORDING TO GEOGRAGPHIC LOCATION----

--Top 5 provinces with the highest number of orders. 
select top 5 [province], count(distinct order_id) as num_of_order
from [dbo].[ORDERS]
group by province
order by num_of_order desc

--The list of the top 5 products (product_name) with the highest total_value per region 
select * from 
(select (product_name),(region), sum([value]) total_value,
ROW_NUMBER () over ( partition by [region] order by sum([value]) desc) as product_rank
from [dbo].[ORDERS]
group by [product_name],[region]) T
where  product_rank < 6

------The list of products (product_name) with the lowest ranked total_value per province.

select * from 
(select (product_name),(province), sum([value]) total_value,
dense_rank () over ( partition by province order by sum([value]) ) as xephang
from [dbo].[ORDERS]
group by [product_name],province) T
where  xephang =1


---- CUSTOMER ANALYSIS---------

---- Total value  for each customer segment.
select customer_segment, sum(value) as total_revenue,  ((sum(value) )/(select sum(value) from [dbo].[ORDERS]))*100 as 'percentage of the total (%)'
from [dbo].[ORDERS]
group by customer_segment
order by total_revenue desc

------ Top 10 customer with highest value 
select top 10 customer_name, sum(value) as total_revenue 
from [dbo].[ORDERS]
group by customer_name
order by total_revenue desc 



---- PRODUCT ANALYSIS---

----The list of Product Categories with an average profit higher than the average profit of all orders
select * from
(
select [Product_category], sum(profit) sum_profit 
from [dbo].[ORDERS]
group by [Product_category] 
) T
where sum_profit > (select  avg(profit)
						from [dbo].[ORDERS]
				)

----- The order quantity each product by time .----
select product_name, month(order_date) as month, year(order_date) as year , sum(order_quantity) as sum_quantity 
from [dbo].[ORDERS]
group by month(order_date), year(order_date), product_name
order by product_name, year 

-----The top 3 managers with the highest number of orders.
select top 3 b.manager_name, count(distinct order_id) donhang from
(
(select [province], [order_id] from [dbo].[ORDERS] ) A
full join
(select T1.manager_name, T2.province from
(select [manager_name] from [dbo].[MANAGER]) T1
inner join 
(select [manager], [province] from  [dbo].[Profiles] ) T2
On T1.[manager_name] = T2.[manager]) B
on a.province = b.province)
group by b.manager_name

order by donhang desc


---Table with columns year, month, total_revenue, total_revenue_returned,  acc_revenue, group_revenue
create table [dbo]. [final]
			([year] nvarchar(4)
			, [month] nvarchar(3)
			, total_revenue float
			, total_revenue_returned float
			, acc_revenue float
			, group_revenue float
				)
create table [dbo]. [final1]

select * into [final] from [dbo].[ORDERS]

select 
(select A.*, B.[status] from
(select * from [dbo].[ORDERS] ) A
full join
(select [order_id],[status] from [dbo].[Returns] ) B
on A.[order_id] = B.[order_id]) 

into [final3] from [dbo].[ORDERS]

INSERT INTO [final2]

select A.*, B.[status] from
(select * from [dbo].[ORDERS] ) A
full join
(select [order_id],[status] from [dbo].[Returns] ) B
on A.[order_id] = B.[order_id]

INSERT INTO [dbo]. [final] ([year], [month], [total_revenue], [total_revenue_returned],  [acc_revenue], [group_revenue])
SELECT year(order_date)
	,month(order_date)
	,order_quantity* unit_price*(1-discount)
	,total _revenue - total _revenue_returned
	,LUONG FROM [dbo].[ORDERS]
WHERE ID > 6;
