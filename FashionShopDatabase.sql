﻿use master

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
	describe nvarchar(max),
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

insert into Color values (6, 'blue', 'rgb(72 ,118 ,255 )')
insert into Color values (7, 'red', 'rgb(238, 44, 44)')

-- Size --
insert into Size values (1, 'S')
insert into Size values (2, 'M')
insert into Size values (3, 'L')
insert into Size values (4, 'XL')

--Size Shoe from id 5 to 13 --
insert into Size values (5, '35')
insert into Size values (6, '36')
insert into Size values (7, '37')
insert into Size values (8, '38')
insert into size values (9, '39')
insert into size values(10, '40')
insert into Size values(11, '41')
insert into Size values(12, '42')
insert into Size values(13, '43')
insert into Size values(14, '44')
insert into Size values(15, '45')

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
'260000', 'Goness', 'Có sẵn')
insert into Products values(6, 1, N'Chân váy thô zip dáng ngắn kèm thắt lưng bản to 757Quangiavaykemdai',
N'Chân váy kaki kèm đai hàng quảng châu. Đủ màu siêu hót đen nâu be trắng. Số đo là số đo NGANG, mọi người đừng nhân đôi mà hãy lấy số đo này ướm với quần áo đang mặc của mình nhé CAM KẾT VỚI KHÁCH HÀNG:. Sản phẩm giống với mô tả và hình ảnh đăng trên cửa hàng. Mang tới dịch vụ khách hàng tận tâm và nhiệt tình nhất, giúp quý khách có được trải nghiệm tốt nhất khi mua hàng. Giải quyết thắc mắc và vấn đề về sản phẩm (nếu có) cho khách hàng nhanh chóng và thỏa đáng',
'149000', 'QUI', 'Có sẵn')
insert into Products values(7, 1, N'Chân Váy Tennis Xếp Ly The Good/ Tennis Skirt',
N'Sản phẩm được dệt từ vải Polyester, Vicose và sợi Spandex. Dày dặn chất vải không xù, không dai. Ít nhăn, phẳng phiu, dễ là. Thoáng mát, dễ chịu cho ngày hè. Đường may vô cung tỉ mỉ.',
'327000', 'The Good', 'Có sẵn')
insert into Products values(8, 1, N'Chân váy chữ A SUNNNY dáng ngắn cạp cao trơn đen _A1',
N'Thành phần: chất liệu kaki/jean dày dặn co giãn nhẹ cực thoải mái. Nên giặt máy ở chế độ máy nhẹ nhàng hoặc giặt tay. GIÁ TẬN GỐC, MIỄN TRUNG GIAN, NÓI KHÔNG VỚI HÀNG KÉM CHẤT LƯỢNG. Chất lượng bền đẹp, luôn đặt uy tín lên hàng đầu.',
'149000', 'SUNNNY', 'Có sẵn')
insert into Products values(9, 1, N'Chân Váy Chữ A Dáng Xòe Vải PoLy Cạp Chun',
N'Điểm Nhấn: Chân Váy Chữ A Dáng Xòe Vải PoLy Siêu Xinh Có Lót Quần Bên Trong Cạp Chun Bản To 6cm mặc rất dễ chịu và thỏa mái. Chân Váy Chữ A Dáng Xòe Vải PoLy Siêu Xinh Có Lót Quần Bên Trong phù hợp mặc đi chơi, đi tiệc, du lịch.......',
'219000', 'PoLy', 'Có sẵn')
insert into Products values(10, 1, N'Chân váy tennis nữ L66 xếp ly to công sở cao cấp mặc tôn dáng V4',
N'Chân váy là một trong những items kinh điển trong tủ đồ của tất cả chị em phụ nữ. Thiếu đi chân váy là thiếu đi sự điệu đà nữ tính, thiếu đi một nét đặc trưng của con gái. Chân váy có nhiều loại, mỗi chiếc chân váy mang trong mình một nét đẹp riêng biệt không trộn lẫn.',
'412000', 'LYL', 'Có sẵn')

--Product shoe --

