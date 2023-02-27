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
	name nvarchar(250) not null,
	describe nvarchar(500),
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
insert into Color values (3, 'pink', 'rgb(247, 200, 224)')
insert into Color values (4, 'purple', 'rgb(134, 93, 255)')
insert into Color values (5, 'brown', 'rgb(211, 117, 107)')



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
-- (id, user_id, name, describe, price, brand, product_availability)
insert into Products values (1, 1, N'Chân váy tennis xếp ly', 
N'CHÂN VÁY TENNIS KẺ CARO KIỂU CHÂN VÁY XOÈ XẾP LY CÓ LÓT TRONG CẠP LƯNG CAO MẶC ĐI CHƠI HỌC LÀM TẬP THỂ THAO ĐẸP
Mẫu chân váy xếp ly không bao giờ lỗi mốt đây ạ. Diện em chất váy tennis caro này thoải mái vận động các nàng nhé, em nó có lót trong nên không sợ lộ hàng đâu ạ. Với những đường xếp ly đều đặn, chất thun co giãn mang tới cảm giác thoải mái mà vẫn cực kỳ trẻ trung năng động.',
'150000', 'MIDI', 'Có sẵn')
insert into Products values (2, 1, N'Xiaozhainv Váy denim Ngắn Lưng Cao Thời Trang Mùa Hè Dành Cho Nữ',
N'Gói hàng bao gồm: 1 * Chân váy. Vì hiệu ứng hiển thị và ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể hơi khác so với màu sắc trong hình. Nếu sản phẩm của chúng tôi không có kích thước hay màu sắc yêu thích của bạn, hoặc bạn muốn tìm hiểu thêm thông tin, vui lòng liên hệ với chúng tôi.
Tất cả các sản phẩm đều được gửi về từ nước ngoài, chất lượng siêu tốt với mức giá rẻ, các bạn thấy thích thì đừng quên chia sẻ cho bạn bè mình nha',
'310000', 'RETRO', 'Có sẵn')
insert into Products values(3, 1, N'Chân váy ngắn xếp ly hai lớp phong cách CHERRY chân váy tennis xòe kiểu xếp li âu mỹ V048',
N'Chân váy xếp ly chữ a phong cách ulzang chất liệu vitex cao cấp mang lại cảm giác thoải mái khi mặc. Chân váy tennis Cherry tuy là chân váy ngắn nhưng thiết kế chiều dài 40cm nên ko quá ngắn xị em có thể tự tin mặc ko lo lộ hàng nhé. Chân váy xếp ly ngắn chữ a thiết kế theo phong cách chân váy xòe nên cực kì dễ mix đồ, mùa hè mix với sơ mi, áo thun, mùa đông mix với ghi lê bao xinh',
'145000', 'CHERRY', 'Có sẵn')
insert into Products values(4, 1, N'Chân Váy KaKi Chữ A Túi Hộp Phong Cách Hàn Quốc Có Quần Trong Lên From Xinh',
N'THÔNG TIN SẢN PHẨM:Chân Váy KaKi Chữ A Túi Hộp được thiết kế thân trước cúc cài kéo khóa, có túi hộp 2 bên tạo điểm nhấn độcc và lạ mắt. Chất vải kaki thô mềm mại, co giãn mặc vô cùng thoải mái. Chân Váy KaKi Chữ A Túi Hộp Mix cùng với áo sơ mi, phông, 2 dây, crotop.... đều xinh ạ. Các quý cô dạo phố, shopping, cafe, đi làm công sở đều xinh hết nấc nha. Thật sự chị em nào bỏ qua chiếc Chân Váy KaKi Chữ A Túi Hộp này là tiếc lắm luôn ấy.',
'170000', 'RYU', 'Có sẵn')
insert into Products values(5, 1, N'Chân váy xếp ly Goness cạp cao dáng chữ a phong cách tennis xòe kiểu li ngắn bản to thời trang Hàn Quốc',
N'THÔNG TIN SẢN PHẨM CHÂN VÁY NGẮN XẾP LY GONESS: Chân váy xếp ly hay còn gọi là váy tennis là mặt hàng thời trang phổ biến nhất hiện nay. Lợi ích của dòng Chân váy xếp ly này là dễ phối đồ, dễ mặc, năng động, trẻ trung .Chất vintex dày, mịn, thấm mút mồ hôi tốt, không xù lông, mềm mại cho làn da, cầm mát tay. Chân váy có thể mặc đi chơi, đi làm,..',
'260000', 'Goness ', 'Có sẵn')
insert into Products values(6, 1, N'Chân váy thô zip dáng ngắn kèm thắt lưng bản to 757Quangiavaykemdai',
N'Chân váy kaki kèm đai hàng quảng châu. Đủ màu siêu hót đen nâu be trắng. Số đo là số đo NGANG, mọi người đừng nhân đôi mà hãy lấy số đo này ướm với quần áo đang mặc của mình nhé CAM KẾT VỚI KHÁCH HÀNG:. Sản phẩm giống với mô tả và hình ảnh đăng trên cửa hàng. Mang tới dịch vụ khách hàng tận tâm và nhiệt tình nhất, giúp quý khách có được trải nghiệm tốt nhất khi mua hàng. Giải quyết thắc mắc và vấn đề về sản phẩm (nếu có) cho khách hàng nhanh chóng và thỏa đáng',
'149000', 'QUI ', 'Có sẵn')
insert into Products values(7, 1, N'Chân Váy Tennis Xếp Ly The Good/ Tennis Skirt',
N'Sản phẩm được dệt từ vải Polyester, Vicose và sợi Spandex. Dày dặn chất vải không xù, không dai. Ít nhăn, phẳng phiu, dễ là. Thoáng mát, dễ chịu cho ngày hè. Đường may vô cung tỉ mỉ.',
'327000', 'The Good ', 'Có sẵn')
insert into Products values(8, 1, N'Chân váy chữ A SUNNNY dáng ngắn cạp cao trơn đen _A1',
N'Thành phần: chất liệu kaki/jean dày dặn co giãn nhẹ cực thoải mái. Nên giặt máy ở chế độ máy nhẹ nhàng hoặc giặt tay. GIÁ TẬN GỐC, MIỄN TRUNG GIAN, NÓI KHÔNG VỚI HÀNG KÉM CHẤT LƯỢNG. Chất lượng bền đẹp, luôn đặt uy tín lên hàng đầu.',
'149000', 'SUNNNY ', 'Có sẵn')
insert into Products values(9, 1, N'Chân Váy Chữ A Dáng Xòe Vải PoLy Cạp Chun',
N'Điểm Nhấn: Chân Váy Chữ A Dáng Xòe Vải PoLy Siêu Xinh Có Lót Quần Bên Trong Cạp Chun Bản To 6cm mặc rất dễ chịu và thỏa mái. Chân Váy Chữ A Dáng Xòe Vải PoLy Siêu Xinh Có Lót Quần Bên Trong phù hợp mặc đi chơi, đi tiệc, du lịch.......',
'219000', 'PoLy ', 'Có sẵn')
insert into Products values(10, 1, N'Chân váy tennis nữ L66 xếp ly to công sở cao cấp mặc tôn dáng V4',
N'Chân váy là một trong những items kinh điển trong tủ đồ của tất cả chị em phụ nữ. Thiếu đi chân váy là thiếu đi sự điệu đà nữ tính, thiếu đi một nét đặc trưng của con gái. Chân váy có nhiều loại, mỗi chiếc chân váy mang trong mình một nét đẹp riêng biệt không trộn lẫn.',
'412000', 'LYL ', 'Có sẵn')

