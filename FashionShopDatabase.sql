use master

if exists(select name from sysdatabases where name = 'FashionShop')
	drop database FashionShop
create database FashionShop
go

if exists(select name from sysobjects where name = 'Users')
	drop table Users
create table Users
(
	user_id BIGINT primary key,
	firstName nchar(20) not null,
	lastName nchar(20) not null,
	phoneNumber nchar(10) not null,
	email nchar(150) not null,
	password varchar not null,
	admin tinyint not null,
	adress nvarchar(150) not null,
	province nchar(30) not null,
	city nchar(30) not null,
	country nchar(30) not null
)

if exists(select name from sysobjects where name = 'Products')
	drop table Products
create table Products
(
	product_id bigint primary key,
	name nvarchar(50) not null,
	descript text,
	imageURL nvarchar(100),
	price float not null,
	category_id int,
	brand_id int,
	product_availability nvarchar(40) not null check (product_availability IN('Hết hàng','Có sẵn','Đặt trước'))
)

if exists(select name from sysobjects where name = 'Orders')
	drop table Orders
create table Orders
(
	order_id bigint primary key,
	customer_id bigint not null,
	order_date datetime not null,
	shipping_address nvarchar(100) not null,
	original_price float not null,
	reduced_price float,
	total_price float not null,
	payment_id bigint not null,
	voucher_id bigint,
	order_status nvarchar(40) not null check(order_status IN('Đang xử lý','Đang giao','Đã giao'))
)

if exists(select name from sysobjects where name = 'Cart')
	drop table Cart
create table Cart
(
	cart_id bigint primary key,
	user_id bigint not null,
	product_id bigint not null,
	quantity smallint not null,
	size varchar(5) not null,
	color varchar(10) not null,
	total_price float not null
)

if exists(select name from sysobjects where name = 'Category')
	drop table Category
create table Category
(
	category_id bigint primary key,
	parent_id bigint,
	name nvarchar(20) not null
)

if exists(select name from sysobjects where name = 'Voucher')
	drop table Voucher
create table Voucher
(
	voucher_id bigint primary key,
	code varchar(10) not null,
	discount_percentage int not null,
	voucher_status nvarchar(40) not null check(voucher_status IN('Chưa sử dụng','Đã sử dụng')),
	startdate datetime not null,
	end_date datetime not null
)