--Shoe id from 11 to 20 --
insert into Products values(11,2, N' Giày thể thao thời trang Adidas Continental','Tiếp tục trong bộ sưu tập những đôi giày đi học nam đi học nói chung và của thương hiệu Adidas nói riêng là đôi Adidas Continental. Vẻ ngoài vừa cổ điển người hiện đại, phần thân dài chạy được thiết kế cực kỳ tinh xảo, chất liệu da cao cấp cùng với với bộ đệm EVA giúp các bạn đi giày trở nên linh hoạt và thoải mái hơn. Nếu như so sánh Adidas Continental và Stan Smith hoặc SuperStar… thì đây là 3 đối thủ cân sức nhất. Tuy nhiên bạn hoàn toàn có thể để lựa chọn Một đôi Adidas Continental để diện cùng trang phục nhà trường mỗi khi đi học đó!',
'850000','AdiDas','Có sẵn')
insert into Products values(12,2, N' Giày thể thao thời trang Adidas Prophere','Giày Adidas Prophere từng là cái tên tên được săn đón nhiều nhất một trong năm 2018 và là một trong những cái tên hot nhất trong BST giày phù hợp với học sinh và sinh viên đi học. Adidas Prophere đã từng đốn tim bất kỳ thì các bạn trẻ nào nào nhờ độ “ngầu” và sự “năng động” của nó. Mang vẻ nam tính mạnh mẽ và những chiếc gai ở bộ đế cùng lưỡi gà ấn tương đã tạo cho đôi giày này nét độc đáo mà ít đôi giày nào có được. Trong bộ sưu tập những đôi sneaker cho người lùn thì Adidas Prophere giúp bạn nam và bạn nữ hack 1 phần chiều cao một cách “bí mật” mà không ai biết đó.',
'1800000','Adidas','Có sẵn')
insert into Products values(13,2, N'Giày đi bộ Adidas Stan Swith','Adidas Stan Smith là mẫu giày kinh điển của thương hiệu Adidas đình đám, đã xuất hiện hơn 45 năm trên thị trường nhưng Adidas Stan Smith vẫn luôn là một trong những mẫu giày sneaker được sử dụng phổ biến và mua nhiều hiện nay. Các mẫu Adidas Stan Smith đã liên tục đổi mới cả về chất lượng và thiết kế, mang đến dòng sản phẩm làm hài lòng mọi khách hàng.',
'1200000','Adidas','Có sẵn')
insert into Products values(14,2, N'Giày đi bộ ,phong cách Adidas Ultra Boost','Ngoài vẻ ưa nhìn cùng thiết kế hoàn hảo thì Adidas Ultra Boost còn thuyết phục và tạo ấn tượng với bạn ở mức độ hài lòng khi sử dụng. Với kiểu thiết kế mắt lưới thông thoáng, vừa tạo được độ đàn hồi vừa giải phóng năng lượng một cách dễ dàng giúp cho đôi chân bạn luôn khô và thoáng. Đôi giày là sự kết hợp hoàn hảo giữa hai công nghệ tiên tiến bậc nhất đó là công nghệ dệt Mesh và công nghệ đế Boost. Độ êm chân và đàn hồi của đế Boost giúp cho trọng lượng dồn lên đôi chân ở mỗi bước đi được giảm tải khá nhiều. Giúp bạn có thể hoạt động trong thời gian dài với hiệu suất tốt nhất mà không hề cảm thấy đau mỏi chân.Giá giày Adidas Ultra Boost có phần nhỉnh hơn so với 4 đôi giày đi học trên. Dao động từ 2.000.000 - 4.000.000 VNĐ tuỳ vào các phiên bản.',
'2000000','Adidas','Có sẵn')
insert into Products values(15,2, N'Giày thời trang phong cách Domba High Point','Một đôi giày rất hot được giới trẻ yêu thích chính là đôi Domba High Point đến từ thương hiệu Domba của đất nước Hàn Quốc. Đây là đôi giày mang phong cách thiết kế của đôi giày đình đám Alexander McQueen và đó cũng chính là lý do tại sao đôi giày Domba High Point này lại có sức hút lớn như vậy nhưng có già cực kỳ rẻ. Giày Domba High Point là mẫu giày sneaker được yêu thích của thương hiệu Domba. Mẫu giày được thiết kế với gam màu trắng làm tông chủ đạo tạo cảm giác thanh lịch. Phần upper được làm bằng da cao cấp mịn tạo cảm giác mềm mại, lớp đệm êm ái  giúp đôi chân dễ chịu suốt cả ngày. Đế ngoài bằng cao su có rãnh chống trượt tạo cảm giác linh hoạt khi di chuyển. Với kiểu dáng chunky hiện đại, giày Domba High Point sẽ là sự lựa chọn hoàn hảo cho phong cách của bạn. Giày Domba cao cấp với thiết kế full trắng, điểm nhấn là phần gót giày khác lạ với các màu sắc khác nhau như đen, màu bạc, màu cầu vồng, màu vàng, màu đỏ, màu xanh….Đặc biệt là đế giày cao đến 5cm giúp tôn dáng “ăn gian” chiều cao hiệu quả. Mức giá cho đôi giày Back To School này là khoảng 800.000 – 1.200.000 đ.',
'1200000','Domba','Có sẵn')
insert into Products values(16,2,N' Giày thể thao Fila Disruptor 2 Chunky','Nếu bạn là một fan của giày chunky thì sẽ không thể bỏ qua siêu phẩm sneaker Fila Disruptor 2, đây là mẫu giày được đánh giá là mạnh mẽ, cá tính với thiết kế “hầm hố”, bộ đế răng cưa táo bạo. Nếu bạn muốn một đôi giày năng động cho Back To School thì Fila là lựa chọn hàng đầu. Có một điều mà chúng ta không thể phủ nhận được đó là độ hot của những đôi Sneaker của thương hiệu Fila. Được thiết kế theo phong cách hầm hố nhưng vẫn tùy biến để phù hợp với dáng người Châu Á, đôi sneaker Fila “chất lừ” đã lên ngôi khiến cho bất kì ai cũng muốn sở hữu. Với phối màu full trắng, đôi sneaker Fila vừa thời thượng lại cực kỳ dễ phối đồ. Bạn có thể kết hợp nó với nhiều kiểu trang phục và biến hóa để có một outfit của riêng mình. Có thể nói Fila Disruptor 2 là mẫu giày bán chạy nhất của hãng. Đây còn được mệnh danh là đôi Sneaker của 2019 do Footwear News bình chọn. Fila Disruptor 2 đã nổi lên như một hiện tượng đình đám trong giới trẻ, chúng trẻ trung năng động, đặc biệt giá bán cũng rất hợp lý.',
'1200000','Fila','Có sẵn')
insert into Products values(17,2,N'Giày thời trang MLB Big Ball Chunky','Top những đôi sneaker đáng được sở hữu nhất trong mùa Back To School chính là MLB Big Ball Chunky “hầm hố” đã thành cơn sốt và trở nên thịnh hành. Điểm nhấn khác biệt Logo trên thân giày là tên viết tắt của những đội bóng chày đình đám New York Yankees, Los Angeles Dodgers, Boston Red Sox … Giày với thiết kế quá khổ, phần đế cao giúp tôn dáng mang đến sự trẻ trung, cá tính và sành điệu. Không chỉ giúp bạn khẳng định cá tính riêng mà giày sneaker MLB còn đáp ứng tuyệt đối yêu cầu chất lượng, giá bán hiện tại khoảng 2,000,000 – 3,000,000 đ.',
'2500000','MLB','Có sẵn')
insert into Products values(18,2,N'Giày thể thao phong cách Nike Air Force 1','Hãng giày Nike cũng là một trong những lựa chọn hàng đầu trong ngày Back To School, đặc biệt là dòng Nike Air Force 1. Được áp dụng công nghệ hiện đại đế Air kết hợp với chất liệu da cao cấp khiến Air Force 1 đáp ứng đủ mọi tiêu chí của người dùng. Tông màu trắng cực dễ phối đồ, phù hợp với mọi outfit cũng chính là điều làm cho Air Force 1 là cái tên luôn nằm trong danh sách giày “Must Have-Item”. Hiện nay các mẫu giày Nike Air Force 1 đã được phối với nhiều màu sắc đa dạng, các bạn có thể dễ dàng chọn được kiểu phù hợp với sở thích và phong cách của mình. Giày Nike Air Force 1 chính hãng có giá dao động khoảng từ 1.800.000 – 2.500.000 đ.',
'1800000','Nike','Có sẵn')
insert into Products values(19,2,N'Giày thời trang phong cách Nike Air Jordan 1','Giày Nike Air Jordan 1 low phù hợp với các bạn học sinh vào mọi mùa trong năm thậm chí vào những ngày hè nắng nóng mùa thu se lạnh hay mùa đông rét buốt. Phong cách phối đồ với giày Jordan này sẽ phù hợp hơn với chiếc quần jean và áo đồng phục trắng ra trường. Nike Air Jordan 1 High sẽ phù hợp hơn với những bạn cá tính. Để diện đôi giày đi học bạn nên lựa chọn một đôi màu màu trắng hoặc đen bởi tông màu này sẽ phù hợp hơn ở độ tuổi học sinh.',
'750000','Nike','Có sẵn')
insert into Products values(20,2,N'Giày thời trang Puama Suede','Puma Suede là cái tên không thể thiếu nếu bạn là một fan của hãng giày Puma. Nếu người anh em là Adidas sở hữu những đôi Superstar, Stan Smith,… huyền thoại. Thì Puma cũng tự hào vô cùng khi cho ra đời cái tên Puma Suede. Tuy không có độ hype như những đôi Jordan, nhưng nếu bạn là người thích theo phong cách thời trang những năm 70 tại Mỹ, thì Puma Suede là lựa chọn hàng đầu cho các Rapper hay B-boy ở đây. Với thiết kế da lộn đặc trưng, màu sắc đơn giản, form giày thon gọn và phần cao su êm ai nằm trong đế chính đã đem lại cho Puma một người thu khổng lồ, đưa Puma trở thành một thế lực trong ngành công nghiệp Sneaker thế giới. Giá của Puma Suede rơi vào khoảng từ 1 triệu 600 đến 2 triệu. Một mức giá cực kì phù hợp cho đôi giày mà bạn mang hằng ngày.',
'1800000','Puma','Có sẵn')


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


