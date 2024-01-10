select * from [dbo].[MANAGER]
select * from [dbo].[ORDERS]
select * from [dbo].[Profiles]
select * from [dbo].[Returns]
--1. How many orders have an order priority of 'Low'?
select count(distinct order_id) 
from [dbo].[ORDERS]

--2. Top 5 provinces with the highest number of orders. 
select top 5 [province], count(distinct order_id) 
from [dbo].[ORDERS]
group by province
order by province desc

--3. The top 3 managers with the highest number of orders.
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

-----4. The list of Product Categories with an average profit higher than the average profit of all orders
select * from
(
select [Product_category], sum(profit) tongloinhuan
from [dbo].[ORDERS]
group by [Product_category] 
) T
where [tongloinhuan] > (select  avg(profit)
						from [dbo].[ORDERS]
				)

--5. The list of the top 5 products (product_name) with the highest total_value per region 
select * from 
(select (product_name),(region), sum([value]) total_value,
ROW_NUMBER () over ( partition by [region] order by sum([value]) desc) as xephang
from [dbo].[ORDERS]
group by [product_name],[region]) T
where  xephang < 6

------6.The list of products (product_name) with the lowest ranked total_value per province.

select * from 
(select (product_name),(province), sum([value]) total_value,
dense_rank () over ( partition by province order by sum([value]) ) as xephang
from [dbo].[ORDERS]
group by [product_name],province) T
where  xephang =1

---7. table with columns year, month, total_revenue, total_revenue_returned,  acc_revenue, group_revenue
create table [dbo]. [cuoikhoa]
			([year] nvarchar(4)
			, [month] nvarchar(3)
			, total_revenue float
			, total_revenue_returned float
			, acc_revenue float
			, group_revenue float
				)
create table [dbo]. [cuoikhoa1]

select * into [cuoikhoa1] from [dbo].[ORDERS]

select 
(select A.*, B.[status] from
(select * from [dbo].[ORDERS] ) A
full join
(select [order_id],[status] from [dbo].[Returns] ) B
on A.[order_id] = B.[order_id]) 

into [cuoikhoa3] from [dbo].[ORDERS]

INSERT INTO [cuoikhoa2]

select A.*, B.[status] from
(select * from [dbo].[ORDERS] ) A
full join
(select [order_id],[status] from [dbo].[Returns] ) B
on A.[order_id] = B.[order_id]

INSERT INTO [dbo]. [cuoikhoa] ([year], [month], [total_revenue], [total_revenue_returned],  [acc_revenue], [group_revenue])
SELECT year(order_date)
	,month(order_date)
	,order_quantity* unit_price*(1-discount)
	,total _revenue - total _revenue_returned
	,LUONG FROM [dbo].[ORDERS]
WHERE ID > 6;