-- Product_Quantity --
-- (product_id, size_id, color_id, quantity)
insert into Product_Quantity values (1, 1, 1, 141)
insert into Product_Quantity values (1, 1, 2, 185)
insert into Product_Quantity values (1, 2, 1, 172)
insert into Product_Quantity values (1, 2, 2, 138)
insert into Product_Quantity values (1, 3, 1, 180)
insert into Product_Quantity values (1, 3, 2, 169)
insert into Product_Quantity values (1, 4, 1, 165)
insert into Product_Quantity values (1, 4, 2, 168)
insert into Product_Quantity values (2, 1, 3, 141)
insert into Product_Quantity values (2, 1, 5, 259)
insert into Product_Quantity values (2, 2, 3, 265)
insert into Product_Quantity values (2, 2, 5, 133)
insert into Product_Quantity values (2, 3, 3, 165)
insert into Product_Quantity values (2, 3, 5, 103)
insert into Product_Quantity values (2, 4, 3, 235)
insert into Product_Quantity values (2, 4, 5, 205)
insert into Product_Quantity values (3, 1, 2, 141)
insert into Product_Quantity values (3, 1, 4, 143)
insert into Product_Quantity values (3, 2, 2, 162)
insert into Product_Quantity values (3, 2, 4, 140)
insert into Product_Quantity values (3, 3, 2, 159)
insert into Product_Quantity values (3, 3, 4, 144)
insert into Product_Quantity values (3, 4, 2, 112)
insert into Product_Quantity values (3, 4, 4, 156)
insert into Product_Quantity values (4, 1, 1, 141)
insert into Product_Quantity values (4, 1, 5, 192)
insert into Product_Quantity values (4, 2, 1, 134)
insert into Product_Quantity values (4, 2, 5, 140)
insert into Product_Quantity values (4, 3, 1, 159)
insert into Product_Quantity values (4, 3, 5, 179)
insert into Product_Quantity values (4, 4, 1, 133)
insert into Product_Quantity values (4, 4, 5, 163)
insert into Product_Quantity values (5, 1, 3, 141)
insert into Product_Quantity values (5, 1, 4, 105)
insert into Product_Quantity values (5, 2, 3, 110)
insert into Product_Quantity values (5, 2, 4, 182)
insert into Product_Quantity values (5, 3, 3, 195)
insert into Product_Quantity values (5, 3, 4, 116)
insert into Product_Quantity values (5, 4, 3, 154)
insert into Product_Quantity values (5, 4, 4, 184)
insert into Product_Quantity values (6, 1, 1, 141)
insert into Product_Quantity values (6, 1, 3, 199)
insert into Product_Quantity values (6, 2, 1, 162)
insert into Product_Quantity values (6, 2, 3, 168)
insert into Product_Quantity values (6, 3, 1, 117)
insert into Product_Quantity values (6, 3, 3, 144)
insert into Product_Quantity values (6, 4, 1, 154)
insert into Product_Quantity values (6, 4, 3, 114)
insert into Product_Quantity values (7, 1, 2, 141)
insert into Product_Quantity values (7, 1, 5, 148)
insert into Product_Quantity values (7, 2, 2, 106)
insert into Product_Quantity values (7, 2, 5, 158)
insert into Product_Quantity values (7, 3, 2, 172)
insert into Product_Quantity values (7, 3, 5, 117)
insert into Product_Quantity values (7, 4, 2, 165)
insert into Product_Quantity values (7, 4, 5, 191)
insert into Product_Quantity values (8, 1, 3, 141)
insert into Product_Quantity values (8, 1, 4, 167)
insert into Product_Quantity values (8, 2, 3, 109)
insert into Product_Quantity values (8, 2, 4, 150)
insert into Product_Quantity values (8, 3, 3, 179)
insert into Product_Quantity values (8, 3, 4, 184)
insert into Product_Quantity values (8, 4, 3, 193)
insert into Product_Quantity values (8, 4, 4, 133)
insert into Product_Quantity values (9, 1, 4, 141)
insert into Product_Quantity values (9, 1, 5, 198)
insert into Product_Quantity values (9, 2, 4, 116)
insert into Product_Quantity values (9, 2, 5, 158)
insert into Product_Quantity values (9, 3, 4, 198)
insert into Product_Quantity values (9, 3, 5, 146)
insert into Product_Quantity values (9, 4, 4, 112)
insert into Product_Quantity values (9, 4, 5, 208)
insert into Product_Quantity values (10, 1, 1, 141)
insert into Product_Quantity values (10, 1, 3, 123)
insert into Product_Quantity values (10, 2, 1, 170)
insert into Product_Quantity values (10, 2, 3, 152)
insert into Product_Quantity values (10, 3, 1, 129)
insert into Product_Quantity values (10, 3, 3, 164)
insert into Product_Quantity values (10, 4, 1, 210)
insert into Product_Quantity values (10, 4, 3, 110)

