# This dataset contains 7 table
 Users,Orders,Order_details,Restaurants,Food,Menu & delivery_partner.


1)
 NO OF ORDERS FROM EACH RESTRAUNTS?

select r.r_name,count(*) as frequency
FROM ORDERS o
join restraunts r
on o.r_id=r.r_id 
join order_details od
on o.order_id=od.order_id
group by r.r_name
order by frequency desc;


2)
 Find the month-wise number of orders across all restraunts?

select monthname(DATE),COUNT(*)
FROM ORDERS o
join restraunts r
on o.r_id=r.r_id 
join order_details od
on o.order_id=od.order_id
group by monthname(DATE);


3)
 Which food item has been ordered the most across all restraunts ?

select f_name,count(*)
FROM order_details 	od
join food f 
on od.f_id=f.f_id 
group by f_name;


4)
 Find the no of veg pizza and non-veg pizza are ordered Among all the restraunts?

select f_name,count(*)
FROM order_details 	od
join food f 
on od.f_id=f.f_id 
where f_name in ('non-veg pizza','veg pizza')
group by f_name;


5)
 Find the customers who never ordered from zomato?

select name from users where user_id not in
(select user_id from orders);


6)
 AVG PRICE PER DISH (considering the price of all restraunts) ?

select m.f_id,avg(price),f.f_name
from menu m
join food f
on m.f_id=f.f_id
group by m.f_id;


7)
FIND TOP RESTRAUNTS IN TERMS OF ORDERS FOR A MONTH OF JUNE ?

select restraunts.r_name,count(*)
from orders 
join restraunts
on orders.r_id=restraunts.r_id
where monthname(date) like 'june'
group by orders.r_id
order by count(*) desc limit 1;

8)
 FIND TOP RESTRAUNTS FOR ALL 3 MONTHS ?

select o.r_id,r.r_name,count(*),monthname(date)
from orders o 
join restraunts r 
on o.r_id=r.r_id
where monthname(date) in ('june','may','july')
group by o.r_id,monthname(date)
order by count(*) desc limit 3;

9)
 RESTRAUNTS WITH MONTHLY SALES > 500 FOR THE MONTH OF JUNE ?

SELECT o.r_id,r.r_name,sum(amount),monthname(date)
FROM ORDERS o 
join restraunts r 
on o.r_id=r.r_id
where monthname(date) like 'june' 
group by o.r_id,monthname(date)
having sum(amount)>500
order by sum(amount) desc;

9)
 Show all the orders with orders detail for a particular customer in a particular date range ?
 HERE WE TAKE USER_ID-5
 
select o.order_id,date,r.r_name,f.f_name
from orders o 
join order_details d 
on o.user_id=d.id
join restraunts r 
on o.r_id=r.r_id
join food f 
on d.f_id=f.f_id
where user_id=5
having date between "2022-06-10" and "2022-07-28" ;


10)
 FIND THE RESTRAUNTS WITH MAXM REPEATED CUSTOMERS ?

select r.r_name,count(*) as loyal_customers
from
(
select r_id,user_id,count(*)
from orders
group by r_id,user_id
having count(*) >1
)t
join restraunts r
on t.r_id=r.r_id
group by t.r_id
order by loyal_customers desc limit 1


11) 
 Month on Month revenue growth rate of zomato ?

select monthname(date),sum(amount),
lag(sum(amount)) over(),
(((sum(amount))-(lag(sum(amount)) over()))/(lag(sum(amount)) over()))*100 as mom_growth_rate
from orders
group by monthname(date);

12)
 Favorite food of each customers ?

---BY THE USE OF CTE & WINDOW FN.

WITH temp as
(
select o.user_id,u.name,f.f_name,count(*) as fre
from orders o 
join users u 
on o.user_id=u.user_id
join order_details od
on o.order_id=od.order_id
join food f 
on od.f_id=f.f_id
group by u.name,f.f_name,o.user_id
),
ram as
(
select *, 
dense_rank() over(partition by user_id order by fre desc) as 'rank_of_food'
from temp
)
select name,f_name,fre
from ram
where ram.rank_of_food<2;


          OR
BY THE USE OF CTE & SUB QUERY

with temp as
(select user_id,f_id,count(*)as freq 
from orders o
join order_details od
on od.order_id = o.order_id
group by user_id,f_id
)
select name,f_name,freq 
from temp t1
join food f
on f.f_id = t1.f_id
join users u
on u.user_id = t1.user_id
where t1.freq = (select max(freq) from temp t2 where t2.user_id = t1.user_id);