-- Product_Quantity shoe --

insert into Product_Quantity values (11, 5, 2, 130)
insert into Product_Quantity values (11, 6, 2, 140)
insert into Product_Quantity values (11, 7, 2, 121)
insert into Product_Quantity values (11, 8, 2, 110)
insert into Product_Quantity values (11, 9, 2, 98)
insert into Product_Quantity values (11, 10, 2, 114)
insert into Product_Quantity values (11, 11,2, 96)
insert into Product_Quantity values (11, 12, 2, 220)
insert into Product_Quantity values (11, 13, 2, 168)
insert into Product_Quantity values (11, 14,2, 88)
insert into Product_Quantity values (11, 15, 2, 65)

insert into Product_Quantity values (11, 5, 1, 178)
insert into Product_Quantity values (11, 6, 1, 289)
insert into Product_Quantity values (11, 7, 1, 231)
insert into Product_Quantity values (11, 8, 1, 182)
insert into Product_Quantity values (11, 9, 1, 298)
insert into Product_Quantity values (11, 10, 1, 219)
insert into Product_Quantity values (11, 11, 1, 243)
insert into Product_Quantity values (11, 12, 1, 143)
insert into Product_Quantity values (11, 13, 1, 209)
insert into Product_Quantity values (11, 14, 1, 159)
insert into Product_Quantity values (11, 15, 1, 216)

