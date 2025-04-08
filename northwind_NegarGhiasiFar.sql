-- 1) 
select count(*) from orders

-- 2) 
with cte as (
select orderid, o.ProductID, p.ProductName, o.Quantity, price, (o.Quantity*price) TotalPrice from orderdetails o
join products p on p.ProductID = o.ProductID
)
select sum(totalprice) SumEarned from cte

-- 3)
select c.CustomerID, c.CustomerName, sum(od.Quantity*price) TotalSpent
from customers c
join orders o on o.CustomerID = c.CustomerID
join orderdetails od on od.OrderID = o.OrderID
join products p on p.ProductID = od.ProductID
group by c.CustomerID, c.CustomerName
order by TotalSpent desc
limit 5

-- 4)
select c.CustomerID, c.CustomerName, avg(od.Quantity*price) AverageSpent
from customers c
join orders o on o.CustomerID = c.CustomerID
join orderdetails od on od.OrderID = o.OrderID
join products p on p.ProductID = od.ProductID
group by c.CustomerID, c.CustomerName
order by AverageSpent desc

-- 5) 
select c.CustomerID, c.CustomerName,
count(distinct(o.OrderID)) CntOrders, sum(od.Quantity*price) TotalSpent,
row_number() over(order by sum(od.Quantity*price) desc) Ranks
from customers c
join orders o on o.CustomerID = c.CustomerID
join orderdetails od on od.OrderID = o.OrderID
join products p on p.ProductID = od.ProductID
group by c.CustomerID, c.CustomerName
having CntOrders > 5
order by TotalSpent desc

-- 6)
select o.ProductID, p.ProductName, sum(o.Quantity*p.Price) TotalBought from products p
join orderdetails o on o.ProductID = p.ProductID
group by o.ProductID, p.ProductName
order by TotalBought desc
limit 1

-- 7) 
select c.CategoryID, count(p.ProductID) CntProducts from categories c
join products p on p.CategoryID = c.CategoryID
group by c.CategoryID
order by CntProducts desc

-- 8)
with cte as (
select ca.CategoryID, ca.CategoryName, p.ProductName, sum(od.Quantity*price) as TotalSpent,
row_number() over(partition by CategoryName order by sum(od.Quantity*price) desc) as Ranks
from orderdetails od
join products p on p.ProductID = od.ProductID
join categories ca on ca.CategoryID = p.CategoryID
group by ca.CategoryID, ca.CategoryName, p.ProductName)

select * from cte
where ranks = 1

-- 9)
select e.EmployeeID, e.FirstName, e.LastName, sum(Quantity*Price) TotalEarned
from orders o
join orderdetails od on od.OrderID = o.OrderID
join products p on p.ProductID = od.ProductID
join employees e on e.EmployeeID = o.EmployeeID
group by  e.EmployeeID, e.FirstName, e.LastName
order by TotalEarned desc
limit 5

-- 10)
select e.EmployeeID, e.FirstName, e.LastName, avg(Quantity*Price) AverageEarned
from orders o
join orderdetails od on od.OrderID = o.OrderID
join products p on p.ProductID = od.ProductID
join employees e on e.EmployeeID = o.EmployeeID
group by  e.EmployeeID, e.FirstName, e.LastName
order by AverageEarned desc

-- 11)
select Country, count(o.OrderID) CntOrders
from customers c
join orders o on o.CustomerID = c.CustomerID
join orderdetails od on od.OrderID = o.OrderID
group by Country
order by CntOrders desc
limit 1

-- 12)
select country, sum(Quantity*Price) TotalEarned
from customers c
join orders o on o.CustomerID = c.CustomerID
join orderdetails od on od.OrderID = o.OrderID
join products p on p.ProductID = od.ProductID
group by Country
order by TotalEarned desc

-- 13)
select c.CategoryID, c.CategoryName, avg(p.Price) AveragePrice from categories c
join products p on p.CategoryID = c.CategoryID
 group by c.CategoryID, c.CategoryName
 order by AveragePrice desc
 
 -- 14)
select distinct(ca.CategoryID), ca.CategoryName
, sum(price) over(partition by CategoryID) as CategoryPrice
from products p
join categories ca on ca.CategoryID = p.CategoryID
order by CategoryPrice desc
limit 1

-- 15)
select month(OrderDate) Months, count(*) CntOrders from orders
where year(OrderDate) = '1996'
group by month(OrderDate)


-- 16)
with cte1 as (
select c.CustomerID
from customers c
join orders o on o.CustomerID = c.CustomerID
group by c.CustomerID
having count(orderid) > 1)
, cte2 as(
select cte1.CustomerID, o.OrderID
, datediff(orderdate, lag(orderdate) over(partition by customerid order by orderdate)) orderdatediff
from cte1
join orders o on o.CustomerID = cte1.CustomerID
order by cte1.customerid)

select customerid, avg(orderdatediff) AverageDateDiff from cte2
where orderdatediff is not null
group by customerid

-- 17)
select 
case 
when OrderDate >= '1996-07-04' and OrderDate <= '1996-09-21' then 'Summer'
when OrderDate >= '1996-09-22' and OrderDate <= '1996-12-20' then 'Fall'
when OrderDate >= '1996-12-21' and OrderDate <= '1997-02-12' then 'Winter'
end Season
, count(OrderID) CntOrders
from orders
group by Season
order by CntOrders desc

-- 18)
select s.SupplierID, s.SupplierName, sum(Quantity) CntProducts from suppliers s
join products p on p.SupplierID = s.SupplierID
join orderdetails od on od.ProductID = p.ProductID
group by s.SupplierID, s.SupplierName
order by CntProducts desc
limit 1

-- 19)
select s.SupplierID, s.SupplierName, avg(Price) AveragePrice from suppliers s
join products p on p.SupplierID = s.SupplierID
group by s.SupplierID, s.SupplierName
order by AveragePrice desc
