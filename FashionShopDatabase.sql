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
	user_id BIGINT not null IDENTITY(1,1) primary key,
	firstName nvarchar(20),
	lastName nvarchar(20),
	phoneNumber nvarchar(10),
	email nvarchar(150),
	username varchar(20) not null,
	password varchar(300) not null,
	admin tinyint not null,
	address nvarchar(150),
	province nvarchar(30),
	city nvarchar(30),
	country nvarchar(30)
)

if exists(select name from sysobjects where name = 'Products')
	drop table Products
create table Products
(
	product_id bigint IDENTITY(1,1) primary key,
	user_id bigint,
	name nvarchar(250) not null,
	describe nvarchar(max),
	price float not null,
	brand nvarchar(50),
	product_availability nvarchar(40) not null check (product_availability IN('out_of_stock','available','reserve'))
)

if exists(select name from sysobjects where name = 'Product_Image')
	drop table Product_Image
create table Product_Image
(
	id bigint not null IDENTITY(1,1) PRIMARY KEY,
	product_id bigint,
	image_id bigint
)

if exists(select name from sysobjects where name = 'Image')
	drop table Image
create table Image
(
	image_id bigint not null IDENTITY(1,1) primary key,
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
	id bigint not null IDENTITY(1,1) PRIMARY KEY,
	product_id bigint,
	size_id bigint,
	color_id bigint,
	quantity int
)

if exists(select name from sysobjects where name = 'Product_Tag')
	drop table Product_Tag
create table Product_Tag
(
	id bigint not null IDENTITY(1,1) PRIMARY KEY,
	product_id bigint,
	tag_id bigint
)

if exists(select name from sysobjects where name = 'Tag')
	drop table Tag
create table Tag
(
	tag_id bigint not null primary key,
	tag_name nvarchar(30) not null
)

if exists(select name from sysobjects where name = 'Orders')
	drop table Orders
create table Orders
(
	order_id bigint not null primary key,
	customer_id bigint not null,
	order_date datetime not null,
	original_price float not null,
	reduced_price float,
	transport_fee float,
	total_price float not null,
	voucher_id bigint,
	order_status nvarchar(40) not null check(order_status IN('accepted', 'preparing', 'orderIsReady','processing','delivering','delivered'))
)

if exists(select name from sysobjects where name = 'Order_Item')
	drop table Order_Item
create table Order_Item
(
	id bigint not null IDENTITY(1,1) primary key,
	order_id bigint not null,
	product_id bigint not null,
	quantity smallint not null,
	size bigint not null,
	color bigint not null,
	total_price float not null
)

if exists(select name from sysobjects where name = 'Cart')
	drop table Cart
create table Cart
(
	cart_id bigint not null IDENTITY(1,1) primary key,
	user_id bigint not null,
	product_id bigint not null,
	quantity smallint not null,
	size bigint not null,
	color bigint not null,
	total_price float not null
)

if exists(select name from sysobjects where name = 'Product_Reviewing')
	drop table Product_Reviewing
create table Product_Reviewing
(
	id bigint not null primary key,
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
	category_id bigint not null primary key,
	parent_id bigint not null,
	name nvarchar(100) not null
)

if exists(select name from sysobjects where name = 'Product_Category')
	drop table Product_Category
create table Product_Category
(
	id bigint not null IDENTITY(1,1) PRIMARY KEY,
	product_id bigint not null,
	category_id bigint not null
)

if exists(select name from sysobjects where name = 'Voucher')
	drop table Voucher
create table Voucher
(
	voucher_id bigint not null primary key,
	user_id bigint not null,
	code varchar(20) not null,
	discount_percentage float not null,
	voucher_status nvarchar(40) not null check(voucher_status IN('available','used')),
	start_date datetime not null,
	end_date datetime not null
)

if exists(select name from sysobjects where name = 'Payment_Methods')
	drop table Payment_Methods
create table Payment_Methods
(
	id bigint not null primary key,
	name_methods nvarchar(100) not null
)

if exists(select name from sysobjects where name = 'Payment_Detail')
	drop table Payment_Detail