insert into Product_Quantity values (11, 5, 5, 185)
insert into Product_Quantity values (11, 6, 5, 137)
insert into Product_Quantity values (11, 7, 5, 213)
insert into Product_Quantity values (11, 8, 5, 250)
insert into Product_Quantity values (11, 9, 5, 273)
insert into Product_Quantity values (11, 10, 5, 128)
insert into Product_Quantity values (11, 11, 5, 111)
insert into Product_Quantity values (11, 12, 5, 248)
insert into Product_Quantity values (11, 13, 5, 266)
insert into Product_Quantity values (11, 14, 5, 176)
insert into Product_Quantity values (11, 15, 5, 118)



insert into Product_Quantity values (12, 5, 2, 150)
insert into Product_Quantity values (12, 6, 2, 160)
insert into Product_Quantity values (12, 7, 2, 157)
insert into Product_Quantity values (12, 8, 2, 90)
insert into Product_Quantity values (12, 9, 2, 158)
insert into Product_Quantity values (12, 10, 2, 144)
insert into Product_Quantity values (12, 11,2, 124)
insert into Product_Quantity values (12, 12, 2, 230)
insert into Product_Quantity values (12, 13, 2, 158)
insert into Product_Quantity values (12, 14,2, 118)
insert into Product_Quantity values (12, 15, 2, 125)

insert into Product_Quantity values (12, 5, 5, 185)
insert into Product_Quantity values (12, 6, 5, 137)
insert into Product_Quantity values (12, 7, 5, 213)
insert into Product_Quantity values (12, 8, 5, 250)
insert into Product_Quantity values (12, 9, 5, 273)
insert into Product_Quantity values (12, 10, 5, 128)
insert into Product_Quantity values (12, 11, 5, 111)
insert into Product_Quantity values (12, 12, 5, 248)
insert into Product_Quantity values (12, 13, 5, 266)
insert into Product_Quantity values (12, 14, 5, 176)
insert into Product_Quantity values (12, 15, 5, 118)





insert into Product_Quantity values (13, 5, 2, 170)
insert into Product_Quantity values (13, 6, 2, 100)
insert into Product_Quantity values (13, 7, 2, 91)
insert into Product_Quantity values (13, 8, 2, 240)
insert into Product_Quantity values (13, 9, 2, 210)
insert into Product_Quantity values (13, 10, 2, 224)
insert into Product_Quantity values (13, 11,2, 125)
insert into Product_Quantity values (13, 12, 2, 210)
insert into Product_Quantity values (13, 13, 2, 148)
insert into Product_Quantity values (13, 14,2, 98)
insert into Product_Quantity values (13, 15, 2, 115)


insert into Product_Quantity values (13, 5, 5, 185)
insert into Product_Quantity values (13, 6, 5, 137)
insert into Product_Quantity values (13, 7, 5, 213)
insert into Product_Quantity values (13, 8, 5, 250)
insert into Product_Quantity values (13, 9, 5, 273)
insert into Product_Quantity values (13, 10, 5, 128)
insert into Product_Quantity values (13, 11, 5, 111)
insert into Product_Quantity values (13, 12, 5, 248)
insert into Product_Quantity values (13, 13, 5, 266)
insert into Product_Quantity values (13, 14, 5, 176)
insert into Product_Quantity values (13, 15, 5, 118)

