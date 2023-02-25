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
insert into Users values ('2','thuc','nguyen tri','12345678','thuc0416@gmail.com','trithuc','trithuc','1','Cai Khe','Ninh Kieu','Can Tho','Viet Nam')
insert into Users values ('3','Vo','Tran ','12345678','votran@gmail.com','user01','user01','0','Mau Than','Ninh Kieu','Can Tho','Viet Nam')
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

insert into Image values (11,'../../Content/images/products/banner_1.jpg')
insert into Image values (12,'../../Content/images/products/banner_1.jpg')
insert into Image values (13,'../../Content/images/products/banner_1.jpg')
insert into Image values (21,'../../Content/images/products/banner_2.jpg')
insert into Image values (22,'../../Content/images/products/banner_2.jpg')
insert into Image values (23,'../../Content/images/products/banner_2.jpg')
insert into Image values (31,'../../Content/images/products/banner_3.jpg')
insert into Image values (32,'../../Content/images/products/banner_3.jpg')
insert into Image values (33,'../../Content/images/products/banner_3.jpg')
insert into Image values (41,'../../Content/images/products/banner_4.jpg')
insert into Image values (42,'../../Content/images/products/banner_4.jpg')
insert into Image values (43,'../../Content/images/products/banner_4.jpg')
insert into Image values (51,'../../Content/images/products/banner_5.jpg')
insert into Image values (52,'../../Content/images/products/banner_5.jpg')
insert into Image values (53,'../../Content/images/products/banner_5.jpg')
insert into Image values (61,'../../Content/images/products/banner_6.jpg')
insert into Image values (62,'../../Content/images/products/banner_6.jpg')
insert into Image values (63,'../../Content/images/products/banner_6.jpg')
insert into Image values (71,'../../Content/images/products/banner_7.jpg')
insert into Image values (72,'../../Content/images/products/banner_7.jpg')
insert into Image values (73,'../../Content/images/products/banner_7.jpg')
insert into Image values (81,'../../Content/images/products/banner_8.jpg')
insert into Image values (82,'../../Content/images/products/banner_8.jpg')
insert into Image values (83,'../../Content/images/products/banner_8.jpg')
insert into Image values (91,'../../Content/images/products/banner_9.jpg')
insert into Image values (92,'../../Content/images/products/banner_9.jpg')
insert into Image values (93,'../../Content/images/products/banner_9.jpg')
insert into Image values (101,'../../Content/images/products/banner_10.jpg')
insert into Image values (102,'../../Content/images/products/banner_10.jpg')
insert into Image values (103,'../../Content/images/products/banner_10.jpg')
insert into Image values (111,'../../Content/images/products/banner_11.jpg')
insert into Image values (112,'../../Content/images/products/banner_11.jpg')
insert into Image values (113,'../../Content/images/products/banner_11.jpg')
insert into Image values (121,'../../Content/images/products/banner_12.jpg')
insert into Image values (122,'../../Content/images/products/banner_12.jpg')
insert into Image values (123,'../../Content/images/products/banner_12.jpg')
insert into Image values (131,'../../Content/images/products/banner_13.jpg')
insert into Image values (132,'../../Content/images/products/banner_13.jpg')
insert into Image values (133,'../../Content/images/products/banner_13.jpg')
insert into Image values (141,'../../Content/images/products/banner_14.jpg')
insert into Image values (142,'../../Content/images/products/banner_14.jpg')
insert into Image values (143,'../../Content/images/products/banner_14.jpg')
insert into Image values (151,'../../Content/images/products/banner_15.jpg')
insert into Image values (152,'../../Content/images/products/banner_15.jpg')
insert into Image values (153,'../../Content/images/products/banner_15.jpg')
insert into Image values (161,'../../Content/images/products/banner_16.jpg')
insert into Image values (162,'../../Content/images/products/banner_16.jpg')
insert into Image values (163,'../../Content/images/products/banner_16.jpg')
insert into Image values (171,'../../Content/images/products/banner_17.jpg')
insert into Image values (172,'../../Content/images/products/banner_17.jpg')
insert into Image values (173,'../../Content/images/products/banner_17.jpg')
insert into Image values (181,'../../Content/images/products/banner_18.jpg')
insert into Image values (182,'../../Content/images/products/banner_18.jpg')
insert into Image values (183,'../../Content/images/products/banner_18.jpg')
insert into Image values (191,'../../Content/images/products/banner_19.jpg')
insert into Image values (192,'../../Content/images/products/banner_19.jpg')
insert into Image values (193,'../../Content/images/products/banner_19.jpg')
insert into Image values (201,'../../Content/images/products/banner_20.jpg')
insert into Image values (202,'../../Content/images/products/banner_20.jpg')
insert into Image values (203,'../../Content/images/products/banner_20.jpg')
insert into Image values (211,'../../Content/images/products/banner_21.jpg')
insert into Image values (212,'../../Content/images/products/banner_21.jpg')
insert into Image values (213,'../../Content/images/products/banner_21.jpg')
insert into Image values (221,'../../Content/images/products/banner_22.jpg')
insert into Image values (222,'../../Content/images/products/banner_22.jpg')
insert into Image values (223,'../../Content/images/products/banner_22.jpg')
insert into Image values (231,'../../Content/images/products/banner_23.jpg')
insert into Image values (232,'../../Content/images/products/banner_23.jpg')
insert into Image values (233,'../../Content/images/products/banner_23.jpg')
insert into Image values (241,'../../Content/images/products/banner_24.jpg')
insert into Image values (242,'../../Content/images/products/banner_24.jpg')
insert into Image values (243,'../../Content/images/products/banner_24.jpg')
insert into Image values (251,'../../Content/images/products/banner_25.jpg')
insert into Image values (252,'../../Content/images/products/banner_25.jpg')
insert into Image values (253,'../../Content/images/products/banner_25.jpg')
insert into Image values (261,'../../Content/images/products/banner_26.jpg')
insert into Image values (262,'../../Content/images/products/banner_26.jpg')
insert into Image values (263,'../../Content/images/products/banner_26.jpg')
insert into Image values (271,'../../Content/images/products/banner_27.jpg')
insert into Image values (272,'../../Content/images/products/banner_27.jpg')
insert into Image values (273,'../../Content/images/products/banner_27.jpg')
insert into Image values (281,'../../Content/images/products/banner_28.jpg')
insert into Image values (282,'../../Content/images/products/banner_28.jpg')
insert into Image values (283,'../../Content/images/products/banner_28.jpg')
insert into Image values (291,'../../Content/images/products/banner_29.jpg')
insert into Image values (292,'../../Content/images/products/banner_29.jpg')
insert into Image values (293,'../../Content/images/products/banner_29.jpg')
insert into Image values (301,'../../Content/images/products/banner_30.jpg')
insert into Image values (302,'../../Content/images/products/banner_30.jpg')
insert into Image values (303,'../../Content/images/products/banner_30.jpg')
insert into Image values (311,'../../Content/images/products/banner_31.jpg')
insert into Image values (312,'../../Content/images/products/banner_31.jpg')
insert into Image values (313,'../../Content/images/products/banner_31.jpg')
insert into Image values (321,'../../Content/images/products/banner_32.jpg')
insert into Image values (322,'../../Content/images/products/banner_32.jpg')
insert into Image values (323,'../../Content/images/products/banner_32.jpg')
insert into Image values (331,'../../Content/images/products/banner_33.jpg')
insert into Image values (332,'../../Content/images/products/banner_33.jpg')
insert into Image values (333,'../../Content/images/products/banner_33.jpg')
insert into Image values (341,'../../Content/images/products/banner_34.jpg')
insert into Image values (342,'../../Content/images/products/banner_34.jpg')
insert into Image values (343,'../../Content/images/products/banner_34.jpg')
insert into Image values (351,'../../Content/images/products/banner_35.jpg')
insert into Image values (352,'../../Content/images/products/banner_35.jpg')
insert into Image values (353,'../../Content/images/products/banner_35.jpg')
insert into Image values (361,'../../Content/images/products/banner_36.jpg')
insert into Image values (362,'../../Content/images/products/banner_36.jpg')
insert into Image values (363,'../../Content/images/products/banner_36.jpg')
insert into Image values (371,'../../Content/images/products/banner_37.jpg')
insert into Image values (372,'../../Content/images/products/banner_37.jpg')
insert into Image values (373,'../../Content/images/products/banner_37.jpg')
insert into Image values (381,'../../Content/images/products/banner_38.jpg')
insert into Image values (382,'../../Content/images/products/banner_38.jpg')
insert into Image values (383,'../../Content/images/products/banner_38.jpg')
insert into Image values (391,'../../Content/images/products/banner_39.jpg')
insert into Image values (392,'../../Content/images/products/banner_39.jpg')
insert into Image values (393,'../../Content/images/products/banner_39.jpg')
insert into Image values (401,'../../Content/images/products/banner_40.jpg')
insert into Image values (402,'../../Content/images/products/banner_40.jpg')
insert into Image values (403,'../../Content/images/products/banner_40.jpg')
insert into Image values (411,'../../Content/images/products/banner_41.jpg')
insert into Image values (412,'../../Content/images/products/banner_41.jpg')
insert into Image values (413,'../../Content/images/products/banner_41.jpg')
insert into Image values (421,'../../Content/images/products/banner_42.jpg')
insert into Image values (422,'../../Content/images/products/banner_42.jpg')
insert into Image values (423,'../../Content/images/products/banner_42.jpg')
insert into Image values (431,'../../Content/images/products/banner_43.jpg')
insert into Image values (432,'../../Content/images/products/banner_43.jpg')
insert into Image values (433,'../../Content/images/products/banner_43.jpg')
insert into Image values (441,'../../Content/images/products/banner_44.jpg')
insert into Image values (442,'../../Content/images/products/banner_44.jpg')
insert into Image values (443,'../../Content/images/products/banner_44.jpg')
insert into Image values (451,'../../Content/images/products/banner_45.jpg')
insert into Image values (452,'../../Content/images/products/banner_45.jpg')
insert into Image values (453,'../../Content/images/products/banner_45.jpg')
insert into Image values (461,'../../Content/images/products/banner_46.jpg')
insert into Image values (462,'../../Content/images/products/banner_46.jpg')
insert into Image values (463,'../../Content/images/products/banner_46.jpg')
insert into Image values (471,'../../Content/images/products/banner_47.jpg')
insert into Image values (472,'../../Content/images/products/banner_47.jpg')
insert into Image values (473,'../../Content/images/products/banner_47.jpg')
insert into Image values (481,'../../Content/images/products/banner_48.jpg')
insert into Image values (482,'../../Content/images/products/banner_48.jpg')
insert into Image values (483,'../../Content/images/products/banner_48.jpg')
insert into Image values (491,'../../Content/images/products/banner_49.jpg')
insert into Image values (492,'../../Content/images/products/banner_49.jpg')
insert into Image values (493,'../../Content/images/products/banner_49.jpg')
insert into Image values (501,'../../Content/images/products/banner_50.jpg')
insert into Image values (502,'../../Content/images/products/banner_50.jpg')
insert into Image values (503,'../../Content/images/products/banner_50.jpg')
insert into Image values (511,'../../Content/images/products/banner_51.jpg')
insert into Image values (512,'../../Content/images/products/banner_51.jpg')
insert into Image values (513,'../../Content/images/products/banner_51.jpg')
insert into Image values (521,'../../Content/images/products/banner_52.jpg')
insert into Image values (522,'../../Content/images/products/banner_52.jpg')
insert into Image values (523,'../../Content/images/products/banner_52.jpg')
insert into Image values (531,'../../Content/images/products/banner_53.jpg')
insert into Image values (532,'../../Content/images/products/banner_53.jpg')
insert into Image values (533,'../../Content/images/products/banner_53.jpg')
insert into Image values (541,'../../Content/images/products/banner_54.jpg')
insert into Image values (542,'../../Content/images/products/banner_54.jpg')
insert into Image values (543,'../../Content/images/products/banner_54.jpg')
insert into Image values (551,'../../Content/images/products/banner_55.jpg')
insert into Image values (552,'../../Content/images/products/banner_55.jpg')
insert into Image values (553,'../../Content/images/products/banner_55.jpg')
insert into Image values (561,'../../Content/images/products/banner_56.jpg')
insert into Image values (562,'../../Content/images/products/banner_56.jpg')
insert into Image values (563,'../../Content/images/products/banner_56.jpg')
insert into Image values (571,'../../Content/images/products/banner_57.jpg')
insert into Image values (572,'../../Content/images/products/banner_57.jpg')
insert into Image values (573,'../../Content/images/products/banner_57.jpg')
insert into Image values (581,'../../Content/images/products/banner_58.jpg')
insert into Image values (582,'../../Content/images/products/banner_58.jpg')
insert into Image values (583,'../../Content/images/products/banner_58.jpg')
insert into Image values (591,'../../Content/images/products/banner_59.jpg')
insert into Image values (592,'../../Content/images/products/banner_59.jpg')
insert into Image values (593,'../../Content/images/products/banner_59.jpg')
insert into Image values (601,'../../Content/images/products/banner_60.jpg')
insert into Image values (602,'../../Content/images/products/banner_60.jpg')
insert into Image values (603,'../../Content/images/products/banner_60.jpg')
insert into Image values (611,'../../Content/images/products/banner_61.jpg')
insert into Image values (612,'../../Content/images/products/banner_61.jpg')
insert into Image values (613,'../../Content/images/products/banner_61.jpg')
insert into Image values (621,'../../Content/images/products/banner_62.jpg')
insert into Image values (622,'../../Content/images/products/banner_62.jpg')
insert into Image values (623,'../../Content/images/products/banner_62.jpg')
insert into Image values (631,'../../Content/images/products/banner_63.jpg')
insert into Image values (632,'../../Content/images/products/banner_63.jpg')
insert into Image values (633,'../../Content/images/products/banner_63.jpg')
insert into Image values (641,'../../Content/images/products/banner_64.jpg')
insert into Image values (642,'../../Content/images/products/banner_64.jpg')
insert into Image values (643,'../../Content/images/products/banner_64.jpg')
insert into Image values (651,'../../Content/images/products/banner_65.jpg')
insert into Image values (652,'../../Content/images/products/banner_65.jpg')
insert into Image values (653,'../../Content/images/products/banner_65.jpg')
insert into Image values (661,'../../Content/images/products/banner_66.jpg')
insert into Image values (662,'../../Content/images/products/banner_66.jpg')
insert into Image values (663,'../../Content/images/products/banner_66.jpg')
insert into Image values (671,'../../Content/images/products/banner_67.jpg')
insert into Image values (672,'../../Content/images/products/banner_67.jpg')
insert into Image values (673,'../../Content/images/products/banner_67.jpg')
insert into Image values (681,'../../Content/images/products/banner_68.jpg')
insert into Image values (682,'../../Content/images/products/banner_68.jpg')
insert into Image values (683,'../../Content/images/products/banner_68.jpg')
insert into Image values (691,'../../Content/images/products/banner_69.jpg')
insert into Image values (692,'../../Content/images/products/banner_69.jpg')
insert into Image values (693,'../../Content/images/products/banner_69.jpg')
insert into Image values (701,'../../Content/images/products/banner_70.jpg')
insert into Image values (702,'../../Content/images/products/banner_70.jpg')
insert into Image values (703,'../../Content/images/products/banner_70.jpg')
insert into Image values (711,'../../Content/images/products/banner_71.jpg')
insert into Image values (712,'../../Content/images/products/banner_71.jpg')
insert into Image values (713,'../../Content/images/products/banner_71.jpg')
insert into Image values (721,'../../Content/images/products/banner_72.jpg')
insert into Image values (722,'../../Content/images/products/banner_72.jpg')
insert into Image values (723,'../../Content/images/products/banner_72.jpg')
insert into Image values (731,'../../Content/images/products/banner_73.jpg')
insert into Image values (732,'../../Content/images/products/banner_73.jpg')
insert into Image values (733,'../../Content/images/products/banner_73.jpg')
insert into Image values (741,'../../Content/images/products/banner_74.jpg')
insert into Image values (742,'../../Content/images/products/banner_74.jpg')
insert into Image values (743,'../../Content/images/products/banner_74.jpg')
insert into Image values (751,'../../Content/images/products/banner_75.jpg')
insert into Image values (752,'../../Content/images/products/banner_75.jpg')
insert into Image values (753,'../../Content/images/products/banner_75.jpg')
insert into Image values (761,'../../Content/images/products/banner_76.jpg')
insert into Image values (762,'../../Content/images/products/banner_76.jpg')
insert into Image values (763,'../../Content/images/products/banner_76.jpg')
insert into Image values (771,'../../Content/images/products/banner_77.jpg')
insert into Image values (772,'../../Content/images/products/banner_77.jpg')
insert into Image values (773,'../../Content/images/products/banner_77.jpg')
insert into Image values (781,'../../Content/images/products/banner_78.jpg')
insert into Image values (782,'../../Content/images/products/banner_78.jpg')
insert into Image values (783,'../../Content/images/products/banner_78.jpg')
insert into Image values (791,'../../Content/images/products/banner_79.jpg')
insert into Image values (792,'../../Content/images/products/banner_79.jpg')
insert into Image values (793,'../../Content/images/products/banner_79.jpg')
insert into Image values (801,'../../Content/images/products/banner_80.jpg')
insert into Image values (802,'../../Content/images/products/banner_80.jpg')
insert into Image values (803,'../../Content/images/products/banner_80.jpg')
insert into Image values (811,'../../Content/images/products/banner_81.jpg')
insert into Image values (812,'../../Content/images/products/banner_81.jpg')
insert into Image values (813,'../../Content/images/products/banner_81.jpg')
insert into Image values (821,'../../Content/images/products/banner_82.jpg')
insert into Image values (822,'../../Content/images/products/banner_82.jpg')
insert into Image values (823,'../../Content/images/products/banner_82.jpg')
insert into Image values (831,'../../Content/images/products/banner_83.jpg')
insert into Image values (832,'../../Content/images/products/banner_83.jpg')
insert into Image values (833,'../../Content/images/products/banner_83.jpg')
insert into Image values (841,'../../Content/images/products/banner_84.jpg')
insert into Image values (842,'../../Content/images/products/banner_84.jpg')
insert into Image values (843,'../../Content/images/products/banner_84.jpg')
insert into Image values (851,'../../Content/images/products/banner_85.jpg')
insert into Image values (852,'../../Content/images/products/banner_85.jpg')
insert into Image values (853,'../../Content/images/products/banner_85.jpg')
insert into Image values (861,'../../Content/images/products/banner_86.jpg')
insert into Image values (862,'../../Content/images/products/banner_86.jpg')
insert into Image values (863,'../../Content/images/products/banner_86.jpg')
insert into Image values (871,'../../Content/images/products/banner_87.jpg')
insert into Image values (872,'../../Content/images/products/banner_87.jpg')
insert into Image values (873,'../../Content/images/products/banner_87.jpg')
insert into Image values (881,'../../Content/images/products/banner_88.jpg')
insert into Image values (882,'../../Content/images/products/banner_88.jpg')
insert into Image values (883,'../../Content/images/products/banner_88.jpg')
insert into Image values (891,'../../Content/images/products/banner_89.jpg')
insert into Image values (892,'../../Content/images/products/banner_89.jpg')
insert into Image values (893,'../../Content/images/products/banner_89.jpg')
insert into Image values (901,'../../Content/images/products/banner_90.jpg')
insert into Image values (902,'../../Content/images/products/banner_90.jpg')
insert into Image values (903,'../../Content/images/products/banner_90.jpg')
insert into Image values (911,'../../Content/images/products/banner_91.jpg')
insert into Image values (912,'../../Content/images/products/banner_91.jpg')
insert into Image values (913,'../../Content/images/products/banner_91.jpg')
insert into Image values (921,'../../Content/images/products/banner_92.jpg')
insert into Image values (922,'../../Content/images/products/banner_92.jpg')
insert into Image values (923,'../../Content/images/products/banner_92.jpg')
insert into Image values (931,'../../Content/images/products/banner_93.jpg')
insert into Image values (932,'../../Content/images/products/banner_93.jpg')
insert into Image values (933,'../../Content/images/products/banner_93.jpg')
insert into Image values (941,'../../Content/images/products/banner_94.jpg')
insert into Image values (942,'../../Content/images/products/banner_94.jpg')
insert into Image values (943,'../../Content/images/products/banner_94.jpg')
insert into Image values (951,'../../Content/images/products/banner_95.jpg')
insert into Image values (952,'../../Content/images/products/banner_95.jpg')
insert into Image values (953,'../../Content/images/products/banner_95.jpg')
insert into Image values (961,'../../Content/images/products/banner_96.jpg')
insert into Image values (962,'../../Content/images/products/banner_96.jpg')
insert into Image values (963,'../../Content/images/products/banner_96.jpg')
insert into Image values (971,'../../Content/images/products/banner_97.jpg')
insert into Image values (972,'../../Content/images/products/banner_97.jpg')
insert into Image values (973,'../../Content/images/products/banner_97.jpg')
insert into Image values (981,'../../Content/images/products/banner_98.jpg')
insert into Image values (982,'../../Content/images/products/banner_98.jpg')
insert into Image values (983,'../../Content/images/products/banner_98.jpg')
insert into Image values (991,'../../Content/images/products/banner_99.jpg')
insert into Image values (992,'../../Content/images/products/banner_99.jpg')
insert into Image values (993,'../../Content/images/products/banner_99.jpg')
insert into Image values (1001,'../../Content/images/products/banner_100.jpg')
insert into Image values (1002,'../../Content/images/products/banner_100.jpg')
insert into Image values (1003,'../../Content/images/products/banner_100.jpg')
sdfksdffksd
anh em them du lieu vao day nhe

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