-- Image --
insert into Image values (1,'../../Content/images/products/pd1.1.jpg')
insert into Image values (2,'../../Content/images/products/pd1.2.jpg')
insert into Image values (3,'../../Content/images/products/pd1.3.jpg')
insert into Image values (4,'../../Content/images/products/pd1.4.jpg')
insert into Image values (5,'../../Content/images/products/pd2.1.jpg')
insert into Image values (6,'../../Content/images/products/pd2.2.jpg')
insert into Image values (7,'../../Content/images/products/pd2.3.jpg')
insert into Image values (8,'../../Content/images/products/pd2.4.jpg')
insert into Image values (9,'../../Content/images/products/pd3.1.jpg')
insert into Image values (10,'../../Content/images/products/pd3.2.jpg')
insert into Image values (11,'../../Content/images/products/pd3.3.jpg')
insert into Image values (12,'../../Content/images/products/pd3.4.jpg')
insert into Image values (13,'../../Content/images/products/pd4.1.jpg')
insert into Image values (14,'../../Content/images/products/pd4.2.jpg')
insert into Image values (15,'../../Content/images/products/pd4.3.jpg')
insert into Image values (16,'../../Content/images/products/pd4.4.jpg')
insert into Image values (17,'../../Content/images/products/pd5.1.jpg')
insert into Image values (18,'../../Content/images/products/pd5.2.jpg')
insert into Image values (19,'../../Content/images/products/pd5.3.jpg')
insert into Image values (20,'../../Content/images/products/pd5.4.jpg')
insert into Image values (21,'../../Content/images/products/pd6.1.jpg')
insert into Image values (22,'../../Content/images/products/pd6.2.jpg')
insert into Image values (23,'../../Content/images/products/pd6.3.jpg')
insert into Image values (24,'../../Content/images/products/pd6.4.jpg')
insert into Image values (25,'../../Content/images/products/pd7.1.jpg')
insert into Image values (26,'../../Content/images/products/pd7.2.jpg')
insert into Image values (27,'../../Content/images/products/pd7.3.jpg')
insert into Image values (28,'../../Content/images/products/pd7.4.jpg')
insert into Image values (29,'../../Content/images/products/pd8.1.jpg')
insert into Image values (30,'../../Content/images/products/pd8.2.jpg')
insert into Image values (31,'../../Content/images/products/pd8.3.jpg')
insert into Image values (32,'../../Content/images/products/pd8.4.jpg')
insert into Image values (33,'../../Content/images/products/pd9.1.jpg')
insert into Image values (34,'../../Content/images/products/pd9.2.jpg')
insert into Image values (35,'../../Content/images/products/pd9.3.jpg')
insert into Image values (36,'../../Content/images/products/pd9.4.jpg')
insert into Image values (37,'../../Content/images/products/pd10.1.jpg')
insert into Image values (38,'../../Content/images/products/pd10.2.jpg')
insert into Image values (39,'../../Content/images/products/pd10.3.jpg')
insert into Image values (40,'../../Content/images/products/pd10.4.jpg')

