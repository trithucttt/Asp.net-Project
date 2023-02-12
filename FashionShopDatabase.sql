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
	firstName nvarchar(20) not null,
	lastName nvarchar(20) not null,
	phoneNumber nvarchar(10) not null,
	email nvarchar(150) not null,
	username varchar(20) not null,
	password varchar(30) not null,
	admin tinyint not null,
	adress nvarchar(150) not null,
	province nvarchar(30) not null,
	city nvarchar(30) not null,
	country nvarchar(30) not null
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
	imgae_url nvarchar(100)
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
	voucher_id bigint,
	order_status nvarchar(40) not null check(order_status IN('Đã chấp nhận', 'Đang chuẩn bị hàng', 'Đơn hàng đã chuẩn bị xong','Đang xử lý','Đang giao','Đã giao'))
)

if exists(select name from sysobjects where name = 'Order_Item')
	drop table Order_Item
create table Order_Item
(
	id bigint not null primary key,
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
	content nvarchar(200),
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
	code varchar(20) not null,
	discount_percentage float not null,
	voucher_status nvarchar(40) not null check(voucher_status IN('Chưa sử dụng','Đã sử dụng')),
	start_date datetime not null,
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
	id bigint not null primary key,
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


use FashionShop

-- Color --
insert into Color values (1, 'black', 'rgb(0, 0, 0)')
insert into Color values (2, 'white', 'rgb(255, 255, 255)')

-- Size --
insert into Size values (1, 'S')
insert into Size values (2, 'M')
insert into Size values (3, 'L')
insert into Size values (4, 'XL')

-- User --
insert into Users values ('1', 'Thuong', 'Mon', '0123456789', 'pitithuong@gmail.com', 'thuongmoon', 'thuongmoon', '1', 'DHCT', 'Ninh Kieu', 'Can Tho', 'Viet Nam')

-- Products --
insert into Products values (1, 1, 'Áo Hoodie Local Brand AVA HD Logo', 
'Chất liệu: Vải Nỉ Cotton 100%, màu sắc: Trắng/Đen, form: Local Brand - Unisex, chất lượng in: In lụa dùng mực Nhật Bản chất lượng cao, bảo quản: Có thể giặt máy & giặt ngâm',
'297000', 'AVA', 'Có sẵn')

-- Product_Quantity --
-- (product_id, size_id, color_id, quantity)
insert into Product_Quantity values (1, 1, 1, 45)
insert into Product_Quantity values (1, 2, 1, 35)
insert into Product_Quantity values (1, 3, 1, 62)
insert into Product_Quantity values (1, 4, 1, 24)
insert into Product_Quantity values (1, 1, 2, 46)
insert into Product_Quantity values (1, 2, 2, 76)
insert into Product_Quantity values (1, 3, 2, 124)
insert into Product_Quantity values (1, 4, 2, 41)

-- Image --
insert into Image values (1, '.../image/pd1.1.png')
insert into Image values (2, '.../image/pd1.2.png')
insert into Image values (3, '.../image/pd1.3.png')


-- Product_Image --
insert into Product_Image values (1, 1)
insert into Product_Image values (1, 2)
insert into Product_Image values (1, 3)

-- Tag --
insert into Tag values (1, 'Áo Hàn Quốc')
insert into Tag values (2, 'Áo khoác')
insert into Tag values (3, 'Hoodie')
insert into Tag values (4, 'Áo Unisex')

-- Product_Tag --
insert into Product_Tag values (1, 1)
insert into Product_Tag values (1, 2)
insert into Product_Tag values (1, 3)
insert into Product_Tag values (1, 4)

-- Category --
insert into Category values (1, 0, 'Áo')
insert into Category values (2, 1, 'Áo khoác')
insert into Category values (3, 2, 'Hoodie')

-- Product_Category --
insert into Product_Category values(1, 1)
insert into Product_Category values(1, 2)
insert into Product_Category values(1, 3)

-- Product_Reviewing --
insert into Product_Reviewing values(1, 1, 1, 5, 'Hàng đẹp chất lượng đúng mô tả, sẽ ủng hộ lần sau', '2023-02-12 14:56:59')

-- Voucher --
-- (voucher_id, user_id, code, discount_percentage, voucher_status, startdate, end_date)
insert into Voucher values (1, 1, '0GIAMGIA', 0, 'Chưa sử dụng', '2022-02-14 14:56:59', '2099-02-14 14:56:59');

-- Orders --
-- (order_id, customer_id, order_date, original_price, reduced_price, total_price, voucher_id, order_status)
insert into Orders values (1, 1, '2023-02-11 14:56:59', 297000, 0, 297000, 1, 'Đã giao')

-- Order_Item --
-- (id, order_id, product_id, quantity, size, color)
insert into Order_Item values (1, 1, 1, 1, 4, 1)

-- Payment_Methods --
insert into Payment_Methods values (1, 'MoMo')
insert into Payment_Methods values (2, 'ZaloPay')
insert into Payment_Methods values (3, 'COD')

-- Payment_Detail --
-- (id, order_id, amount, payment_method, payment_status)
-- payment_status
-- 1 Chua thanh toan
-- 2 Da thanh toan
insert into Payment_Detail values (1, 1, 297000, 2, 2)