insert into Product_Quantity values (14, 5, 2, 97)
insert into Product_Quantity values (14, 6, 2, 164)
insert into Product_Quantity values (14, 7, 2, 121)
insert into Product_Quantity values (14, 8, 2, 153)
insert into Product_Quantity values (14, 9, 2, 198)
insert into Product_Quantity values (14, 10, 2, 124)
insert into Product_Quantity values (14, 11,2, 196)
insert into Product_Quantity values (14, 12, 2, 240)
insert into Product_Quantity values (14, 13, 2, 168)
insert into Product_Quantity values (14, 14,2, 188)
insert into Product_Quantity values (14, 15, 2, 165)

insert into Product_Quantity values (15, 5, 2, 190)
insert into Product_Quantity values (15, 6, 2, 100)
insert into Product_Quantity values (15, 7, 2, 131)
insert into Product_Quantity values (15, 8, 2, 210)
insert into Product_Quantity values (15, 9, 2, 288)
insert into Product_Quantity values (15, 10, 2, 214)
insert into Product_Quantity values (15, 11,2, 136)
insert into Product_Quantity values (15, 12, 2, 210)
insert into Product_Quantity values (15, 13, 2, 148)
insert into Product_Quantity values (15, 14,2, 192)
insert into Product_Quantity values (15, 15, 2, 115)

insert into Product_Quantity values (16, 5, 2, 160)
insert into Product_Quantity values (16, 6, 2, 116)
insert into Product_Quantity values (16, 7, 2, 151)
insert into Product_Quantity values (16, 8, 2, 116)
insert into Product_Quantity values (16, 9, 2, 298)
insert into Product_Quantity values (16, 10, 2, 154)
insert into Product_Quantity values (16, 11,2, 96)
insert into Product_Quantity values (16, 12, 2, 220)
insert into Product_Quantity values (16, 13, 2, 168)
insert into Product_Quantity values (16, 14,2, 88)
insert into Product_Quantity values (16, 15, 2, 165)


insert into Product_Quantity values (17, 5, 2, 170)
insert into Product_Quantity values (17, 6, 2, 117)
insert into Product_Quantity values (17, 7, 2, 171)
insert into Product_Quantity values (17, 8, 2, 116)
insert into Product_Quantity values (17, 9, 2, 278)
insert into Product_Quantity values (17, 10, 2, 174)
insert into Product_Quantity values (17, 11,2, 196)
insert into Product_Quantity values (17, 12, 2, 120)
insert into Product_Quantity values (17, 13, 2, 148)
insert into Product_Quantity values (17, 14,2, 99)
insert into Product_Quantity values (17, 15, 2, 105)


insert into Product_Quantity values (18, 5, 1, 181)
insert into Product_Quantity values (18, 6, 1, 157)
insert into Product_Quantity values (18, 7, 1, 243)
insert into Product_Quantity values (18, 8, 1, 248)
insert into Product_Quantity values (18, 9, 1, 241)
insert into Product_Quantity values (18, 10, 1, 167)
insert into Product_Quantity values (18, 11, 1, 179)
insert into Product_Quantity values (18, 12, 1, 145)
insert into Product_Quantity values (18, 13, 1, 205)
insert into Product_Quantity values (18, 14, 1, 143)
insert into Product_Quantity values (18, 15, 1, 105)

insert into Product_Quantity values (18, 5, 2, 225)
insert into Product_Quantity values (18, 6, 2, 227)
insert into Product_Quantity values (18, 7, 2, 121)
insert into Product_Quantity values (18, 8, 2, 160)
insert into Product_Quantity values (18, 9, 2, 124)
insert into Product_Quantity values (18, 10, 2, 135)
insert into Product_Quantity values (18, 11, 2, 217)
insert into Product_Quantity values (18, 12, 2, 90)
insert into Product_Quantity values (18, 13, 2, 123)
insert into Product_Quantity values (18, 14, 2, 179)
insert into Product_Quantity values (18, 15, 2, 150)


insert into Product_Quantity values (18, 5, 5, 180)
insert into Product_Quantity values (18, 6, 5, 271)
insert into Product_Quantity values (18, 7, 5, 245)
insert into Product_Quantity values (18, 8, 5, 185)
insert into Product_Quantity values (18, 9, 5, 271)
insert into Product_Quantity values (18, 10, 5, 112)
insert into Product_Quantity values (18, 11, 5, 143)
insert into Product_Quantity values (18, 12, 5, 131)
insert into Product_Quantity values (18, 13, 5, 170)
insert into Product_Quantity values (18, 14, 5, 194)
insert into Product_Quantity values (18, 15, 5, 144)



insert into Product_Quantity values (19, 5, 2, 100)
insert into Product_Quantity values (19, 6, 2, 213)
insert into Product_Quantity values (19, 7, 2, 138)
insert into Product_Quantity values (19, 8, 2, 262)
insert into Product_Quantity values (19, 9, 2, 217)
insert into Product_Quantity values (19, 10, 2, 196)
insert into Product_Quantity values (19, 11, 2, 170)
insert into Product_Quantity values (19, 12, 2, 280)
insert into Product_Quantity values (19, 13, 2, 265)
insert into Product_Quantity values (19, 14, 2, 250)
insert into Product_Quantity values (19, 15, 2, 134)


