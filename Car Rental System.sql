----CODING CHALLENGE
--------CAR RENTAL SYSTEM

--create database CarRental
create database CarRental


--create the tables

--- create table Vehicles
create table Vehicles(
vehicleID int primary key,
make varchar(30) not null,
model varchar(20) not null,
year int not null,
dailyRate decimal(10,2) not null,
status varchar(20) constraint Ck_status check(status in('available','notAvailable')),
passengerCapacity int not null,
engineCapacity int not null)

---create table Customers

create table Customers(
customerID int primary key,
firstName varchar(20) not null,
lastName varchar(20) not null,
email varchar(30) unique not null,
phoneNumber varchar(20) not null)

---create table Lease

create table Lease(
leaseID int primary key,
vehicleID int not null
foreign key references Vehicles(vehicleID)
on delete cascade
on update cascade,
customerId int not null
foreign key references Customers(customerID)
on delete cascade
on update cascade,
startDate date not null,
endDate date not null,
type  varchar(20) constraint Ck_type check(type in('Daily','Monthly')))


---create table Payment

create table Payment(
paymentID int primary key,
leaseID int not null
foreign key references Lease(leaseID)
on delete cascade
on update cascade,
paymentDate date not null,
amount decimal(10,2) not null)

---Insert the values into Vehicle table

insert into Vehicles(vehicleID, make,model,year,dailyRate, status,passengerCapacity,engineCapacity) values
(1, 'Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 'notAvailable', 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 'available', 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 'available', 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 'notAvailable', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 'available', 7, 2499)

insert into Vehicles(vehicleID,make,model,year,dailyRate,status,passengerCapacity,engineCapacity) values
(8, 'Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 'notAvailable', 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 'available', 4, 2500)


---Insert the values into Customers table
insert into Customers(customerID,firstName,lastName,email,phoneNumber) values
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321')


---Insert the values into Lease table
insert into Lease(leaseID,vehicleID,customerId,startDate,endDate,type) values
(1,1,1,'2023-01-01','2023-01-05','Daily'),
(2,2,2,'2023-02-15','2023-02-28','Monthly'),
(3,3,3,'2023-03-10','2023-03-15','Daily'),
(4,4,4,'2023-04-20','2023-04-30','Monthly'),
(5,5,5,'2023-05-05','2023-05-10','Daily'),
(6,4,3,'2023-06-15','2023-06-30','Monthly'),
(7,7,7,'2023-07-01','2023-07-10','Daily'),
(8,8,8,'2023-08-12','2023-08-15','Monthly'),
(9,3,3,'2023-09-07','2023-09-10','Daily'),
(10,10,10,'2023-10-10','2023-10-31', 'Monthly')


---Insert the values into Payment table
insert into Payment(paymentID,leaseID,paymentDate,amount) values
(1,1,'2023-01-03',200.00),
(2,2,'2023-02-20',1000.00),
(3,3,'2023-03-12',75.00),
(4,4,'2023-04-25',900.00),
(5,5,'2023-05-07',60.00),
(6,6,'2023-06-18',1200.00),
(7,7, '2023-07-03',40.00),
(8,8,'2023-08-14',1100.00),
(9,9,'2023-09-09',80.00),
(10,10,'2023-10-25',1500.00)

-----1. Update the daily rate for a Mercedes car to 68. 

update Vehicles
set dailyRate=68
where make='Mercedes'

select * from Vehicles 

-----2. Delete a specific customer and all associated leases and payments. 

delete from Customers
where customerID=2

select * from Customers

-----3. Rename the "paymentDate" column in the Payment table to "transactionDate". 

exec sp_rename 'Payment.paymentDate', 'transactionDate', 'column'

select * from payment

-----4. Find a specific customer by email. 

select * from Customers
where email='sarah@example.com'

-----5. Get active leases for a specific customer. 
--------active lease = lease which is which valid at the momemt

select * from Lease
where CustomerID=4 and endDate>=getdate()

-----6. Find all payments made by a customer with a specific phone number. 

select concat(c.firstName,' '+c.lastName) as customer_name,c.phoneNumber,p.amount,p.transactionDate
from Lease l
join Customers c 
on l.customerID = c.customerID
join Payment p 
on l.leaseID = p.leaseID
where c.phoneNumber = '555-555-5555'
group by concat(c.firstName,' '+c.lastName),c.phoneNumber,p.amount,p.transactionDate

-----7. Calculate the average daily rate of all available cars. 

select avg(dailyRate) 
as avg_rate 
from Vehicles


-----8. Find the car with the highest daily rate. 

select top 1 * from Vehicles
order by dailyRate desc


-----9. Retrieve all cars leased by a specific customer.

select v.vehicleID, v.make, v.model,concat(c.firstName,' '+c.lastName) as customer_name
from Lease l
join Vehicles v 
on l.vehicleID = v.vehicleID
join Customers c 
on l.customerID = c.customerID
where c.firstName = 'Robert'
group by v.vehicleID,v.make,v.model,concat(c.firstName,' '+c.lastName)

-----10. Find the details of the most recent lease. 

select top 1 * from Lease
order by StartDate desc

-----11. List all payments made in the year 2023. 

select * from Payment
where year(transactionDate) = 2023

-----12. Retrieve customers who have not made any payments. 

select c.customerID, concat(c.firstName, ' '+c.lastName) as customer_name
from Customers c
where not exists(
select 1 from lease l
join Payment p on l.leaseID = p.leaseID
where l.customerID = c.customerID)

-----13. Retrieve Car Details and Their Total Payments. 

select v.vehicleID,v.make,v.model, sum(p.amount) as total_payments
from lease l
join Vehicles v 
on l.vehicleID = v.vehicleID
join payment p 
on l.leaseID = p.leaseID
group by v.vehicleID,v.make,v.model

-----14. Calculate Total Payments for Each Customer. 

select concat(c.firstName, ' '+c.lastName) as customer_name, sum(p.amount) as total_amount
from Lease l
join Customers c 
on l.customerID = c.customerID
join Payment p 
on l.leaseID = p.leaseID
group by concat(c.firstName, ' '+c.lastName)

-----15. List Car Details for Each Lease. 

select l.leaseID,v.vehicleID,v.make,v.model,l.type
from Vehicles v
join Lease l 
on v.vehicleID = l.vehicleID

-----16. Retrieve Details of Active Leases with Customer and Car Information. 

select v.*, c.*, l.leaseID
from Lease l
join Customers c 
on l.customerID = c.customerID
join Vehicles v 
on l.vehicleID = v.vehicleID
where l.endDate> getdate()

-----17. Find the Customer Who Has Spent the Most on Leases. 

select top 1 l.customerID,concat(c.firstName, ' '+c.lastName) as customer_name, sum(p.amount) as pay_amounts
from Lease l
join Payment p 
on l.leaseID = p.leaseID
join Customers c 
on l.customerID = c.customerID
group by l.customerID, concat(c.firstName, ' '+c.lastName)
order by pay_amounts desc

-----18. List All Cars with Their Current Lease Information. 

select v.vehicleID,v.make,v.model,l.type
from Vehicles v
join Lease l 
on v.vehicleID = l.vehicleID
order by v.vehicleId