-- Product_Image --
insert into Product_Image values (1, 1)
insert into Product_Image values (1, 2)
insert into Product_Image values (1, 3)
insert into Product_Image values (1, 4)
insert into Product_Image values (2, 5)
insert into Product_Image values (2, 6)
insert into Product_Image values (2, 7)
insert into Product_Image values (2, 8)
insert into Product_Image values (3, 9)
insert into Product_Image values (3, 10)
insert into Product_Image values (3, 11)
insert into Product_Image values (3, 12)
insert into Product_Image values (4, 13)
insert into Product_Image values (4, 14)
insert into Product_Image values (4, 15)
insert into Product_Image values (4, 16)
insert into Product_Image values (5, 17)
insert into Product_Image values (5, 18)
insert into Product_Image values (5, 19)
insert into Product_Image values (5, 20)
insert into Product_Image values (6, 21)
insert into Product_Image values (6, 22)
insert into Product_Image values (6, 23)
insert into Product_Image values (6, 24)
insert into Product_Image values (7, 25)
insert into Product_Image values (7, 26)
insert into Product_Image values (7, 27)
insert into Product_Image values (7, 28)
insert into Product_Image values (8, 29)
insert into Product_Image values (8, 30)
insert into Product_Image values (8, 31)
insert into Product_Image values (8, 32)
insert into Product_Image values (9, 33)
insert into Product_Image values (9, 34)
insert into Product_Image values (9, 35)
insert into Product_Image values (9, 36)
insert into Product_Image values (10, 37)
insert into Product_Image values (10, 38)
insert into Product_Image values (10, 39)
insert into Product_Image values (10, 40)