insert into Product_Quantity values (19, 5, 5, 180)
insert into Product_Quantity values (19, 6, 5, 271)
insert into Product_Quantity values (19, 7, 5, 245)
insert into Product_Quantity values (19, 8, 5, 185)
insert into Product_Quantity values (19, 9, 5, 271)
insert into Product_Quantity values (19, 10, 5, 112)
insert into Product_Quantity values (19, 11, 5, 143)
insert into Product_Quantity values (19, 12, 5, 131)
insert into Product_Quantity values (19, 13, 5, 170)
insert into Product_Quantity values (19, 14, 5, 194)
insert into Product_Quantity values (19, 15, 5, 144)

insert into Product_Quantity values (19, 5, 6, 179)
insert into Product_Quantity values (19, 6, 6, 178)
insert into Product_Quantity values (19, 7, 6, 101)
insert into Product_Quantity values (19, 8, 6, 204)
insert into Product_Quantity values (19, 9, 6, 279)
insert into Product_Quantity values (19, 10, 6, 202)
insert into Product_Quantity values (19, 11, 6, 222)
insert into Product_Quantity values (19, 12, 6, 211)
insert into Product_Quantity values (19, 13, 6, 141)
insert into Product_Quantity values (19, 14, 6, 220)
insert into Product_Quantity values (19, 15, 6, 179)


insert into Product_Quantity values (20, 5, 2, 150)
insert into Product_Quantity values (20, 6, 2, 213)
insert into Product_Quantity values (20, 7, 2, 139)
insert into Product_Quantity values (20, 8, 2, 263)
insert into Product_Quantity values (20, 9, 2, 218)
insert into Product_Quantity values (20, 10, 2, 196)
insert into Product_Quantity values (20, 11, 2, 170)
insert into Product_Quantity values (20, 12, 2, 280)
insert into Product_Quantity values (20, 13, 2, 266)
insert into Product_Quantity values (20, 14, 2, 250)
insert into Product_Quantity values (20, 15, 2, 135)


insert into Product_Quantity values (12, 5, 1, 188)
insert into Product_Quantity values (13, 5, 1, 221)
insert into Product_Quantity values (14, 5, 1, 166)
insert into Product_Quantity values (15, 5, 1, 111)
insert into Product_Quantity values (16, 5, 1, 100)
insert into Product_Quantity values (17, 5, 1, 251)
insert into Product_Quantity values (12, 6, 1, 179)
insert into Product_Quantity values (13, 6, 1, 174)
insert into Product_Quantity values (14, 6, 1, 200)
insert into Product_Quantity values (15, 6, 1, 121)
insert into Product_Quantity values (16, 6, 1, 163)
insert into Product_Quantity values (17, 6, 1, 115)
insert into Product_Quantity values (12, 7, 1, 242)
insert into Product_Quantity values (13, 7, 1, 161)
insert into Product_Quantity values (14, 7, 1, 265)
insert into Product_Quantity values (15, 7, 1, 216)
insert into Product_Quantity values (16, 7, 1, 127)
insert into Product_Quantity values (17, 7, 1, 141)
insert into Product_Quantity values (12, 8, 1, 226)
insert into Product_Quantity values (13, 8, 1, 171)
insert into Product_Quantity values (14, 8, 1, 299)
insert into Product_Quantity values (15, 8, 1, 234)
insert into Product_Quantity values (16, 8, 1, 150)
insert into Product_Quantity values (17, 8, 1, 120)
insert into Product_Quantity values (12, 9, 1, 101)
insert into Product_Quantity values (13, 9, 1, 234)
insert into Product_Quantity values (14, 9, 1, 252)
insert into Product_Quantity values (15, 9, 1, 120)
insert into Product_Quantity values (16, 9, 1, 160)
insert into Product_Quantity values (17, 9, 1, 168)
insert into Product_Quantity values (12, 10, 1, 260)
insert into Product_Quantity values (13, 10, 1, 260)
insert into Product_Quantity values (14, 10, 1, 287)
insert into Product_Quantity values (15, 10, 1, 285)
insert into Product_Quantity values (16, 10, 1, 268)
insert into Product_Quantity values (17, 10, 1, 231)
insert into Product_Quantity values (12, 11, 1, 161)
insert into Product_Quantity values (13, 11, 1, 140)
insert into Product_Quantity values (14, 11, 1, 106)
insert into Product_Quantity values (15, 11, 1, 154)
insert into Product_Quantity values (16, 11, 1, 116)
insert into Product_Quantity values (17, 11, 1, 183)
insert into Product_Quantity values (12, 12, 1, 211)
insert into Product_Quantity values (13, 12, 1, 277)
insert into Product_Quantity values (14, 12, 1, 242)
insert into Product_Quantity values (15, 12, 1, 142)
insert into Product_Quantity values (16, 12, 1, 283)
insert into Product_Quantity values (17, 12, 1, 121)
insert into Product_Quantity values (12, 13, 1, 166)
insert into Product_Quantity values (13, 13, 1, 228)
insert into Product_Quantity values (14, 13, 1, 117)
insert into Product_Quantity values (15, 13, 1, 146)
insert into Product_Quantity values (16, 13, 1, 122)
insert into Product_Quantity values (17, 13, 1, 248)
insert into Product_Quantity values (12, 14, 1, 268)
insert into Product_Quantity values (13, 14, 1, 245)
insert into Product_Quantity values (14, 14, 1, 243)
insert into Product_Quantity values (15, 14, 1, 250)
insert into Product_Quantity values (16, 14, 1, 152)
insert into Product_Quantity values (17, 14, 1, 176)
insert into Product_Quantity values (12, 15, 1, 110)
insert into Product_Quantity values (13, 15, 1, 195)
insert into Product_Quantity values (14, 15, 1, 261)
insert into Product_Quantity values (15, 15, 1, 263)
insert into Product_Quantity values (16, 15, 1, 299)
insert into Product_Quantity values (17, 15, 1, 264)

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



