use master

if exists(select name from sysdatabases where name = 'FashionShop')
	drop database FashionShop
create database FashionShop
go

use FashionShop

if exists(select name from sysobjects where name = 'Users')
	drop table Users
create table Users
(
	user_id BIGINT not null primary key,
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
	user_id bigint,
	name nvarchar(50) not null,
	descript text,
	price float not null,
	brand nvarchar(50),
	product_availability nvarchar(40) not null check (product_availability IN('Hết hàng','Có sẵn','Đặt trước'))
)

if exists(select name from sysobjects where name = 'Product_Image')
	drop table Product_Image
create table Product_Image
(
	product_id bigint,
	image_id bigint
)

if exists(select name from sysobjects where name = 'Image')
	drop table Image
create table Image
(
	image_id bigint not null primary key,
	imgae_url nvarchar
)

if exists(select name from sysobjects where name = 'Size')
	drop table Size
create table Size
(
	size_id bigint not null primary key,
	size nvarchar(20)
)

if exists(select name from sysobjects where name = 'Color')
	drop table Color
create table Color
(
	color_id bigint not null primary key,
	color nvarchar(20),
	rgb nvarchar(30)
)

if exists(select name from sysobjects where name = 'Product_Quantity')
	drop table Product_Quantity
create table Product_Quantity
(
	product_id bigint,
	size_id bigint,
	color_id bigint,
	quantity int
)

if exists(select name from sysobjects where name = 'Product_Tag')
	drop table Product_Tag
create table Product_Tag
(
	product_id bigint,
	tag_id bigint
)

if exists(select name from sysobjects where name = 'Tag')
	drop table Tag
create table Tag
(
	tag_id bigint not null primary key,
	tag_name nvarchar(30)
)

if exists(select name from sysobjects where name = 'Orders')
	drop table Orders
create table Orders
(
	order_id bigint primary key,
	customer_id bigint not null,
	order_date datetime not null,
	original_price float not null,
	reduced_price float,
	total_price float not null,
	payment_id bigint not null,
	voucher_id bigint,
	order_status nvarchar(40) not null check(order_status IN('Đang xử lý','Đang giao','Đã giao'))
)

if exists(select name from sysobjects where name = 'Order_Item')
	drop table Order_Item
create table Order_Item
(
	id bigint primary key,
	order_id bigint,
	product_id bigint,
	quantity smallint not null,
	size varchar(5) not null,
	color varchar(10) not null,
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

if exists(select name from sysobjects where name = 'Product_Reviewing')
	drop table Product_Reviewing
create table Product_Reviewing
(
	id bigint primary key,
	user_id bigint not null,
	product_id bigint not null,
	rating smallint not null,
	content nvarchar,
	publishedAt datetime
)

if exists(select name from sysobjects where name = 'Category')
	drop table Category
create table Category
(
	category_id bigint primary key,
	parent_id bigint,
	name nvarchar(20) not null
)

if exists(select name from sysobjects where name = 'Product_Category')
	drop table Product_Category
create table Product_Category
(
	product_id bigint,
	category_id bigint
)

if exists(select name from sysobjects where name = 'Voucher')
	drop table Voucher
create table Voucher
(
	voucher_id bigint primary key,
	user_id bigint,
	code varchar(10) not null,
	discount_percentage int not null,
	voucher_status nvarchar(40) not null check(voucher_status IN('Chưa sử dụng','Đã sử dụng')),
	startdate datetime not null,
	end_date datetime not null
)

if exists(select name from sysobjects where name = 'Payment_Methods')
	drop table Payment_Methods
create table Payment_Methods
(
	id bigint not null primary key,
	name_methods nvarchar(100)
)

if exists(select name from sysobjects where name = 'Payment_Detail')
	drop table Payment_Detail
create table Payment_Detail
(
	order_id bigint,
	amount float,
	payment_method bigint,
	payment_status int,
)

ALTER TABLE Payment_Detail
ADD
constraint FK_PD_O FOREIGN KEY (order_id) REFERENCES Orders(order_id),
constraint FK_PD_PM FOREIGN KEY (payment_method) REFERENCES Payment_Methods(id)


ALTER TABLE Products
ADD
constraint FK_P_U FOREIGN KEY (user_id) REFERENCES Users(user_id)

ALTER TABLE Product_Image
ADD
constraint FK_PI_P FOREIGN KEY (product_id) REFERENCES Products(product_id),
constraint FK_PI_I FOREIGN KEY (image_id) REFERENCES Image(image_id)

ALTER TABLE Product_Quantity
ADD
constraint FK_PQ_P FOREIGN KEY (product_id) REFERENCES Products(product_id),
constraint FK_PQ_S FOREIGN KEY (size_id) REFERENCES Size(size_id),
constraint FK_PQ_C FOREIGN KEY (color_id) REFERENCES Color(color_id)

ALTER TABLE Product_Tag
ADD
constraint FK_PT_P FOREIGN KEY (product_id) REFERENCES Products(product_id),
constraint FK_PT_T FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)

ALTER TABLE Orders
ADD
constraint FK_O_U FOREIGN KEY (customer_id) REFERENCES Users(user_id),
constraint FK_O_V FOREIGN key (voucher_id) REFERENCES Voucher(voucher_id)

ALTER TABLE Voucher
ADD
constraint FK_V_U FOREIGN KEY (user_id) REFERENCES Users(user_id)

ALTER TABLE Product_Category
ADD
constraint FK_PC_P FOREIGN KEY (product_id) REFERENCES Products(product_id),
constraint FK_PC_C FOREIGN KEY (category_id) REFERENCES Category(category_id)

ALTER TABLE Category
ADD
constraint FK_C_C FOREIGN KEY (category_id) REFERENCES Category(category_id)

ALTER TABLE Product_Reviewing
ADD
constraint FK_PR_P FOREIGN KEY (product_id) REFERENCES Products(product_id),
constraint FK_PR_U FOREIGN KEY (user_id) REFERENCES Users(user_id)

ALTER TABLE Cart
ADD
constraint FK_C_P FOREIGN KEY (product_id) REFERENCES Products(product_id),
constraint FK_C_U FOREIGN KEY (user_id) REFERENCES Users(user_id)

ALTER TABLE Order_Item
ADD
constraint FK_OI_O FOREIGN KEY (order_id) REFERENCES Orders(order_id)