-- Tag --
insert into Tag values (1, N'Áo Hàn Quốc')
insert into Tag values (2, N'Áo khoác')
insert into Tag values (3, 'Hoodie')
insert into Tag values (4, N'Áo Unisex')
insert into Tag values (5, N'Váy ngắn')
insert into Tag values (6, N'Váy chữ A')
insert into Tag values (7, N'Váy Hàn Quốc')
insert into Tag values (8, N'Váy Tennis')



-- Product_Tag --
-- (product_id, tag_id)
insert into Product_Tag values (1, 5)
insert into Product_Tag values (2, 5)
insert into Product_Tag values (3, 5)
insert into Product_Tag values (4, 5)
insert into Product_Tag values (5, 5)
insert into Product_Tag values (6, 5)
insert into Product_Tag values (7, 5)
insert into Product_Tag values (8, 5)
insert into Product_Tag values (9, 5)
insert into Product_Tag values (10, 5)
insert into Product_Tag values (4, 6)
insert into Product_Tag values (5, 6)
insert into Product_Tag values (8, 6)
insert into Product_Tag values (9, 6)
insert into Product_Tag values (4, 7)
insert into Product_Tag values (5, 7)
insert into Product_Tag values (1, 8)
insert into Product_Tag values (5, 8)
insert into Product_Tag values (7, 8)
insert into Product_Tag values (10, 8)

-- Category --
-- (id, id_parent, name)
-- id_parent = 0 neu loai tong the nhat
insert into Category values (1, 0, N'Áo')
insert into Category values (2, 1, N'Áo khoác')
insert into Category values (3, 2, 'Hoodie')
insert into Category values (4, 0, N'Váy')
insert into Category values (5, 4, N'Váy ngắn')


-- Product_Category --
-- (product_id, category_id)
insert into Product_Category values(1, 4)
insert into Product_Category values(1, 5)
insert into Product_Category values(2, 4)
insert into Product_Category values(2, 5)
insert into Product_Category values(3, 4)
insert into Product_Category values(3, 5)
insert into Product_Category values(4, 4)
insert into Product_Category values(4, 5)
insert into Product_Category values(5, 4)
insert into Product_Category values(5, 5)
insert into Product_Category values(6, 4)
insert into Product_Category values(6, 5)
insert into Product_Category values(7, 4)
insert into Product_Category values(7, 5)
insert into Product_Category values(8, 4)
insert into Product_Category values(8, 5)
insert into Product_Category values(9, 4)
insert into Product_Category values(9, 5)
insert into Product_Category values(10, 4)
insert into Product_Category values(10, 5)

-- Product_Reviewing --
insert into Product_Reviewing values(1, 1, 1, 5, N'Hàng đẹp chất lượng đúng mô tả, sẽ ủng hộ lần sau', '2023-02-12 14:56:59')

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