insert into Image values (41,'../../Content/images/products/pd11.1.jpg')
insert into Image values (42,'../../Content/images/products/pd11.2.jpg')
insert into Image values (43,'../../Content/images/products/pd11.3.jpg')
insert into Image values (44,'../../Content/images/products/pd11.4.jpg')
insert into Image values (45,'../../Content/images/products/pd11.5.jpg')
insert into Image values (46,'../../Content/images/products/pd12.1.jpg')
insert into Image values (47,'../../Content/images/products/pd12.2.jpg')
insert into Image values (48,'../../Content/images/products/pd12.3.jpg')
insert into Image values (49,'../../Content/images/products/pd12.4.jpg')
insert into Image values (50,'../../Content/images/products/pd12.5.jpg')
insert into Image values (51,'../../Content/images/products/pd13.1.jpg')
insert into Image values (52,'../../Content/images/products/pd13.2.jpg')
insert into Image values (53,'../../Content/images/products/pd13.3.jpg')
insert into Image values (54,'../../Content/images/products/pd13.4.jpg')
insert into Image values (55,'../../Content/images/products/pd13.5.jpg')
insert into Image values (56,'../../Content/images/products/pd14.1.jpg')
insert into Image values (57,'../../Content/images/products/pd14.2.jpg')
insert into Image values (58,'../../Content/images/products/pd14.3.jpg')
insert into Image values (59,'../../Content/images/products/pd14.4.jpg')
insert into Image values (60,'../../Content/images/products/pd14.5.jpg')
insert into Image values (61,'../../Content/images/products/pd15.1.jpg')
insert into Image values (62,'../../Content/images/products/pd15.2.jpg')
insert into Image values (63,'../../Content/images/products/pd15.3.jpg')
insert into Image values (64,'../../Content/images/products/pd15.4.jpg')
insert into Image values (65,'../../Content/images/products/pd15.5.jpg')
insert into Image values (66,'../../Content/images/products/pd16.1.jpg')
insert into Image values (67,'../../Content/images/products/pd16.2.jpg')
insert into Image values (68,'../../Content/images/products/pd16.3.jpg')
insert into Image values (69,'../../Content/images/products/pd16.4.jpg')
insert into Image values (70,'../../Content/images/products/pd16.5.jpg')
insert into Image values (71,'../../Content/images/products/pd17.1.jpg')
insert into Image values (72,'../../Content/images/products/pd17.2.jpg')
insert into Image values (73,'../../Content/images/products/pd17.3.jpg')
insert into Image values (74,'../../Content/images/products/pd17.4.jpg')
insert into Image values (75,'../../Content/images/products/pd17.5.jpg')
insert into Image values (76,'../../Content/images/products/pd18.1.jpg')
insert into Image values (77,'../../Content/images/products/pd18.2.jpg')
insert into Image values (78,'../../Content/images/products/pd18.3.jpg')
insert into Image values (79,'../../Content/images/products/pd18.4.jpg')
insert into Image values (80,'../../Content/images/products/pd18.5.jpg')
insert into Image values (81,'../../Content/images/products/pd19.1.jpg')
insert into Image values (82,'../../Content/images/products/pd19.2.jpg')
insert into Image values (83,'../../Content/images/products/pd19.3.jpg')
insert into Image values (84,'../../Content/images/products/pd19.4.jpg')
insert into Image values (85,'../../Content/images/products/pd19.5.jpg')
insert into Image values (86,'../../Content/images/products/pd20.1.jpg')
insert into Image values (87,'../../Content/images/products/pd20.2.jpg')
insert into Image values (88,'../../Content/images/products/pd20.3.jpg')
insert into Image values (89,'../../Content/images/products/pd20.4.jpg')
insert into Image values (90,'../../Content/images/products/pd20.5.jpg')


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


