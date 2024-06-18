CREATE DATABASE Question3
go

use Question3
go

CREATE TABLE employees(
	id int  IDENTITY(1,1) primary key 
	,name varchar (50)
	,department varchar (50)
	,salary int 
	,join_date date
)
go

CREATE TABLE ORDERS(
	Order_id int primary key
	,Date_Order varchar(30)
	,Good_Type varchar(30)
	,Good_Amount int
	,Client_ID int
)
go

CREATE TABLE ORDER_DELIVERY (
	Order_id int primary key
	,Date_Delivery varchar(30)
	,Delivery_Employee_Code char (2)
	foreign key (Order_id) references ORDERS(Order_id)
)
go


insert into ORDERS (Order_id,Date_Order,Good_Type,Good_Amount,Client_ID)
values (10,'01.May.2019','Computer',10000000,88),
	(12,'04.Sep.2019','Computer',10000000,88),
	(13,'03.Sep.2019','Computer',10000000,88),
	(14,'25.May.2019','Computer',10000000,88),
	(24,'06.Jun.2020','laptop',8000000,123),
	(35,'07.Oct.2020','Monitor',3000000,10);
insert into ORDERS (Order_id,Date_Order,Good_Type,Good_Amount,Client_ID)
values (38,'09.Aug.2020','Monitor',3000000,10),
	   (37,'28.Feb.2020','Monitor',3000000,10);

insert into ORDER_DELIVERY(Order_id,Date_Delivery,Delivery_Employee_Code)
values (10,'05.May.2019','1a'),
	(12,'04.Sep.2019','1a'),
	(13,'03.Sep.2019','1a'),
	(14,'25.May.2019','5a'),
	(24,'22.July.2020','5c'),
	(35,'09.Nov.2020','6e');
go

select * From employees
select * From ORDER_DELIVERY
select * From ORDERS
delete ORDER_DELIVERY
delete ORDERS

--Count number of unique client order and number of orders by order month.
SELECT Client_ID,COUNT(DISTINCT Order_id) as uniqueclitent,MONTH(Date_Order) as OrderMonth  ,COUNT(Order_id) as ordercount
From ORDERS
Group by 
Client_ID,
MONTH(Date_Order)
order by Client_ID
go

--Get list of client who have more than 10 orders in this year.
SELECT Client_ID,YEAR(Date_Order) as OrderYear , Count(Order_id) as ordercount
FROM ORDERS
group by Client_ID,YEAR(Date_Order)
having Count(Order_id) > 10
go

--From the above list of client: get information of first and second last order of client (Order date,good type, and amount)

with ClientOrder as(
	Select Client_ID
	,Date_Order
	,Good_Type
	,Good_Amount
	,ROW_NUMBER() OVER(PARTITION BY Client_ID ORDER BY Date_Order) as Rownumber
	,ROW_NUMBER() OVER(PARTITION BY Client_ID ORDER BY Date_Order DESC) as RownumberDesc
	From ORDERS
	where Client_ID in (
			SELECT Client_ID
			FROM ORDERS
			group by Client_ID,YEAR(Date_Order)
			having Count(Order_id) > 10
	)

)
Select Client_ID
	  ,Date_Order
	  ,Good_Type
	  ,Good_Amount
	  
FROM ClientOrder
where Rownumber = 1 or RownumberDesc = 2

   SELECT Client_ID,Date_Order
   FROM ORDERS
   order by Client_ID,Date_Order
go

--Calculate total good amount and Count number of Order which were delivered in Sep.2019
SELECT sum(b.Good_Amount) as [total good amount in Sep.2019]
FROM ORDER_DELIVERY a inner join ORDERS b 
	on a.Order_id = b.Order_id
where MONTH(a.Date_Delivery) = 9 and YEAR(a.Date_Delivery) = 2019
Select *
FRom ORDER_DELIVERY
go

--Assuming your 2 tables contain a huge amount of data and each join will take about 30 hours,while you need to do daily report, what is your solution?
--Câu trả lời của em ở đây là sử dụng index và bảng tạm
--lí do là vì trong quá trình học em có nghe thầy cô nói để xử lý 1 lượng dữ liệu khổng lổ thì sẽ mất rất nhiều thời gian
--Để có thể xử lý có thể dùng index	còn lí do gì thì chắc em sẽ tìm hiểu thêm ạ tại thầy cô chỉ nói sơ qua thôi ạ
--Còn về bảng tạm thì trong quá trình học hiện tại thì có 1 lần e cũng có nghe qua thầy cô kêu sử dụng bảng tạm khi dữ liệu phức tạm và lớn thì em nghĩ cũng có thể áp dụng ở đây 
--bởi vì chương trình học dữ liệu ko quá lớn nên thầy cô khôgn đi sau về phần này nên kiến thức của em tới đây thôi ạ em sẽ dành thời gian để tìm hiểu thêm