create table Payment_Detail
(
	id bigint not null primary key,
	order_id  bigint not null,
	amount float not null,
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
constraint FK_C_U FOREIGN KEY (user_id) REFERENCES Users(user_id),
constraint FK_C_S FOREIGN KEY (size) REFERENCES Size(size_id),
constraint FK_C_CC FOREIGN KEY (color) REFERENCES Color(color_id)


ALTER TABLE Order_Item
ADD
constraint FK_OI_O FOREIGN KEY (order_id) REFERENCES Orders(order_id),
constraint FK_OI_S FOREIGN KEY (size) REFERENCES Size(size_id),
constraint FK_OI_C FOREIGN KEY (color) REFERENCES Color(color_id),
constraint FK_OI_P FOREIGN KEY (product_id) REFERENCES Products(product_id)


use FashionShop

-- Color --
insert into Color values (1, 'black', 'rgb(0, 0, 0)')
insert into Color values (2, 'white', 'rgb(255, 255, 255)')
insert into Color values (3, 'pink', 'rgb(247, 200, 224)')
insert into Color values (4, 'purple', 'rgb(134, 93, 255)')
insert into Color values (5, 'brown', 'rgb(211, 117, 107)')
insert into Color values (6, 'blue', 'rgb(72 ,118 ,255 )')
insert into Color values (7, 'red', 'rgb(238, 44, 44)')
insert into Color values (8, 'gray', 'rgb (128,128,128)')
insert into Color values (9, 'light pink', 'rgb (255,182,193)')
insert into Color values (10, 'azure', 'rgb(0,0,255)')
insert into Color values (11, 'light green', 'rgb (152,251,152)')
insert into Color values (12, 'orange' , 'rgb (255,165,0)')
insert into Color values (13, 'beige' , 'rgb (245,245,220)')
insert into Color values (14, 'silver', 'rgb (192,192,192)')
insert into Color values (15, 'navy', 'rgb (0,0,139)')
insert into Color values (16, 'cream', 'rgb (255, 253, 208)')
insert into Color values (17, 'green', 'rgb (0, 255, 0)')




-- Size --
insert into Size values (101,'XS')
insert into Size values (1001, 'XXS')
insert into Size values (1, 'S')
insert into Size values (2, 'M')
insert into Size values (3, 'L')
insert into Size values (4, 'XL')
insert into Size values (55, 'XXL')

--Size Shoe from id 5 to 15 --
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

insert into Size values(16, '9')
insert into Size values(17, '10')
insert into Size values(18, '11')
insert into Size values(19, '12')
insert into Size values(20, '13')
insert into Size values(21, 'R') -- này là size mắt kính t cũng không rõ nữa --

--Size quần--
insert into Size values (22, '28')
insert into Size values (23, '29')
insert into Size values (24, '30')
insert into Size values (25, '31')
insert into Size values (26, '32')
insert into Size values (27, '33')
insert into Size values (28, '34')


-- User --
-- id_user tu tang nen ko can them
insert into Users values ('Thuong', 'Mon', '0123456789', 'pitithuong@gmail.com', 'thuongmoon', 'a7d9c5088b83e8f8fa111f715579ec0d', '1', 'DHCT', 'Ninh Kieu', 'Can Tho', 'Viet Nam')
insert into Users values ('Thuc','Nguyen Tri','12345678','thuc0416@gmail.com','trithuc','aeb12f9943cb293f00bbb3275efd4520','1','Cai Khe','Ninh Kieu','Can Tho','Viet Nam')
insert into Users values ('Le','Hoang Long ','12345678','Long@gmail.com','LongLe','c6428509f6b988fdc675b072adcac64d','1','Mau Than','Ninh Kieu','Can Tho','Viet Nam')
insert into Users values ('Nguyen','Dang Khoa','0914932098','ndangkhoa567@gmail.com','khoavirgo','d4b16020a52712951984e1271ebec7ac','1','30/4','Ninh Kieu','Can Tho','Viet Nam')

-- Products --
-- (id, user_id (auto_increment), name, describe, price, brand, product_availability)
insert into Products values (1, N'Chân váy tennis xếp ly', 
N'CHÂN VÁY TENNIS KẺ CARO KIỂU CHÂN VÁY XOÈ XẾP LY CÓ LÓT TRONG CẠP LƯNG CAO MẶC ĐI CHƠI HỌC LÀM TẬP THỂ THAO ĐẸP
Mẫu chân váy xếp ly không bao giờ lỗi mốt đây ạ. Diện em chất váy tennis caro này thoải mái vận động các nàng nhé, em nó có lót trong nên không sợ lộ hàng đâu ạ. Với những đường xếp ly đều đặn, chất thun co giãn mang tới cảm giác thoải mái mà vẫn cực kỳ trẻ trung năng động.',
'150000', 'MIDI', 'available')
insert into Products values (1, N'Xiaozhainv Váy denim Ngắn Lưng Cao Thời Trang Mùa Hè Dành Cho Nữ',
N'Gói hàng bao gồm: 1 * Chân váy. Vì hiệu ứng hiển thị và ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể hơi khác so với màu sắc trong hình. Nếu sản phẩm của chúng tôi không có kích thước hay màu sắc yêu thích của bạn, hoặc bạn muốn tìm hiểu thêm thông tin, vui lòng liên hệ với chúng tôi.
Tất cả các sản phẩm đều được gửi về từ nước ngoài, chất lượng siêu tốt với mức giá rẻ, các bạn thấy thích thì đừng quên chia sẻ cho bạn bè mình nha',
'310000', 'RETRO', 'available')
insert into Products values(1, N'Chân váy ngắn xếp ly hai lớp phong cách CHERRY chân váy tennis xòe kiểu xếp li âu mỹ V048',
N'Chân váy xếp ly chữ a phong cách ulzang chất liệu vitex cao cấp mang lại cảm giác thoải mái khi mặc. Chân váy tennis Cherry tuy là chân váy ngắn nhưng thiết kế chiều dài 40cm nên ko quá ngắn xị em có thể tự tin mặc ko lo lộ hàng nhé. Chân váy xếp ly ngắn chữ a thiết kế theo phong cách chân váy xòe nên cực kì dễ mix đồ, mùa hè mix với sơ mi, áo thun, mùa đông mix với ghi lê bao xinh',
'145000', 'CHERRY', 'available')
insert into Products values(1, N'Chân Váy KaKi Chữ A Túi Hộp Phong Cách Hàn Quốc Có Quần Trong Lên From Xinh',
N'THÔNG TIN SẢN PHẨM:Chân Váy KaKi Chữ A Túi Hộp được thiết kế thân trước cúc cài kéo khóa, có túi hộp 2 bên tạo điểm nhấn độcc và lạ mắt. Chất vải kaki thô mềm mại, co giãn mặc vô cùng thoải mái. Chân Váy KaKi Chữ A Túi Hộp Mix cùng với áo sơ mi, phông, 2 dây, crotop.... đều xinh ạ. Các quý cô dạo phố, shopping, cafe, đi làm công sở đều xinh hết nấc nha. Thật sự chị em nào bỏ qua chiếc Chân Váy KaKi Chữ A Túi Hộp này là tiếc lắm luôn ấy.',
'170000', 'RYU', 'available')
insert into Products values(1, N'Chân váy xếp ly Goness cạp cao dáng chữ a phong cách tennis xòe kiểu li ngắn bản to thời trang Hàn Quốc',
N'THÔNG TIN SẢN PHẨM CHÂN VÁY NGẮN XẾP LY GONESS: Chân váy xếp ly hay còn gọi là váy tennis là mặt hàng thời trang phổ biến nhất hiện nay. Lợi ích của dòng Chân váy xếp ly này là dễ phối đồ, dễ mặc, năng động, trẻ trung .Chất vintex dày, mịn, thấm mút mồ hôi tốt, không xù lông, mềm mại cho làn da, cầm mát tay. Chân váy có thể mặc đi chơi, đi làm,..',
'260000', 'Goness', 'available')
insert into Products values(1, N'Chân váy thô zip dáng ngắn kèm thắt lưng bản to 757Quangiavaykemdai',
N'Chân váy kaki kèm đai hàng quảng châu. Đủ màu siêu hót đen nâu be trắng. Số đo là số đo NGANG, mọi người đừng nhân đôi mà hãy lấy số đo này ướm với quần áo đang mặc của mình nhé CAM KẾT VỚI KHÁCH HÀNG:. Sản phẩm giống với mô tả và hình ảnh đăng trên cửa hàng. Mang tới dịch vụ khách hàng tận tâm và nhiệt tình nhất, giúp quý khách có được trải nghiệm tốt nhất khi mua hàng. Giải quyết thắc mắc và vấn đề về sản phẩm (nếu có) cho khách hàng nhanh chóng và thỏa đáng',
'149000', 'QUI', 'available')
insert into Products values(1, N'Chân Váy Tennis Xếp Ly The Good/ Tennis Skirt',
N'Sản phẩm được dệt từ vải Polyester, Vicose và sợi Spandex. Dày dặn chất vải không xù, không dai. Ít nhăn, phẳng phiu, dễ là. Thoáng mát, dễ chịu cho ngày hè. Đường may vô cung tỉ mỉ.',
'327000', 'The Good', 'available')
insert into Products values(1, N'Chân váy chữ A SUNNNY dáng ngắn cạp cao trơn đen _A1',
N'Thành phần: chất liệu kaki/jean dày dặn co giãn nhẹ cực thoải mái. Nên giặt máy ở chế độ máy nhẹ nhàng hoặc giặt tay. GIÁ TẬN GỐC, MIỄN TRUNG GIAN, NÓI KHÔNG VỚI HÀNG KÉM CHẤT LƯỢNG. Chất lượng bền đẹp, luôn đặt uy tín lên hàng đầu.',
'149000', 'SUNNNY', 'available')
insert into Products values(1, N'Chân Váy Chữ A Dáng Xòe Vải PoLy Cạp Chun',
N'Điểm Nhấn: Chân Váy Chữ A Dáng Xòe Vải PoLy Siêu Xinh Có Lót Quần Bên Trong Cạp Chun Bản To 6cm mặc rất dễ chịu và thỏa mái. Chân Váy Chữ A Dáng Xòe Vải PoLy Siêu Xinh Có Lót Quần Bên Trong phù hợp mặc đi chơi, đi tiệc, du lịch.......',
'219000', 'PoLy', 'available')
insert into Products values(1, N'Chân váy tennis nữ L66 xếp ly to công sở cao cấp mặc tôn dáng V4',
N'Chân váy là một trong những items kinh điển trong tủ đồ của tất cả chị em phụ nữ. Thiếu đi chân váy là thiếu đi sự điệu đà nữ tính, thiếu đi một nét đặc trưng của con gái. Chân váy có nhiều loại, mỗi chiếc chân váy mang trong mình một nét đẹp riêng biệt không trộn lẫn.',
'412000', 'LYL', 'available')

--Product shoe --

--Shoe id from 11 to 20 --
insert into Products values(2, N' Giày thể thao thời trang Adidas Continental', N'Tiếp tục trong bộ sưu tập những đôi giày đi học nam đi học nói chung và của thương hiệu Adidas nói riêng là đôi Adidas Continental. Vẻ ngoài vừa cổ điển người hiện đại, phần thân dài chạy được thiết kế cực kỳ tinh xảo, chất liệu da cao cấp cùng với với bộ đệm EVA giúp các bạn đi giày trở nên linh hoạt và thoải mái hơn. Nếu như so sánh Adidas Continental và Stan Smith hoặc SuperStar… thì đây là 3 đối thủ cân sức nhất. Tuy nhiên bạn hoàn toàn có thể để lựa chọn Một đôi Adidas Continental để diện cùng trang phục nhà trường mỗi khi đi học đó!',
'850000','AdiDas','available')
insert into Products values(2, N' Giày thể thao thời trang Adidas Prophere', N'Giày Adidas Prophere từng là cái tên tên được săn đón nhiều nhất một trong năm 2018 và là một trong những cái tên hot nhất trong BST giày phù hợp với học sinh và sinh viên đi học. Adidas Prophere đã từng đốn tim bất kỳ thì các bạn trẻ nào nào nhờ độ “ngầu” và sự “năng động” của nó. Mang vẻ nam tính mạnh mẽ và những chiếc gai ở bộ đế cùng lưỡi gà ấn tương đã tạo cho đôi giày này nét độc đáo mà ít đôi giày nào có được. Trong bộ sưu tập những đôi sneaker cho người lùn thì Adidas Prophere giúp bạn nam và bạn nữ hack 1 phần chiều cao một cách “bí mật” mà không ai biết đó.',
'1800000','Adidas','available')
insert into Products values(2, N'Giày đi bộ Adidas Stan Swith', N'Adidas Stan Smith là mẫu giày kinh điển của thương hiệu Adidas đình đám, đã xuất hiện hơn 45 năm trên thị trường nhưng Adidas Stan Smith vẫn luôn là một trong những mẫu giày sneaker được sử dụng phổ biến và mua nhiều hiện nay. Các mẫu Adidas Stan Smith đã liên tục đổi mới cả về chất lượng và thiết kế, mang đến dòng sản phẩm làm hài lòng mọi khách hàng.',
'1200000','Adidas','available')
insert into Products values(2, N'Giày đi bộ ,phong cách Adidas Ultra Boost', N'Ngoài vẻ ưa nhìn cùng thiết kế hoàn hảo thì Adidas Ultra Boost còn thuyết phục và tạo ấn tượng với bạn ở mức độ hài lòng khi sử dụng. Với kiểu thiết kế mắt lưới thông thoáng, vừa tạo được độ đàn hồi vừa giải phóng năng lượng một cách dễ dàng giúp cho đôi chân bạn luôn khô và thoáng. Đôi giày là sự kết hợp hoàn hảo giữa hai công nghệ tiên tiến bậc nhất đó là công nghệ dệt Mesh và công nghệ đế Boost. Độ êm chân và đàn hồi của đế Boost giúp cho trọng lượng dồn lên đôi chân ở mỗi bước đi được giảm tải khá nhiều. Giúp bạn có thể hoạt động trong thời gian dài với hiệu suất tốt nhất mà không hề cảm thấy đau mỏi chân.Giá giày Adidas Ultra Boost có phần nhỉnh hơn so với 4 đôi giày đi học trên. Dao động từ 2.000.000 - 4.000.000 VNĐ tuỳ vào các phiên bản.',
'2000000','Adidas','available')
insert into Products values(2, N'Giày thời trang phong cách Domba High Point', N'Một đôi giày rất hot được giới trẻ yêu thích chính là đôi Domba High Point đến từ thương hiệu Domba của đất nước Hàn Quốc. Đây là đôi giày mang phong cách thiết kế của đôi giày đình đám Alexander McQueen và đó cũng chính là lý do tại sao đôi giày Domba High Point này lại có sức hút lớn như vậy nhưng có già cực kỳ rẻ. Giày Domba High Point là mẫu giày sneaker được yêu thích của thương hiệu Domba. Mẫu giày được thiết kế với gam màu trắng làm tông chủ đạo tạo cảm giác thanh lịch. Phần upper được làm bằng da cao cấp mịn tạo cảm giác mềm mại, lớp đệm êm ái  giúp đôi chân dễ chịu suốt cả ngày. Đế ngoài bằng cao su có rãnh chống trượt tạo cảm giác linh hoạt khi di chuyển. Với kiểu dáng chunky hiện đại, giày Domba High Point sẽ là sự lựa chọn hoàn hảo cho phong cách của bạn. Giày Domba cao cấp với thiết kế full trắng, điểm nhấn là phần gót giày khác lạ với các màu sắc khác nhau như đen, màu bạc, màu cầu vồng, màu vàng, màu đỏ, màu xanh….Đặc biệt là đế giày cao đến 5cm giúp tôn dáng “ăn gian” chiều cao hiệu quả. Mức giá cho đôi giày Back To School này là khoảng 800.000 – 1.200.000 đ.',
'1200000','Domba','available')
insert into Products values(2, N'Giày thể thao Fila Disruptor 2 Chunky', N'Nếu bạn là một fan của giày chunky thì sẽ không thể bỏ qua siêu phẩm sneaker Fila Disruptor 2, đây là mẫu giày được đánh giá là mạnh mẽ, cá tính với thiết kế “hầm hố”, bộ đế răng cưa táo bạo. Nếu bạn muốn một đôi giày năng động cho Back To School thì Fila là lựa chọn hàng đầu. Có một điều mà chúng ta không thể phủ nhận được đó là độ hot của những đôi Sneaker của thương hiệu Fila. Được thiết kế theo phong cách hầm hố nhưng vẫn tùy biến để phù hợp với dáng người Châu Á, đôi sneaker Fila “chất lừ” đã lên ngôi khiến cho bất kì ai cũng muốn sở hữu. Với phối màu full trắng, đôi sneaker Fila vừa thời thượng lại cực kỳ dễ phối đồ. Bạn có thể kết hợp nó với nhiều kiểu trang phục và biến hóa để có một outfit của riêng mình. Có thể nói Fila Disruptor 2 là mẫu giày bán chạy nhất của hãng. Đây còn được mệnh danh là đôi Sneaker của 2019 do Footwear News bình chọn. Fila Disruptor 2 đã nổi lên như một hiện tượng đình đám trong giới trẻ, chúng trẻ trung năng động, đặc biệt giá bán cũng rất hợp lý.',
'1200000','Fila','available')
insert into Products values(2, N'Giày thời trang MLB Big Ball Chunky', N'Top những đôi sneaker đáng được sở hữu nhất trong mùa Back To School chính là MLB Big Ball Chunky “hầm hố” đã thành cơn sốt và trở nên thịnh hành. Điểm nhấn khác biệt Logo trên thân giày là tên viết tắt của những đội bóng chày đình đám New York Yankees, Los Angeles Dodgers, Boston Red Sox … Giày với thiết kế quá khổ, phần đế cao giúp tôn dáng mang đến sự trẻ trung, cá tính và sành điệu. Không chỉ giúp bạn khẳng định cá tính riêng mà giày sneaker MLB còn đáp ứng tuyệt đối yêu cầu chất lượng, giá bán hiện tại khoảng 2,000,000 – 3,000,000 đ.',
'2500000','MLB','available')
insert into Products values(2, N'Giày thể thao phong cách Nike Air Force 1', N'Hãng giày Nike cũng là một trong những lựa chọn hàng đầu trong ngày Back To School, đặc biệt là dòng Nike Air Force 1. Được áp dụng công nghệ hiện đại đế Air kết hợp với chất liệu da cao cấp khiến Air Force 1 đáp ứng đủ mọi tiêu chí của người dùng. Tông màu trắng cực dễ phối đồ, phù hợp với mọi outfit cũng chính là điều làm cho Air Force 1 là cái tên luôn nằm trong danh sách giày “Must Have-Item”. Hiện nay các mẫu giày Nike Air Force 1 đã được phối với nhiều màu sắc đa dạng, các bạn có thể dễ dàng chọn được kiểu phù hợp với sở thích và phong cách của mình. Giày Nike Air Force 1 chính hãng có giá dao động khoảng từ 1.800.000 – 2.500.000 đ.',
'1800000','Nike','available')
insert into Products values(2, N'Giày thời trang phong cách Nike Air Jordan 1', N'Giày Nike Air Jordan 1 low phù hợp với các bạn học sinh vào mọi mùa trong năm thậm chí vào những ngày hè nắng nóng mùa thu se lạnh hay mùa đông rét buốt. Phong cách phối đồ với giày Jordan này sẽ phù hợp hơn với chiếc quần jean và áo đồng phục trắng ra trường. Nike Air Jordan 1 High sẽ phù hợp hơn với những bạn cá tính. Để diện đôi giày đi học bạn nên lựa chọn một đôi màu màu trắng hoặc đen bởi tông màu này sẽ phù hợp hơn ở độ tuổi học sinh.',
'750000','Nike','available')
insert into Products values(2, N'Giày thời trang Puama Suede', N'Puma Suede là cái tên không thể thiếu nếu bạn là một fan của hãng giày Puma. Nếu người anh em là Adidas sở hữu những đôi Superstar, Stan Smith,… huyền thoại. Thì Puma cũng tự hào vô cùng khi cho ra đời cái tên Puma Suede. Tuy không có độ hype như những đôi Jordan, nhưng nếu bạn là người thích theo phong cách thời trang những năm 70 tại Mỹ, thì Puma Suede là lựa chọn hàng đầu cho các Rapper hay B-boy ở đây. Với thiết kế da lộn đặc trưng, màu sắc đơn giản, form giày thon gọn và phần cao su êm ai nằm trong đế chính đã đem lại cho Puma một người thu khổng lồ, đưa Puma trở thành một thế lực trong ngành công nghiệp Sneaker thế giới. Giá của Puma Suede rơi vào khoảng từ 1 triệu 600 đến 2 triệu. Một mức giá cực kì phù hợp cho đôi giày mà bạn mang hằng ngày.',
'1800000','Puma','available')
--20

--Product_Shirt--
insert into Products values(3,N'Áo khoác lá cổ đơn giản',N'Khoác thoải mái phù hợp cho những chuyến du lịch khám phá. Phối với nhiều Items để tạo những set trang phục ấn tượng','500000','Adidas','available');
insert into Products values(3,N'Sơ mi tay dài',N'Form dáng áo cổ điển được thiết kế vừa vặn, phù hợp với mọi đối tượng. Đặc biệt độ dài phù hợp với mọi sở thích: sơ-vin hoặc thả áo đều được','300000','YaMe','available');
insert into Products values(3,N'Áo thun cổ trụ đơn giản',N'Áo được thiết kế vừa vặn thoải mái. Phần eo, nách và tay áo được thiết kế vừa phải, tự do vận động','270000','Pico','available');
insert into Products values(3,N'Áo Thun Polo Nữ Kiểu Croptop Ngắn Tay WTS 2237',N'Áo Thun Polo Nữ Kiểu Croptop Ngắn Tay WTS 2237. Áo thun polo crotop với độ dài vừa phải, không hở nhiều. Form áo ôm người gọn gàng, tôn dáng.','320000','CoupleTX','available');
insert into Products values(3,N'Áo Khoác Nam Dù Raglan',N'Áo Khoác Nam Dù Raglan Phối Màu MOP 1033 basic form regular tay raglan với bộ màu trẻ trung. Thân trong lót lưới thưa và thân sau rã thoát hơn giúp áo thoáng mát. Hai túi dây kéo thân trước và 1 túi ngang bên trong, rất tiện lợi đựng đồ. Bo tay luồn thun ôm cổ tay, bo lai luồn dây thun có con chặn có thể tăng đơ ôm lai tùy theo người mặc. Có logo X thân trước.','649000','coupleTX','available');
insert into Products values(3,N'Áo Polo Nam Relax Fit In Typo',N'Áo Polo Nam Relax Fit In Typo Serial Chiller MPO 1015 Mẫu áo polo mang hơi hướng hiện đại, trẻ trung nhờ sở hữu form dáng relax năng động. Điểm nhắn là phần hình in ở mặt sau và logo được nổi bật hơn nhờ phần dạ xanh.','429000','Pico','available');
insert into Products values(3,N'Áo Sweater Nữ In Phản Quang Thân Sau',N'Áo Sweater Nữ In Phản Quang Thân Sau WSW 2016. Áo Sweater phối tép phản quang, họa tiết in phản quang trong bóng tối ở thân trước và thân sau tạo sự mới lạ và độc đáo. Form áo relax trẻ trung, năng động. Sản phẩm có thể mặc theo set với jogger thun cùng màu bên dưới hoặc quần jeans, chân váy, Ngoài ra có thể phối trong với áo thun, áo khoác jeans hoặc áo phao bên ngoài cho ngày se lạnh.','439000','Nike','available');
insert into Products values(3,N'Áo Khoác Dù Nữ Phát Quang',N'Áo Khoác Dù Nữ Phát Quang WOP 2031. Là sản phẩm áo khoác có khả năng phát sáng trong đêm. Phát sáng trong bóng tối khi tiếp xúc với ánh sáng tự nhiên hoặc nhân tạo trước đó ít nhất 5 phút.','990000','coupleTX','available');
insert into Products values(3,N'Áo Polo Nữ Pique Regular Fit',N'Áo Polo Nữ Pique Regular Fit Phối Trụ Bo Kiểu WPO 2023. Áo polo có bo và trụ dệt cách điệu vừa thời trang, vừa độc đáo. Form regular gọn gàng, không quá ôm người.','359000','Yody','available');
insert into Products values(3,N'Áo Kiểu Nữ Sơ Mi Xẻ Tà Thân Sau',N'Áo Kiểu Nữ Sơ Mi Xẻ Tà Thân Sau WBL 2017. Áo sơ mi kiểu nữ với điểm nhấn ở sườn áo và thân sau xẻ tà, tạo phong cách vừa phóng khoáng, vừa nữ tính và thời trang.','449000','Yody','available');
insert into Products values(3,N'Áo Sweater Nam Vải Gân Chéo',N'Áo Sweater Nam Vải Gân Chéo Thêu Typo Túi MSW 1017Sweatshirt vải gân chéo với chi tiết túi ở ngực (áo nam) và thêu logo X (áo nữ). Các đường rã áo được đánh bông cùng màu . Thông điệp thêu trên túi ”NEW WAY NEW LIFE”. Form rộng trẻ trung, nặng động.','385000','Nike','available');
-- 31

--Product by KhoaVirgo--
insert into Products values(4,N'Áo chống nắng nữ đa năng',N'Ra đời nhằm bảo vệ da hiệu quả Sản xuất theo cơ chế phản xạ ánh sáng. Từ đó giúp che phủ làn da cũng như phản xạ lại nguồn ánh sáng có bức xạ cao đến từ ánh nắng mặt trời. Bởi vậy mà ngăn chặn các loại tia UV xuyên vào trong da.','449000','Yody','available');
insert into Products values(4,N'Áo Len Gân Nữ Tay Dài Cổ Tim',N'Áo len nữ dệt gân dáng ôm với phần cổ tim nữ tính, kiểu dệt gân tạo cảm giác thoải mái, co giãn tốt, chiếc áo với chất liệu len siêu mềm mướt, giữ ấm và thấm hút tốt.','399000','Yody','available');
insert into Products values(4,N'Đầm Đông Nữ Kẻ Tay Phối',N'Thiết kế đầm kẻ tay phối thanh lịch và đầy nữ tính, kiểu dáng ấn tượng giúp tôn lên đường cong cơ thể cho người mặc, chất liệu dày dặn vừa phải, thích hợp mặc ngay cả trong mùa thu đông','669000','Yody','available');
insert into Products values(4,N'Bộ Đồ Thể Thao Trẻ Em Youth Life',N'Chất liệu  91% Polyester + 9% Spandex, vải được dệt từ sợi Polyester dài & mảnh, kết hợp cùng kiểu dệt Double Face cho nền vải chắc chắn nhưng vẫn có độ xốp, nhẹ nhàng, độ bền cao, ít nhăn','599000','Yody','available');
insert into Products values(4,N'TÚI VUÔNG MINI NHIỀU NGĂN',N'Túi city vải cỡ mini, đính đá lấp lánh. Có hai quai xách tay buộc thắt nút ở hai đầu. Bên trong lót vải. Có một dây đeo dạng xích bằng kim loại, dùng để đeo chéo. Đóng mở bằng khuy nam châm.','1999000','Zara','available');
insert into Products values(4,N'Túi xách hình hộp chữ nhật Classic Push Lock',N'Chiếc túi xách với phom dáng hình hộp cổ điển cùng màu đen linh hoạt chắc chắn sẽ phù hợp với mọi loại trang trong tủ đồ của bạn. Khóa cài kim loại tông màu vàng sang trọng giúp tạo điểm nhấn cho tổng thể. Tay cầm cố định và dây đeo da có thể tháo rời, bạn có thể xách tay hoặc đeo chéo tùy theo sở thích. Phối túi cùng áo sơ mi và váy bút chì cho diện mạo thanh lịch và sang trọng.','1590000','Charles & Keith','available');
insert into Products values(4,N'Ví mini dạng gập Georgette Checkered',N'Nhờ thiết kế carô bắt mắt của chiếc ví Georgette mà bạn sẽ dễ dàng tìm thấy trong túi xách của mình mặc dù nó có kích thước nhỏ. Khóa cài dạng nút bấm giúp bạn dễ dàng lấy đồ đạc mà vẫn có thể giữ chúng an toàn và bảo mật. Với kích thước nhỏ gọn bạn có thể cầm tay hoặc để ví trong túi quần hoặc túi xách tùy theo sở thích của mình.','890000','Charles & Keith','available');
insert into Products values(4,N'Kính mát gọng phi công Gem-Embellished Wireframe Aviator',N'Khi phân vân không biết nên mang gì, thì đừng chần chừ mà hãy chọn ngay chiếc kính phi công sành điệu này của chúng tôi. Nâng tầm thiết kế cổ điển với gọng kính được tô điểm bằng đá nổi bật, tròng kính màu đen cùng các chi tiết trang trí bằng đá dọc theo các cạnh để tạo nên sự lấp lánh tinh tế. Mang chúng đến những buổi cà phê, bãi biển hoặc bất cứ nơi đâu bạn thích.','1750000','Charles & Keith','available');
insert into Products values(4,N'Ví đựng thẻ Micaela Quilted',N'Nếu bạn luôn thích dòng sản phẩm Micaela của chúng tôi, thì chiếc ví đựng thẻ sẽ phù hợp cho những ai yêu thích vẻ ngoài tinh tế và thanh lịch. Nổi bật với thiết kế chần bông cổ điển và kiểu dáng nhỏ gọn mà tất cả các cô gái đều yêu thích. Ngoài ra, món phụ kiện nhỏ xinh này còn được hoàn thiện bằng tông màu đen để tạo nên vẻ ngoài trường tồn với thời gian.','1150000','Charles & Keith','available');
insert into Products values(4,N'Áo Khoác Classic Tối Giản Ver6',N'Áo Khoác Classic Đơn Giản Y Nguyên Bản Ver6, chất liệu: Vải Dù, thành phần: 100% poly, chống tia UV, cản gió, nhanh khô, bền màu tốt, trượt nước','385000','Yame','available');

--Quần nè--
insert into Products values(4,N'Quần Jean Nam S-Cafe Thân Thiện Với Môi Trường',N'Quần jeans nam chất liệu cotton USA - loại vải cao cấp được cả thế giới tin dùng với nhiều ưu điểm nổi bật, cotton USA sạch hơn các loại bông khác do quá trình thu hoạch sử dụng thiết bị điều khiển bằng máy tính tân tiến nhất','599000','Yody','available')
insert into Products values(4,N'Quần Âu Nam Classic Thêu Yody',N'Chất liệu: 78% polyester+ 18% rayon+ 4% spandex thoáng khí, thấm hút tốt','549000','Yody','available')
insert into Products values(4,N'Quần Short Nam Yody Sport',N'Chất liệu mềm mại, nhẹ nhàng phù hợp vận động, thiết kế thể thao, khỏe khoắn. Cạp chun cả vòng bản to vô cùng khỏe khoắn','199000','Yody','available')
insert into Products values(4,N'Quần Kaki Nam Regular',N'Quần kaki nam dáng regular thoải mái, tôn dáng, thiết kế basic, màu sắc hiện đại, dễ phối đồ','499000','Yody','available')
insert into Products values(4,N'Quần Legging Nữ 2 Túi Khóa',N'Chất liệu 70% Viscose, 25% Polyesster, 5% spandex, thoải mái cùng chất liệu mềm mại, dày dặn','349000','Yody','available')
insert into Products values(4,N'Quần Dài Vải Linh Vật Olygre Ver3',N'Quần ống rộng hay culottes là định nghĩa cho loại quần dài có ống rộng, dáng suông và có độ dài qua đầu gối. Quần ống rộng thực chất được thiết kế dành cho nam giới. Tuy nhiên những năm 1902, những chiếc quần này được phái nữ bắt đầu sử dụng với cái tên khác là quần Thổ Nhĩ Kỳ.','425000','Yame','available')
insert into Products values(4,N'Quần Dài Vải Đơn Giản Y Nguyên Bản Ver14',N'Quần trouser là một kiểu dáng quần nam cổ điển được nhiều quý ông yêu thích. Đây là một loại quần âu (Quần tây) dáng dài chuyên phục vụ cho quý ông công sở.','397000','Yame','available')
insert into Products values(4,N'Quần Tây Nam Pierre Cardin - PQT000288',N'Quần tây nam chất lượng cao đến từ thương hiệu Pierre Cardin','1750000','Pierre Cardin','available')
insert into Products values(4,N'Quần Golf Nam An Phước - AQTG00618',N'Lựa chọn quần áo đánh golf nam phù hợp với hoàn cảnh ra sân. Khi tham gia những trận cầu giải trí, nghiệp dư hoặc các giải đấu nhỏ.','950000','An Phuoc','available')

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

--Product_Quantity_Shirt--
insert into Product_Quantity values (21, 1, 1, 140)
insert into Product_Quantity values (21, 1, 2, 193)
insert into Product_Quantity values (21, 2, 1, 111)
insert into Product_Quantity values (21, 2, 2, 115)
insert into Product_Quantity values (21, 3, 1, 167)
insert into Product_Quantity values (21, 3, 2, 102)
insert into Product_Quantity values (21, 4, 1, 203)
insert into Product_Quantity values (21, 4, 2, 154)
insert into Product_Quantity values (21, 55, 1, 118)
insert into Product_Quantity values (21, 55, 2, 125)

insert into Product_Quantity values (22, 1, 1, 122)
insert into Product_Quantity values (22, 1, 2, 113)
insert into Product_Quantity values (22, 2, 1, 107)
insert into Product_Quantity values (22, 2, 2, 195)
insert into Product_Quantity values (22, 3, 1, 215)
insert into Product_Quantity values (22, 3, 2, 132)
insert into Product_Quantity values (22, 4, 1, 180)
insert into Product_Quantity values (22, 4, 2, 131)
insert into Product_Quantity values (22, 4, 1, 150)
insert into Product_Quantity values (22, 4, 2, 139)
insert into Product_Quantity values (22, 55, 1, 122)
insert into Product_Quantity values (22, 55, 2, 116)

insert into Product_Quantity values (23, 1, 1, 160)
insert into Product_Quantity values (23, 1, 2, 105)
insert into Product_Quantity values (23, 2, 1, 144)
insert into Product_Quantity values (23, 2, 2, 183)
insert into Product_Quantity values (23, 3, 1, 142)
insert into Product_Quantity values (23, 3, 2, 111)
insert into Product_Quantity values (23, 4, 1, 264)
insert into Product_Quantity values (23, 4, 2, 179)
insert into Product_Quantity values (23, 55, 1, 121)
insert into Product_Quantity values (23, 55, 2, 165)

insert into Product_Quantity values (24, 1, 1, 155)
insert into Product_Quantity values (24, 1, 2, 127)
insert into Product_Quantity values (24, 2, 1, 143)
insert into Product_Quantity values (24, 2, 2, 134)
insert into Product_Quantity values (24, 3, 1, 168)
insert into Product_Quantity values (24, 3, 2, 176)
insert into Product_Quantity values (24, 4, 1, 181)
insert into Product_Quantity values (24, 4, 2, 192)
insert into Product_Quantity values (24, 55, 1, 112)
insert into Product_Quantity values (24, 55, 2, 220)

insert into Product_Quantity values (25, 1, 1, 124)
insert into Product_Quantity values (25, 1, 2, 105)
insert into Product_Quantity values (25, 2, 1, 137)
insert into Product_Quantity values (25, 2, 2, 114)
insert into Product_Quantity values (25, 3, 1, 145)
insert into Product_Quantity values (25, 3, 2, 159)
insert into Product_Quantity values (25, 4, 1, 163)
insert into Product_Quantity values (25, 4, 2, 177)
insert into Product_Quantity values (25, 55, 1, 188)
insert into Product_Quantity values (25, 55, 2, 199)

insert into Product_Quantity values (26, 1, 1, 123)
insert into Product_Quantity values (26, 1, 2, 108)
insert into Product_Quantity values (26, 2, 1, 136)
insert into Product_Quantity values (26, 2, 2, 116)
insert into Product_Quantity values (26, 3, 1, 146)
insert into Product_Quantity values (26, 3, 2, 157)
insert into Product_Quantity values (26, 4, 1, 168)
insert into Product_Quantity values (26, 4, 2, 178)
insert into Product_Quantity values (26, 55, 1, 182)
insert into Product_Quantity values (26, 55, 2, 193)

insert into Product_Quantity values (27, 1, 1, 128)
insert into Product_Quantity values (27, 1, 2, 109)
insert into Product_Quantity values (27, 2, 1, 139)
insert into Product_Quantity values (27, 2, 2, 110)
insert into Product_Quantity values (27, 3, 1, 145)
insert into Product_Quantity values (27, 3, 2, 153)
insert into Product_Quantity values (27, 4, 1, 161)
insert into Product_Quantity values (27, 4, 2, 171)
insert into Product_Quantity values (27, 55, 1, 181)
insert into Product_Quantity values (27, 55, 2, 194)

insert into Product_Quantity values (28, 1, 1, 120)
insert into Product_Quantity values (28, 1, 2, 101)
insert into Product_Quantity values (28, 2, 1, 92)
insert into Product_Quantity values (28, 2, 2, 83)
insert into Product_Quantity values (28, 3, 1, 147)
insert into Product_Quantity values (28, 3, 2, 50)
insert into Product_Quantity values (28, 4, 1, 164)
insert into Product_Quantity values (28, 4, 2, 174)
insert into Product_Quantity values (28, 55, 1, 72)
insert into Product_Quantity values (28, 55, 2, 213)

insert into Product_Quantity values (29, 1, 1, 77)
insert into Product_Quantity values (29, 1, 2, 100)
insert into Product_Quantity values (29, 2, 1, 138)
insert into Product_Quantity values (29, 2, 2, 117)
insert into Product_Quantity values (29, 3, 1, 58)
insert into Product_Quantity values (29, 3, 2, 151)
insert into Product_Quantity values (29, 4, 1, 162)
insert into Product_Quantity values (29, 4, 2, 97)
insert into Product_Quantity values (29, 55, 1, 187)
insert into Product_Quantity values (29, 55, 2, 130)

insert into Product_Quantity values (30, 1, 1, 67)
insert into Product_Quantity values (30, 1, 2, 85)
insert into Product_Quantity values (30, 2, 1, 132)
insert into Product_Quantity values (30, 2, 2, 115)
insert into Product_Quantity values (30, 3, 1, 140)
insert into Product_Quantity values (30, 3, 2, 152)
insert into Product_Quantity values (30, 4, 1, 164)
insert into Product_Quantity values (30, 4, 2, 179)
insert into Product_Quantity values (30, 55, 1, 181)
insert into Product_Quantity values (30, 55, 2, 213)

insert into Product_Quantity values (31, 1, 1, 72)
insert into Product_Quantity values (31, 1, 2, 108)
insert into Product_Quantity values (31, 2, 1, 135)
insert into Product_Quantity values (31, 2, 2, 118)
insert into Product_Quantity values (31, 3, 1, 141)
insert into Product_Quantity values (31, 3, 2, 153)
insert into Product_Quantity values (31, 4, 1, 169)
insert into Product_Quantity values (31, 4, 2, 174)
insert into Product_Quantity values (31, 55, 1, 180)
insert into Product_Quantity values (31, 55, 2, 211)

-- (product_id, size_id, color_id, quantity)
insert into Product_Quantity values (32, 1, 1, 125)
insert into Product_Quantity values (32, 1, 2, 114)
insert into Product_Quantity values (32, 1, 4, 137)
insert into Product_Quantity values (32, 1, 10, 53)
insert into Product_Quantity values (32, 1, 11, 42)
insert into Product_Quantity values (32, 2, 1, 125)
insert into Product_Quantity values (32, 2, 2, 114)
insert into Product_Quantity values (32, 2, 4, 137)
insert into Product_Quantity values (32, 2, 10, 53)
insert into Product_Quantity values (32, 2, 11, 42)
insert into Product_Quantity values (32, 3, 1, 125)
insert into Product_Quantity values (32, 3, 2, 114)
insert into Product_Quantity values (32, 3, 4, 137)
insert into Product_Quantity values (32, 3, 10, 53)
insert into Product_Quantity values (32, 3, 11, 42)
insert into Product_Quantity values (32, 4, 1, 125)
insert into Product_Quantity values (32, 4, 2, 114)
insert into Product_Quantity values (32, 4, 4, 137)
insert into Product_Quantity values (32, 4, 10, 53)
insert into Product_Quantity values (32, 4, 11, 42)
insert into Product_Quantity values (32, 55, 1, 125)
insert into Product_Quantity values (32, 55, 2, 114)
insert into Product_Quantity values (32, 55, 4, 137)
insert into Product_Quantity values (32, 55, 10, 53)
insert into Product_Quantity values (32, 55, 11, 42)
insert into Product_Quantity values (33, 1, 2, 78)
insert into Product_Quantity values (33, 1, 8, 124)
insert into Product_Quantity values (33, 2, 2, 133)
insert into Product_Quantity values (33, 2, 8, 54)
insert into Product_Quantity values (34, 1, 2, 18)
insert into Product_Quantity values (34, 1, 5, 60)
insert into Product_Quantity values (34, 1, 13, 75)
insert into Product_Quantity values (34, 2, 2, 137)
insert into Product_Quantity values (34, 2, 5, 189)
insert into Product_Quantity values (34, 2, 13, 92)
insert into Product_Quantity values (34, 3, 2, 51)
insert into Product_Quantity values (34, 3, 5, 185)
insert into Product_Quantity values (34, 3, 13, 170)
insert into Product_Quantity values (34, 4, 2, 147)
insert into Product_Quantity values (34, 4, 5, 156)
insert into Product_Quantity values (34, 4, 13, 15)
insert into Product_Quantity values (35, 16, 1, 149)
insert into Product_Quantity values (35, 16, 6, 52)
insert into Product_Quantity values (35, 17, 1, 148)
insert into Product_Quantity values (35, 17, 6, 2)
insert into Product_Quantity values (35, 18, 1, 8)
insert into Product_Quantity values (35, 18, 6, 62)
insert into Product_Quantity values (35, 19, 1, 73)
insert into Product_Quantity values (35, 19, 6, 198)
insert into Product_Quantity values (35, 20, 1, 39)
insert into Product_Quantity values (35, 20, 6, 131)
insert into Product_Quantity values (36, 2, 1, 106)
insert into Product_Quantity values (36, 2, 14, 104)
insert into Product_Quantity values (37, 1, 1, 127)
insert into Product_Quantity values (37, 1, 2, 11)
insert into Product_Quantity values (37, 1, 13, 29)
insert into Product_Quantity values (38, 1001, 1, 115)
insert into Product_Quantity values (38, 1001, 15, 108)
insert into Product_Quantity values (39, 21, 1, 117)
insert into Product_Quantity values (39, 21, 9, 79)
insert into Product_Quantity values (39, 21, 16, 172)
insert into Product_Quantity values (40, 1001, 1, 83)
insert into Product_Quantity values (40, 1001, 3, 36)
insert into Product_Quantity values (40, 1001, 17, 72)
insert into Product_Quantity values (41, 1, 1, 83)
insert into Product_Quantity values (41, 2, 1, 2)
insert into Product_Quantity values (41, 3, 1, 191)
insert into Product_Quantity values (41, 4, 1, 170)
insert into Product_Quantity values (42, 22, 6, 141)
insert into Product_Quantity values (42, 22, 15, 1)
insert into Product_Quantity values (42, 23, 6, 25)
insert into Product_Quantity values (42, 23, 15, 5)
insert into Product_Quantity values (42, 24, 6, 50)
insert into Product_Quantity values (42, 24, 15, 176)
insert into Product_Quantity values (42, 25, 6, 17)
insert into Product_Quantity values (42, 25, 15, 77)
insert into Product_Quantity values (42, 26, 6, 166)
insert into Product_Quantity values (42, 26, 15, 19)
insert into Product_Quantity values (42, 27, 6, 149)
insert into Product_Quantity values (42, 27, 15, 73)
insert into Product_Quantity values (42, 28, 6, 38)
insert into Product_Quantity values (42, 28, 15, 83)
insert into Product_Quantity values (43, 22, 1, 73)
insert into Product_Quantity values (43, 22, 5, 74)
insert into Product_Quantity values (43, 22, 8, 125)
insert into Product_Quantity values (43, 22, 15, 120)
insert into Product_Quantity values (43, 23, 1, 46)
insert into Product_Quantity values (43, 23, 5, 200)
insert into Product_Quantity values (43, 23, 8, 180)
insert into Product_Quantity values (43, 23, 15, 183)
insert into Product_Quantity values (43, 24, 1, 186)
insert into Product_Quantity values (43, 24, 5, 106)
insert into Product_Quantity values (43, 24, 8, 41)
insert into Product_Quantity values (43, 24, 15, 83)
insert into Product_Quantity values (43, 25, 1, 56)
insert into Product_Quantity values (43, 25, 5, 174)
insert into Product_Quantity values (43, 25, 8, 183)
insert into Product_Quantity values (43, 25, 15, 165)
insert into Product_Quantity values (43, 26, 1, 118)
insert into Product_Quantity values (43, 26, 5, 123)
insert into Product_Quantity values (43, 26, 8, 42)
insert into Product_Quantity values (43, 26, 15, 64)
insert into Product_Quantity values (44, 23, 1, 25)
insert into Product_Quantity values (44, 23, 2, 36)
insert into Product_Quantity values (44, 23, 15, 26)
insert into Product_Quantity values (44, 24, 1, 47)
insert into Product_Quantity values (44, 24, 2, 16)
insert into Product_Quantity values (44, 24, 15, 126)
insert into Product_Quantity values (44, 25, 1, 152)
insert into Product_Quantity values (44, 25, 2, 164)
insert into Product_Quantity values (44, 25, 15, 172)
insert into Product_Quantity values (44, 26, 1, 173)
insert into Product_Quantity values (44, 26, 2, 26)
insert into Product_Quantity values (44, 26, 15, 17)
insert into Product_Quantity values (44, 27, 1, 23)
insert into Product_Quantity values (44, 27, 2, 75)
insert into Product_Quantity values (44, 27, 15, 85)
insert into Product_Quantity values (45, 23, 1, 85)
insert into Product_Quantity values (45, 23, 2, 58)
insert into Product_Quantity values (45, 23, 5, 125)
insert into Product_Quantity values (45, 24, 1, 162)
insert into Product_Quantity values (45, 24, 2, 172)
insert into Product_Quantity values (45, 24, 5, 172)
insert into Product_Quantity values (45, 25, 1, 162)
insert into Product_Quantity values (45, 25, 2, 183)
insert into Product_Quantity values (45, 25, 5, 152)
insert into Product_Quantity values (45, 26, 1, 26)
insert into Product_Quantity values (45, 26, 2, 72)
insert into Product_Quantity values (45, 26, 5, 81)
insert into Product_Quantity values (45, 27, 1, 27)
insert into Product_Quantity values (45, 27, 2, 36)
insert into Product_Quantity values (45, 27, 5, 83)
insert into Product_Quantity values (45, 28, 1, 126)
insert into Product_Quantity values (45, 28, 2, 52)
insert into Product_Quantity values (45, 28, 5, 93)
insert into Product_Quantity values (46, 1, 1, 118)
insert into Product_Quantity values (46, 2, 1, 93)
insert into Product_Quantity values (46, 3, 1, 96)
insert into Product_Quantity values (46, 4, 1, 28)
insert into Product_Quantity values (46, 55, 1, 47)
insert into Product_Quantity values (47, 25, 15, 87)
insert into Product_Quantity values (47, 26, 15, 38)
insert into Product_Quantity values (47, 27, 15, 190)
insert into Product_Quantity values (48, 23, 1, 5)
insert into Product_Quantity values (48, 23, 1, 22)
insert into Product_Quantity values (48, 23, 1, 163)
insert into Product_Quantity values (48, 23, 1, 133)
insert into Product_Quantity values (48, 23, 1, 44)
insert into Product_Quantity values (49, 24, 1, 169)
insert into Product_Quantity values (49, 25, 1, 168)
insert into Product_Quantity values (49, 26, 1, 75)
insert into Product_Quantity values (49, 27, 1, 34)
insert into Product_Quantity values (49, 28, 1, 44)
insert into Product_Quantity values (49, 5, 1, 113)
insert into Product_Quantity values (49, 6, 1, 118)
insert into Product_Quantity values (49, 7, 1, 145)
insert into Product_Quantity values (50, 24, 1, 79)
insert into Product_Quantity values (50, 25, 1, 97)
insert into Product_Quantity values (50, 26, 1, 18)
insert into Product_Quantity values (50, 27, 1, 30)
insert into Product_Quantity values (50, 28, 1, 49)
insert into Product_Quantity values (50, 5, 1, 45)
insert into Product_Quantity values (50, 6, 1, 109)
insert into Product_Quantity values (50, 7, 1, 67)

-- Image --
-- id_image tu tang nen ko can them
-- nhung phai nho de lam bang product_image
insert into Image values ('../../Content/images/products/pd1.1.jpg')
insert into Image values ('../../Content/images/products/pd1.2.jpg')
insert into Image values ('../../Content/images/products/pd1.3.jpg')
insert into Image values ('../../Content/images/products/pd1.4.jpg')
insert into Image values ('../../Content/images/products/pd2.1.jpg')
insert into Image values ('../../Content/images/products/pd2.2.jpg')
insert into Image values ('../../Content/images/products/pd2.3.jpg')
insert into Image values ('../../Content/images/products/pd2.4.jpg')
insert into Image values ('../../Content/images/products/pd3.1.jpg')
insert into Image values ('../../Content/images/products/pd3.2.jpg')
insert into Image values ('../../Content/images/products/pd3.3.jpg')
insert into Image values ('../../Content/images/products/pd3.4.jpg')
insert into Image values ('../../Content/images/products/pd4.1.jpg')
insert into Image values ('../../Content/images/products/pd4.2.jpg')
insert into Image values ('../../Content/images/products/pd4.3.jpg')
insert into Image values ('../../Content/images/products/pd4.4.jpg')
insert into Image values ('../../Content/images/products/pd5.1.jpg')
insert into Image values ('../../Content/images/products/pd5.2.jpg')
insert into Image values ('../../Content/images/products/pd5.3.jpg')
insert into Image values ('../../Content/images/products/pd5.4.jpg')
insert into Image values ('../../Content/images/products/pd6.1.jpg')
insert into Image values ('../../Content/images/products/pd6.2.jpg')
insert into Image values ('../../Content/images/products/pd6.3.jpg')
insert into Image values ('../../Content/images/products/pd6.4.jpg')
insert into Image values ('../../Content/images/products/pd7.1.jpg')
insert into Image values ('../../Content/images/products/pd7.2.jpg')
insert into Image values ('../../Content/images/products/pd7.3.jpg')
insert into Image values ('../../Content/images/products/pd7.4.jpg')
insert into Image values ('../../Content/images/products/pd8.1.jpg')
insert into Image values ('../../Content/images/products/pd8.2.jpg')
insert into Image values ('../../Content/images/products/pd8.3.jpg')
insert into Image values ('../../Content/images/products/pd8.4.jpg')
insert into Image values ('../../Content/images/products/pd9.1.jpg')
insert into Image values ('../../Content/images/products/pd9.2.jpg')
insert into Image values ('../../Content/images/products/pd9.3.jpg')
insert into Image values ('../../Content/images/products/pd9.4.jpg')

insert into Image values ('../../Content/images/products/pd10.1.jpg')
insert into Image values ('../../Content/images/products/pd10.2.jpg')
insert into Image values ('../../Content/images/products/pd10.3.jpg')
insert into Image values ('../../Content/images/products/pd10.4.jpg')
insert into Image values ('../../Content/images/products/pd11.1.jpg')
insert into Image values ('../../Content/images/products/pd11.2.jpg')
insert into Image values ('../../Content/images/products/pd11.3.jpg')
insert into Image values ('../../Content/images/products/pd11.4.jpg')
insert into Image values ('../../Content/images/products/pd12.1.jpg')
insert into Image values ('../../Content/images/products/pd12.2.jpg')
insert into Image values ('../../Content/images/products/pd12.3.jpg')
insert into Image values ('../../Content/images/products/pd12.4.jpg')
insert into Image values ('../../Content/images/products/pd13.1.jpg')
insert into Image values ('../../Content/images/products/pd13.2.jpg')
insert into Image values ('../../Content/images/products/pd13.3.jpg')
insert into Image values ('../../Content/images/products/pd13.4.jpg')
insert into Image values ('../../Content/images/products/pd14.1.jpg')
insert into Image values ('../../Content/images/products/pd14.2.jpg')
insert into Image values ('../../Content/images/products/pd14.3.jpg')
insert into Image values ('../../Content/images/products/pd14.4.jpg')
insert into Image values ('../../Content/images/products/pd15.1.jpg')
insert into Image values ('../../Content/images/products/pd15.2.jpg')
insert into Image values ('../../Content/images/products/pd15.3.jpg')
insert into Image values ('../../Content/images/products/pd15.4.jpg')
insert into Image values ('../../Content/images/products/pd16.1.jpg')
insert into Image values ('../../Content/images/products/pd16.2.jpg')
insert into Image values ('../../Content/images/products/pd16.3.jpg')
insert into Image values ('../../Content/images/products/pd16.4.jpg')
insert into Image values ('../../Content/images/products/pd17.1.jpg')
insert into Image values ('../../Content/images/products/pd17.2.jpg')
insert into Image values ('../../Content/images/products/pd17.3.jpg')
insert into Image values ('../../Content/images/products/pd17.4.jpg')
insert into Image values ('../../Content/images/products/pd18.1.jpg')
insert into Image values ('../../Content/images/products/pd18.2.jpg')
insert into Image values ('../../Content/images/products/pd18.3.jpg')
insert into Image values ('../../Content/images/products/pd18.4.jpg')
insert into Image values ('../../Content/images/products/pd19.1.jpg')
insert into Image values ('../../Content/images/products/pd19.2.jpg')
insert into Image values ('../../Content/images/products/pd19.3.jpg')
insert into Image values ('../../Content/images/products/pd19.4.jpg')
insert into Image values ('../../Content/images/products/pd20.1.jpg')
insert into Image values ('../../Content/images/products/pd20.2.jpg')
insert into Image values ('../../Content/images/products/pd20.3.jpg')
insert into Image values ('../../Content/images/products/pd20.4.jpg')

-- Image_shirt
insert into Image values ('../../Content/images/products/pd200.1.jpg')
insert into Image values ('../../Content/images/products/pd200.2.jpg')
insert into Image values ('../../Content/images/products/pd200.3.jpg')
insert into Image values ('../../Content/images/products/pd200.4.jpg')
insert into Image values ('../../Content/images/products/pd201.1.jpg')
insert into Image values ('../../Content/images/products/pd201.2.jpg')
insert into Image values ('../../Content/images/products/pd201.3.jpg')
insert into Image values ('../../Content/images/products/pd201.4.jpg')
insert into Image values ('../../Content/images/products/pd202.1.jpg')
insert into Image values ('../../Content/images/products/pd202.2.jpg')
insert into Image values ('../../Content/images/products/pd202.3.jpg')
insert into Image values ('../../Content/images/products/pd202.4.jpg')
insert into Image values ('../../Content/images/products/pd203.1.jpg')
insert into Image values ('../../Content/images/products/pd203.2.jpg')
insert into Image values ('../../Content/images/products/pd203.3.jpg')
insert into Image values ('../../Content/images/products/pd203.4.jpg')
insert into Image values ('../../Content/images/products/pd204.1.jpg')
insert into Image values ('../../Content/images/products/pd204.2.jpg')
insert into Image values ('../../Content/images/products/pd204.3.jpg')
insert into Image values ('../../Content/images/products/pd204.4.jpg')
insert into Image values ('../../Content/images/products/pd205.1.jpg')
insert into Image values ('../../Content/images/products/pd205.2.jpg')
insert into Image values ('../../Content/images/products/pd205.3.jpg')
insert into Image values ('../../Content/images/products/pd205.4.jpg')
insert into Image values ('../../Content/images/products/pd206.1.jpg')
insert into Image values ('../../Content/images/products/pd206.2.jpg')
insert into Image values ('../../Content/images/products/pd206.3.jpg')
insert into Image values ('../../Content/images/products/pd206.4.jpg')
insert into Image values ('../../Content/images/products/pd207.1.jpg')
insert into Image values ('../../Content/images/products/pd207.2.jpg')
insert into Image values ('../../Content/images/products/pd207.3.jpg')
insert into Image values ('../../Content/images/products/pd207.4.jpg')
insert into Image values ('../../Content/images/products/pd208.1.jpg')
insert into Image values ('../../Content/images/products/pd208.2.jpg')
insert into Image values ('../../Content/images/products/pd208.3.jpg')
insert into Image values ('../../Content/images/products/pd208.4.jpg')
insert into Image values ('../../Content/images/products/pd209.1.jpg')
insert into Image values ('../../Content/images/products/pd209.2.jpg')
insert into Image values ('../../Content/images/products/pd209.3.jpg')
insert into Image values ('../../Content/images/products/pd209.4.jpg')
insert into Image values ('../../Content/images/products/pd210.1.jpg')
insert into Image values ('../../Content/images/products/pd210.2.jpg')
insert into Image values ('../../Content/images/products/pd210.3.jpg')
insert into Image values ('../../Content/images/products/pd210.4.jpg')

insert into Image values ('../../Content/images/products/pd32.1.jpg')
insert into Image values ('../../Content/images/products/pd32.2.jpg')
insert into Image values ('../../Content/images/products/pd32.3.jpg')
insert into Image values ('../../Content/images/products/pd32.4.jpg')
insert into Image values ('../../Content/images/products/pd33.1.jpg')
insert into Image values ('../../Content/images/products/pd33.2.jpg')
insert into Image values ('../../Content/images/products/pd33.3.jpg')
insert into Image values ('../../Content/images/products/pd33.4.jpg')
insert into Image values ('../../Content/images/products/pd34.1.jpg')
insert into Image values ('../../Content/images/products/pd34.2.jpg')
insert into Image values ('../../Content/images/products/pd34.3.jpg')
insert into Image values ('../../Content/images/products/pd34.4.jpg')
insert into Image values ('../../Content/images/products/pd35.1.jpg')
insert into Image values ('../../Content/images/products/pd35.2.jpg')
insert into Image values ('../../Content/images/products/pd35.3.jpg')
insert into Image values ('../../Content/images/products/pd35.4.jpg')
insert into Image values ('../../Content/images/products/pd36.1.jpg')
insert into Image values ('../../Content/images/products/pd36.2.jpg')
insert into Image values ('../../Content/images/products/pd36.3.jpg')
insert into Image values ('../../Content/images/products/pd36.4.jpg')
insert into Image values ('../../Content/images/products/pd37.1.jpg')
insert into Image values ('../../Content/images/products/pd37.2.jpg')
insert into Image values ('../../Content/images/products/pd37.3.jpg')
insert into Image values ('../../Content/images/products/pd37.4.jpg')
insert into Image values ('../../Content/images/products/pd38.1.jpg')
insert into Image values ('../../Content/images/products/pd38.2.jpg')
insert into Image values ('../../Content/images/products/pd38.3.jpg')
insert into Image values ('../../Content/images/products/pd38.4.jpg')
insert into Image values ('../../Content/images/products/pd39.1.jpg')
insert into Image values ('../../Content/images/products/pd39.2.jpg')
insert into Image values ('../../Content/images/products/pd39.3.jpg')
insert into Image values ('../../Content/images/products/pd39.4.jpg')
insert into Image values ('../../Content/images/products/pd40.1.jpg')
insert into Image values ('../../Content/images/products/pd40.2.jpg')
insert into Image values ('../../Content/images/products/pd40.3.jpg')
insert into Image values ('../../Content/images/products/pd40.4.jpg')
insert into Image values ('../../Content/images/products/pd41.1.jpg')
insert into Image values ('../../Content/images/products/pd41.2.jpg')
insert into Image values ('../../Content/images/products/pd42.1.jpg')
insert into Image values ('../../Content/images/products/pd42.2.jpg')
insert into Image values ('../../Content/images/products/pd42.3.jpg')
insert into Image values ('../../Content/images/products/pd42.4.jpg')
insert into Image values ('../../Content/images/products/pd43.1.jpg')
insert into Image values ('../../Content/images/products/pd43.2.jpg')
insert into Image values ('../../Content/images/products/pd43.3.jpg')
insert into Image values ('../../Content/images/products/pd43.4.jpg')
insert into Image values ('../../Content/images/products/pd44.1.jpg')
insert into Image values ('../../Content/images/products/pd44.2.jpg')
insert into Image values ('../../Content/images/products/pd44.3.jpg')
insert into Image values ('../../Content/images/products/pd44.4.jpg')
insert into Image values ('../../Content/images/products/pd45.1.jpg')
insert into Image values ('../../Content/images/products/pd45.2.jpg')
insert into Image values ('../../Content/images/products/pd45.3.jpg')
insert into Image values ('../../Content/images/products/pd45.4.jpg')
insert into Image values ('../../Content/images/products/pd46.1.jpg')
insert into Image values ('../../Content/images/products/pd46.2.jpg')
insert into Image values ('../../Content/images/products/pd46.3.jpg')
insert into Image values ('../../Content/images/products/pd46.4.jpg')
insert into Image values ('../../Content/images/products/pd47.1.jpg')
insert into Image values ('../../Content/images/products/pd47.2.jpg')
insert into Image values ('../../Content/images/products/pd47.3.jpg')
insert into Image values ('../../Content/images/products/pd47.4.jpg')
insert into Image values ('../../Content/images/products/pd48.1.jpg')
insert into Image values ('../../Content/images/products/pd48.2.jpg')
insert into Image values ('../../Content/images/products/pd48.3.jpg')
insert into Image values ('../../Content/images/products/pd48.4.jpg')
insert into Image values ('../../Content/images/products/pd49.1.jpg')
insert into Image values ('../../Content/images/products/pd49.2.jpg')
insert into Image values ('../../Content/images/products/pd49.3.jpg')
insert into Image values ('../../Content/images/products/pd49.4.jpg')
insert into Image values ('../../Content/images/products/pd50.1.jpg')
insert into Image values ('../../Content/images/products/pd50.2.jpg')
insert into Image values ('../../Content/images/products/pd50.3.jpg')
insert into Image values ('../../Content/images/products/pd50.4.jpg')


-- 144
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
insert into Product_Image values (12, 45)
insert into Product_Image values (12, 46)
insert into Product_Image values (12, 47)
insert into Product_Image values (12, 48)
insert into Product_Image values (13, 49)
insert into Product_Image values (13, 50)
insert into Product_Image values (13, 51)
insert into Product_Image values (13, 52)
insert into Product_Image values (14, 53)
insert into Product_Image values (14, 54)
insert into Product_Image values (14, 55)
insert into Product_Image values (14, 56)
insert into Product_Image values (15, 57)
insert into Product_Image values (15, 58)
insert into Product_Image values (15, 59)
insert into Product_Image values (15, 60)
insert into Product_Image values (16, 61)
insert into Product_Image values (16, 62)
insert into Product_Image values (16, 63)
insert into Product_Image values (16, 64)
insert into Product_Image values (17, 65)
insert into Product_Image values (17, 66)
insert into Product_Image values (17, 67)
insert into Product_Image values (17, 68)
insert into Product_Image values (18, 69)
insert into Product_Image values (18, 70)
insert into Product_Image values (18, 71)
insert into Product_Image values (18, 72)
insert into Product_Image values (19, 73)
insert into Product_Image values (19, 74)
insert into Product_Image values (19, 75)
insert into Product_Image values (19, 76)
insert into Product_Image values (20, 77)
insert into Product_Image values (20, 78)
insert into Product_Image values (20, 79)
insert into Product_Image values (20, 80)

--Product_Image_Shirt
insert into Product_Image values (21, 81)
insert into Product_Image values (21, 82)
insert into Product_Image values (21, 83)
insert into Product_Image values (21, 84)
insert into Product_Image values (22, 85)
insert into Product_Image values (22, 86)
insert into Product_Image values (22, 87)
insert into Product_Image values (22, 88)
insert into Product_Image values (23, 89)
insert into Product_Image values (23, 90)
insert into Product_Image values (23, 91)
insert into Product_Image values (23, 92)
insert into Product_Image values (24, 93)
insert into Product_Image values (24, 94)
insert into Product_Image values (24, 95)
insert into Product_Image values (24, 96)
insert into Product_Image values (25, 97)
insert into Product_Image values (25, 98)
insert into Product_Image values (25, 99)
insert into Product_Image values (25, 100)
insert into Product_Image values (26, 101)
insert into Product_Image values (26, 102)
insert into Product_Image values (26, 103)
insert into Product_Image values (26, 104)
insert into Product_Image values (27, 105)
insert into Product_Image values (27, 106)
insert into Product_Image values (27, 107)
insert into Product_Image values (27, 108)
insert into Product_Image values (28, 109)
insert into Product_Image values (28, 110)
insert into Product_Image values (28, 111)
insert into Product_Image values (28, 112)
insert into Product_Image values (29, 113)
insert into Product_Image values (29, 114)
insert into Product_Image values (29, 115)
insert into Product_Image values (29, 116)
insert into Product_Image values (30, 117)
insert into Product_Image values (30, 118)
insert into Product_Image values (30, 119)
insert into Product_Image values (30, 120)
insert into Product_Image values (31, 121)
insert into Product_Image values (31, 122)
insert into Product_Image values (31, 123)
insert into Product_Image values (31, 124)

insert into Product_Image values (32, 125)
insert into Product_Image values (32, 126)
insert into Product_Image values (32, 127)
insert into Product_Image values (32, 128)
insert into Product_Image values (33, 129)
insert into Product_Image values (33, 130)
insert into Product_Image values (33, 131)
insert into Product_Image values (33, 132)
insert into Product_Image values (34, 133)
insert into Product_Image values (34, 134)
insert into Product_Image values (34, 135)
insert into Product_Image values (34, 136)
insert into Product_Image values (35, 137)
insert into Product_Image values (35, 138)
insert into Product_Image values (35, 139)
insert into Product_Image values (35, 140)
insert into Product_Image values (36, 141)
insert into Product_Image values (36, 142)
insert into Product_Image values (36, 143)
insert into Product_Image values (36, 144)
insert into Product_Image values (37, 145)
insert into Product_Image values (37, 146)
insert into Product_Image values (37, 147)
insert into Product_Image values (37, 148)
insert into Product_Image values (38, 149)
insert into Product_Image values (38, 150)
insert into Product_Image values (38, 151)
insert into Product_Image values (38, 152)
insert into Product_Image values (39, 153)
insert into Product_Image values (39, 154)
insert into Product_Image values (39, 155)
insert into Product_Image values (39, 156)
insert into Product_Image values (40, 157)
insert into Product_Image values (40, 158)
insert into Product_Image values (40, 159)
insert into Product_Image values (40, 160)
insert into Product_Image values (41, 161)
insert into Product_Image values (41, 162)
insert into Product_Image values (42, 163)
insert into Product_Image values (42, 164)
insert into Product_Image values (42, 165)
insert into Product_Image values (42, 166)
insert into Product_Image values (43, 167)
insert into Product_Image values (43, 168)
insert into Product_Image values (43, 169)
insert into Product_Image values (43, 170)
insert into Product_Image values (44, 171)
insert into Product_Image values (44, 172)
insert into Product_Image values (44, 173)
insert into Product_Image values (44, 174)
insert into Product_Image values (45, 175)
insert into Product_Image values (45, 176)
insert into Product_Image values (45, 177)
insert into Product_Image values (46, 178)
insert into Product_Image values (46, 179)
insert into Product_Image values (46, 180)
insert into Product_Image values (46, 181)
insert into Product_Image values (46, 182)
insert into Product_Image values (47, 183)
insert into Product_Image values (47, 184)
insert into Product_Image values (47, 185)
insert into Product_Image values (47, 186)
insert into Product_Image values (48, 187)
insert into Product_Image values (48, 188)
insert into Product_Image values (48, 189)
insert into Product_Image values (48, 190)
insert into Product_Image values (48, 191)
insert into Product_Image values (49, 192)
insert into Product_Image values (49, 193)
insert into Product_Image values (49, 194)
insert into Product_Image values (50, 195)
insert into Product_Image values (50, 196)
insert into Product_Image values (50, 197)
insert into Product_Image values (50, 196)







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
insert into Tag values (200, N'Áo khoác Nam')
insert into Tag values (201, N'Sơ mi tay dài')
insert into Tag values (202, N'Áo thun cổ trụ')
insert into Tag values (203, N'Áo Thun Polo Nữ')
insert into Tag values (204, N'Áo Khoác Nam')
insert into Tag values (205, N'Áo Polo Nam')
insert into Tag values (206, N'Áo Sweater Nữ')
insert into Tag values (207, N'Áo Khoác Dù Nữ')
insert into Tag values (208, N'Áo Polo Nữ')
insert into Tag values (209, N'Áo Kiểu Nữ Sơ Mi')
insert into Tag values (210, N'Áo Sweater Nam')
insert into Tag values (13, N'Đầm Nữ')
insert into Tag values (14, N'Áo Chống Nắng Nữ')
insert into Tag values (15, N'Áo Len Nữ')
insert into Tag values (16, N'Đồ Bộ Thể Thao')
insert into Tag values (17, N'Túi Xách')
insert into Tag values (18, N'Ví')
insert into Tag values (19, N'Kính Mát')
insert into Tag values (20, N'Quần Jean Nam')
insert into Tag values (21, N'Quần Âu Nam')
insert into Tag values (22, N'Quần Short Nam')
insert into Tag values (23, N'Quần Kaki Nam')
insert into Tag values (24, N'Quần Legging Nữ')
insert into Tag values (25, N'Quần Golf Nam')
insert into Tag values (26, N'Quần Dài Unisex')


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
insert into Product_Tag values (14, 11)
insert into Product_Tag values (15, 10)
insert into Product_Tag values (16, 9)
insert into Product_Tag values (17, 10)
insert into Product_Tag values (18, 9)
insert into Product_Tag values (19, 10)
insert into Product_Tag values (20, 10)
insert into Product_Tag values (11, 10)
insert into Product_Tag values (12, 10)
insert into Product_Tag values (19, 12)
insert into Product_Tag values (15, 12)
insert into Product_Tag values (14, 12)
insert into Product_Tag values (18, 12)
insert into Product_Tag values (21, 200)
insert into Product_Tag values (22, 201)
insert into Product_Tag values (23, 202)
insert into Product_Tag values (24, 203)
insert into Product_Tag values (25, 204)
insert into Product_Tag values (26, 205)
insert into Product_Tag values (27, 206)
insert into Product_Tag values (28, 207)
insert into Product_Tag values (29, 208)
insert into Product_Tag values (30, 209)
insert into Product_Tag values (31, 210)
insert into Product_Tag values (32, 14)
insert into Product_Tag values (33, 15)
insert into Product_Tag values (34, 13)
insert into Product_Tag values (35, 16)
insert into Product_Tag values (36, 17)
insert into Product_Tag values (37, 17)
insert into Product_Tag values (38, 18)
insert into Product_Tag values (39, 19)
insert into Product_Tag values (40, 18)
insert into Product_Tag values (41, 2)
insert into Product_Tag values (42, 20)
insert into Product_Tag values (43, 21)
insert into Product_Tag values (44, 22)
insert into Product_Tag values (45, 23)
insert into Product_Tag values (46, 24)
insert into Product_Tag values (47, 26)
insert into Product_Tag values (48, 26)
insert into Product_Tag values (49, 21)
insert into Product_Tag values (50, 25)



-- Category --
-- (id, id_parent, name)
-- id_parent = 0 neu loai tong the nhat
insert into Category values (1, 0, N'Shirt')

insert into Category values (2, 0, N'Skirt')
insert into Category values (3, 0, N'Glasses')
insert into Category values (4, 0, N'Shoes')

insert into Category values (5, 0, N'Sunscreen')
insert into Category values (6, 0, N'Suit')
insert into Category values (7, 0, N'Hand bag')
insert into Category values (8, 0, N'Wallet')
insert into Category values (9, 0, N'Pants')


-- Product_Category --
-- (product_id, category_id)
insert into Product_Category values(1, 2)
insert into Product_Category values(1, 3)
insert into Product_Category values(2, 2)
insert into Product_Category values(2, 3)
insert into Product_Category values(3, 2)
insert into Product_Category values(3, 3)
insert into Product_Category values(4, 2)
insert into Product_Category values(4, 3)
insert into Product_Category values(5, 2)
insert into Product_Category values(5, 3)
insert into Product_Category values(6, 2)
insert into Product_Category values(6, 3)
insert into Product_Category values(7, 2)
insert into Product_Category values(7, 3)
insert into Product_Category values(8, 2)
insert into Product_Category values(8, 3)
insert into Product_Category values(9, 2)
insert into Product_Category values(9, 3)
insert into Product_Category values(10, 2)
insert into Product_Category values(10, 3)

insert into Product_Category values (11, 4)
insert into Product_Category values (12, 4)
insert into Product_Category values (13, 4)
insert into Product_Category values (14, 4)
insert into Product_Category values (15, 4)
insert into Product_Category values (16, 4)
insert into Product_Category values (17, 4)
insert into Product_Category values (18, 4)
insert into Product_Category values (19, 4)
insert into Product_Category values (20, 4)
insert into Product_Category values (11, 4)
insert into Product_Category values (12, 4)
insert into Product_Category values (19, 4)
insert into Product_Category values (15, 4)
insert into Product_Category values (14, 4)
insert into Product_Category values (18, 4)

insert into Product_Category values (21, 1)
insert into Product_Category values (22, 1)
insert into Product_Category values (23, 1)
insert into Product_Category values (24, 1)
insert into Product_Category values (25, 1)
insert into Product_Category values (26, 1)
insert into Product_Category values (27, 1)
insert into Product_Category values (28, 1)
insert into Product_Category values (29, 1)
insert into Product_Category values (30, 1)
insert into Product_Category values (31, 1)

insert into Product_Category values (32, 5)
insert into Product_Category values (33, 1)
insert into Product_Category values (34, 2)
insert into Product_Category values (35, 6)
insert into Product_Category values (36, 7)
insert into Product_Category values (37, 8)
insert into Product_Category values (38, 8)
insert into Product_Category values (39, 3)
insert into Product_Category values (40, 8)
insert into Product_Category values (41, 1)
insert into Product_Category values (42, 9)
insert into Product_Category values (43, 9)
insert into Product_Category values (44, 9)
insert into Product_Category values (45, 9)
insert into Product_Category values (46, 9)
insert into Product_Category values (47, 9)
insert into Product_Category values (48, 9)
insert into Product_Category values (49, 9)
insert into Product_Category values (50, 9)


-- Product_Reviewing --
insert into Product_Reviewing values(1, 1, 1, 5, N'Hàng đẹp chất lượng đúng mô tả, sẽ ủng hộ lần sau', '2023-02-12 14:56:59')

-- Voucher --
-- (voucher_id, user_id, code, discount_percentage, voucher_status, startdate, end_date)
insert into Voucher values (1, 1, '0GIAMGIA', 0, 'available', '2022-02-14 14:56:59', '2099-02-14 14:56:59');
insert into Voucher values (2, 1, 'FASHIONSHOP2', 0.1, 'available', '2022-02-14 14:56:59', '2099-02-14 14:56:59');
insert into Voucher values (3, 1, 'FASHIONSHOP3', 0.05, 'available', '2022-02-14 14:56:59', '2099-02-14 14:56:59');
insert into Voucher values (4, 1, 'FASHIONSHOP4', 0.08, 'available', '2022-02-14 14:56:59', '2099-02-14 14:56:59');

-- Orders --
-- (order_id, customer_id, order_date, original_price, reduced_price, transport_fee, total_price, voucher_id, order_status)
insert into Orders values (1110223145659, 1, '2023-02-11 14:56:59', 300000, 0, 0, 300000, 1, 'accepted')
insert into Orders values (2, 1, '2023-03-12 14:56:59', 150000, 0, 0, 150000, 1, 'accepted')

-- Order_Item --
-- (id, order_id, product_id, quantity, size, color, totalcost)
insert into Order_Item values (1110223145659, 1, 1, 1, 1, 150000)
insert into Order_Item values (1110223145659, 1, 1, 1, 2, 150000)
insert into Order_Item values (2, 1, 1, 1, 1, 150000)


-- Payment_Methods --
insert into Payment_Methods values (1, 'MoMo')
insert into Payment_Methods values (2, 'ZaloPay')
insert into Payment_Methods values (3, 'COD')

-- Payment_Detail --
-- (id, order_id, amount, payment_method, payment_status)
-- payment_status
-- 1 Chua thanh toan
-- 2 Da thanh toan
insert into Payment_Detail values (1, 1110223145659, 300000, 2, 2)
insert into Payment_Detail values (2, 2, 150000, 2, 2)

--cart
--(user_id, productid, qantity, size, color, totalprice)
insert into Cart values (1, 1, 1, 1, 1, 150000)
insert into Cart values (1, 1, 1, 1, 2, 150000)
insert into Cart values (1, 2, 2, 1, 3, 310000)
insert into Cart values (1, 3, 2, 2, 2, 210000)
insert into Cart values (1, 4, 2, 2, 5, 210000)
insert into Cart values (1, 5, 2, 2, 4, 210000)
insert into Cart values (1, 5, 2, 2, 3, 210000)
insert into Cart values (1, 6, 2, 2, 3, 210000)