insert into Product_Image values (11, 41)
insert into Product_Image values (11, 42)
insert into Product_Image values (11, 43)
insert into Product_Image values (11, 44)
insert into Product_Image values (11, 45)
insert into Product_Image values (12, 46)
insert into Product_Image values (12, 47)
insert into Product_Image values (12, 48)
insert into Product_Image values (12, 49)
insert into Product_Image values (12, 50)
insert into Product_Image values (13, 51)
insert into Product_Image values (13, 52)
insert into Product_Image values (13, 53)
insert into Product_Image values (13, 54)
insert into Product_Image values (13, 55)
insert into Product_Image values (14, 56)
insert into Product_Image values (14, 57)
insert into Product_Image values (14, 58)
insert into Product_Image values (14, 59)
insert into Product_Image values (14, 60)
insert into Product_Image values (15, 61)
insert into Product_Image values (15, 62)
insert into Product_Image values (15, 63)
insert into Product_Image values (15, 64)
insert into Product_Image values (15, 65)
insert into Product_Image values (16, 66)
insert into Product_Image values (16, 67)
insert into Product_Image values (16, 68)
insert into Product_Image values (16, 69)
insert into Product_Image values (16, 70)
insert into Product_Image values (17, 71)
insert into Product_Image values (17, 72)
insert into Product_Image values (17, 73)
insert into Product_Image values (17, 74)
insert into Product_Image values (17, 75)
insert into Product_Image values (18, 76)
insert into Product_Image values (18, 77)
insert into Product_Image values (18, 78)
insert into Product_Image values (18, 79)
insert into Product_Image values (18, 80)
insert into Product_Image values (19, 81)
insert into Product_Image values (19, 82)
insert into Product_Image values (19, 83)
insert into Product_Image values (19, 84)
insert into Product_Image values (19, 85)
insert into Product_Image values (20, 86)
insert into Product_Image values (20, 87)
insert into Product_Image values (20, 88)
insert into Product_Image values (20, 89)
insert into Product_Image values (20, 90)

-- Tag --
insert into Tag values (1, N'Áo Hàn Quốc')
insert into Tag values (2, N'Áo khoác')
insert into Tag values (3, 'Hoodie')
insert into Tag values (4, N'Áo Unisex')
insert into Tag values (5, N'Váy ngắn')
insert into Tag values (6, N'Váy chữ A')
insert into Tag values (7, N'Váy Hàn Quốc')
insert into Tag values (8, N'Váy Tennis')


insert into Tag values (9, N'Giày thể thao ')
insert into Tag values (10, N'Giày thời trang')
insert into Tag values (11, N'Giày đi bộ')
insert into Tag values (12, N'Giày phong cách')


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



insert into Product_Tag values (11, 9)
insert into Product_Tag values (12, 9)
insert into Product_Tag values (13, 11)
insert into Product_Tag values (14,11)
insert into Product_Tag values (15, 10)
insert into Product_Tag values (16, 9)
insert into Product_Tag values (17, 10)
insert into Product_Tag values (18, 9)
insert into Product_Tag values (19, 10)
insert into Product_Tag values (20, 10)
insert into Product_Tag values (11, 10)
insert into Product_Tag values (12,10)
insert into Product_Tag values (19, 12)
insert into Product_Tag values (15, 12)
insert into Product_Tag values (14,12)
insert into Product_Tag values (18, 12)

-- Category --
-- (id, id_parent, name)
-- id_parent = 0 neu loai tong the nhat
insert into Category values (1, 0, N'Áo')
insert into Category values (2, 1, N'Áo khoác')
insert into Category values (3, 2, 'Hoodie')
insert into Category values (4, 0, N'Váy')
insert into Category values (5, 4, N'Váy ngắn')

insert into Category values (6, 0, N'Giày')
insert into Category values (7, 2, N'Giày thể thao thời trang')
insert into Category values (8, 4, N'phong cách')

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



insert into Product_Category values (11, 6)
insert into Product_Category values (12, 6)
insert into Product_Category values (13, 6)
insert into Product_Category values (14,6)
insert into Product_Category values (15, 6)
insert into Product_Category values (16,6)
insert into Product_Category values (17, 6)
insert into Product_Category values (18, 6)
insert into Product_Category values (19, 6)
insert into Product_Category values (20, 6)
insert into Product_Category values (11, 7)
insert into Product_Category values (12,7)
insert into Product_Category values (19, 8)
insert into Product_Category values (15, 8)
insert into Product_Category values (14,8)
insert into Product_Category values (18, 8)

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








