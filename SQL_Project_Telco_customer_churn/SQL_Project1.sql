--Content of the datasets
--Each row represents a customer, each column contains customer’s attributes described on the column Metadata.

--The data set includes information about:
--Customers who left within the last month – the column is called Churn
--Services that each customer has signed up for – phone, multiple lines, internet, online security, online backup, device protection, tech support, and streaming TV and movies
--Customer account information – how long they’ve been a customer, contract, payment method, paperless billing, monthly charges, and total charges
--Demographic info about customers – gender, age range, and if they have partners and dependents

--I will explore the data and try to answer some questions like:
--What's the % of Churn Customers and customers that keep in with the active services?
--The gender ratio among Churn customers
--Which service do churned customers prefer the most?
---What's the most profitable service types?
--Which features and services are most profitable?


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

--3. Which service do churned customers prefer the most?
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
--- có thể thấy những khách hàng đã rời bỏ sửu dụng dịch vụ techsupport nhiều nhất---

--4. 
select SeniorCitizen, count(SeniorCitizen)
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
Group by SeniorCitizen

--5. PaymentMethod
select PaymentMethod, concat(count(PaymentMethod)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'yes'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
Group by PaymentMethod

select PaymentMethod, concat(count(PaymentMethod)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'no'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'no'
Group by PaymentMethod

----da so churn customer thich dung Electronic check hon

--contract
select Contract, concat(count(Contract)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'yes'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
Group by Contract

select Contract, concat(count(Contract)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'no'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'no'
Group by Contract

----- đa số chỉ ký hợp đồng ngắn hạn --

---MonthlyCharges--
select churn, avg(cast(MonthlyCharges as float)) as avg_MonthlyCharges
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
group by churn
--churn customer phải trả nhiều tiền hàng tháng hơn

--Partner--
select churn, Partner, concat(count(Partner)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'no'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'no'
group by  churn, Partner
union all
select churn, Partner, concat(count(Partner)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'yes'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
group by  churn, Partner

----- nhóm người churn thì đa số không có partner
-----nhóm người no churn thì số người có partner nhiều hơn

--Dependents--
select churn, Dependents, concat(count(Dependents)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'no'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'no'
group by  churn, Dependents
union all
select churn, Dependents, concat(count(Dependents)*100/(select count(*) from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn] where churn = 'yes'),'%') as use_by_churn
from [dbo].[WA_Fn-UseC_-Telco-Customer-Churn]
where churn = 'yes'
group by  churn, Dependents







