select * from market_analysis$

-------------evenue-generating months ratio per room.------------

SELECT 
    A.*,
    B.number_of_months_with_revenue,
    CASE 
        WHEN B.number_of_months_with_revenue is null  THEN 0
        ELSE ROUND((B.number_of_months_with_revenue*1.0/A.number_of_months)*100, 2)
    END AS "Occupancy Rate by Time"
FROM 
    (SELECT 
         unified_id, 
         COUNT(unified_id) AS number_of_months
     FROM 
         market_analysis$
     GROUP BY 
         unified_id) A 
LEFT JOIN 
    (SELECT 
         unified_id, 
         COUNT(unified_id) AS number_of_months_with_revenue
     FROM 
         market_analysis$
     WHERE 
         revenue != 0 
     GROUP BY 
         unified_id) B 
ON 
    A.unified_id = B.unified_id;

-----------Top revenue-generating units-----
with cte as 
(select 
		unified_id, 
		sum(revenue) as total_revenue , 
		DENSE_RANK() over(order by sum(revenue) desc) as Ranke
from 
		market_analysis$
group by 
		unified_id)
select * 
from cte
where Ranke <=50 

-------Number of unit  by city-----------
select 
		city, 
		count(distinct unified_id) as count_unit
from 
		market_analysis$
group by 
		city

-----Revenue over time-----
select 
		month,
		sum(revenue) as total_revenue
from 
		market_analysis$
group by 
		month

---- Average occupancy rate by host type
SELECT host_type, AVG(occupancy) AS average_occupancy
FROM market_analysis$
GROUP BY host_type;

---- Average rental price by number of bedrooms----
ALTER TABLE market_analysis$
ALTER COLUMN [nightly rate] float 

SELECT bedrooms, AVG([nightly rate]) AS average_nightly_rate
FROM market_analysis$
GROUP BY bedrooms;




		





