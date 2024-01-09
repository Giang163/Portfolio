--Content of the datasets
--Each row represents a customer, each column contains customer’s attributes described on the column Metadata.

--The data set includes information about:
--Customers who left within the last month – the column is called Churn
--Services that each customer has signed up for – phone, multiple lines, internet, online security, online backup, device protection, tech support, and streaming TV and movies
--Customer account information – how long they’ve been a customer, contract, payment method, paperless billing, monthly charges, and total charges
--Demographic info about customers – gender, age range, and if they have partners and dependents

--I will explore the data and try to answer some questions like:

select * from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]

--1. What's the % of Churn Customers and customers that keep in with the active services?
select Churn from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
SELECT 
	'yes' as Churn,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS customer_count,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS percentage
FROM 
    [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]

union all
SELECT 
	'no' as Churn,
    SUM(CASE WHEN churn = 'no' THEN 1 ELSE 0 END) AS customer_count,
    SUM(CASE WHEN churn = 'no' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS percentage
FROM 
    [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]

--2.The gender ratio among Churn customers
select gender,
	count(*) as gender_count, 
	(count(*) * 100)/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn ='yes') as percentage
FROM [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
group by gender

--3.Partner ratio --
select churn, Partner, concat(count(Partner)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'no'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'no'
group by  churn, Partner
union all
select churn, Partner, concat(count(Partner)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'yes'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
group by  churn, Partner
--The majority of churn customer don’t have a partner.
--Among those who didn't churn, there are more people with a partner.

--4. Number of customer who is Churn 
select SeniorCitizen, count(SeniorCitizen) as cus_num 
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
Group by SeniorCitizen

--5. Which service do churned customers prefer the most?
with service_use as (
	select 'PhoneService' as cus_Service, count(PhoneService) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where PhoneService = 'yes' and churn ='Yes'
	union all
	select 'MultipleLines' as cus_Service, count(MultipleLines) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where MultipleLines = 'yes' and churn ='Yes'
	union all 
	select 'InternetService' as cus_Service,
	count(case when InternetService = 'DSL' or InternetService = 'Fiber Optic'  then 1 else 0 end) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where  churn ='Yes'
	union all 
	select 'OnlineSecurity' as cus_Service, count(OnlineSecurity) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where OnlineSecurity = 'yes' and churn ='Yes'
	union all 
	select 'OnlineBackup' as cus_Service, count(OnlineBackup) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where OnlineBackup = 'yes' and churn ='Yes'
	union all 
	select 'DeviceProtection' as cus_Service, count(DeviceProtection) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where DeviceProtection = 'yes' and churn ='Yes'
	union all 
	select 'TechSupport' as cus_Service, count(TechSupport) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where TechSupport = 'yes'
	union all 
	select 'StreamingTV' as cus_Service, count(StreamingTV) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where StreamingTV = 'yes' and churn ='Yes'
	union all 
	select 'StreamingMovies' as cus_Service, count(StreamingMovies) as cus_num
	from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
	where StreamingMovies = 'yes' and churn ='Yes'
	)
select  *
from service_use
select  max(cus_num) as max_service
from service_use
select  min(cus_num) as min_service
from service_use
--- Identify the customers who have churned and used techsupport the most---

--6. PaymentMethod
select PaymentMethod, concat(count(PaymentMethod)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'yes'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
Group by PaymentMethod

select PaymentMethod, concat(count(PaymentMethod)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'no'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'no'
Group by PaymentMethod

----The majority of churned customers prefer using Electronic check--

--7. The types of contracts that customers sign (both churn and non-churn)
select churn, Contract, concat(count(Contract)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'yes'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
Group by Contract, churn

select churn, Contract, concat(count(Contract)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'no'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'no'
Group by Contract, churn

----- The majority of churned customers sign the shortest-term contracts: one-month contracts.--

---8. MonthlyCharges--
select churn, avg(cast(MonthlyCharges as float)) as avg_MonthlyCharges
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
group by churn
--Churned customers have to pay more money monthly--

















