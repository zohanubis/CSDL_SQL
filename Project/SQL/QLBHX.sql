CREATE DATABASE QL_BachHoaXanh
USE QL_BachHoaXanh
--Bảng Nhà Cung Cấp 
CREATE TABLE NHACUNGCAP (
    MANCC VARCHAR(10) NOT NULL,
    TENNCC NVARCHAR(50) ,
    DIACHINCC VARCHAR(100),
    PHONE VARCHAR(20),
	CONSTRAINT PK_NHACC PRIMARY KEY (MANCC)
);
-- Bảng Sản Phẩm
CREATE TABLE SANPHAM (
    MASP VARCHAR(10) NOT NULL,
    TENSP NVARCHAR(50) ,
    GIA DECIMAL(18,0), 
    SOLUONG INT,
    MANCC VARCHAR(10) NOT NULL,
	CONSTRAINT PK_SANPHAM PRIMARY KEY (MASP)
);
-- Bảng Khách Hàng
CREATE TABLE KHACHHANG (
    MAKH VARCHAR(10) NOT NULL,
    TENKH NVARCHAR(50) ,
    DIACHIKH VARCHAR(100) ,
    PHONE VARCHAR(20) ,
	CONSTRAINT PK_KHACHHANG PRIMARY KEY (MAKH)
);
-- Bảng Hóa Đơn
CREATE TABLE HOADON (
    MAHD VARCHAR(10) NOT NULL,
    MAKH VARCHAR(10) NOT NULL,
    NGAYHD DATE,
    TONGTIEN DECIMAL(18,0),
	CONSTRAINT PK_HOADON PRIMARY KEY (MAHD)
);
--Bảng Chi Tiết Hóa Đơn
CREATE TABLE CHITIETHD (
	MASP VARCHAR(10),
    MAHD VARCHAR(10),
    SOLUONGSP INT ,
    DONGIA DECIMAL(18,0),
	CONSTRAINT PK_CHITIETHD PRIMARY KEY(MASP, MAHD)
);
--Ràng buộc khóa ngoại các bảng 
-- Bảng Nhà Cung Cấp
ALTER TABLE SANPHAM
ADD CONSTRAINT FK_SANPHAM_MANCC FOREIGN KEY (MANCC) REFERENCES NHACUNGCAP(MANCC);

-- Bảng Hóa Đơn
ALTER TABLE HOADON
ADD CONSTRAINT FK_HOADON_MAKH FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH);

-- Bảng Chi Tiết Hóa Đơn
ALTER TABLE CHITIETHD
ADD CONSTRAINT FK_CHITIETHD_MASP FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP);

ALTER TABLE CHITIETHD
ADD CONSTRAINT FK_CHITIETHD_MAHD FOREIGN KEY (MAHD) REFERENCES HOADON(MAHD);


--Ràng Buộc Toàn Vẹn
------------------------------Nhà Cung Cấp---------------------------------------------------
-- Ràng buộc mặc định để đặt giá trị mặc định là 'N/A' cho cột "DIACHINCC"
ALTER TABLE NHACUNGCAP
ADD CONSTRAINT DF_NHACUNGCAP_DIACHINCC DEFAULT 'N/A' FOR DIACHINCC;

-- Ràng buộc duy nhất để đảm bảo giá trị trong cột "MANCC" là duy nhất trên mỗi dòng dữ liệu
ALTER TABLE NHACUNGCAP
ADD CONSTRAINT UQ_NHACUNGCAP_MANCC UNIQUE (MANCC);

-- Ràng buộc kiểm tra để đảm bảo giá trị trong cột "PHONE" có đúng 10 ký tự số
ALTER TABLE NHACUNGCAP
ADD CONSTRAINT CK_NHACUNGCAP_PHONE CHECK (LEN(PHONE) = 10 AND PHONE LIKE '[0-9]%');

-- Ràng buộc kiểm tra để đảm bảo cột "TENNCC" không để trống
ALTER TABLE NHACUNGCAP
ADD CONSTRAINT CK_NHACUNGCAP_TENNCC CHECK (TENNCC <> '');
-------------------------------------------------------------------------------------
--=============================SẢN PHẨM============================================
-- Ràng buộc mặc định để đặt giá trị mặc định là 0 cho cột "SOLUONG"
ALTER TABLE SANPHAM
ADD CONSTRAINT DF_SANPHAM_SOLUONG DEFAULT 0 FOR SOLUONG;

-- Ràng buộc duy nhất để đảm bảo giá trị trong cột "MASP" là duy nhất trên mỗi dòng dữ liệu
ALTER TABLE SANPHAM
ADD CONSTRAINT UQ_SANPHAM_MASP UNIQUE (MASP);

-- Ràng buộc kiểm tra để đảm bảo giá trị trong cột "GIA" là số không âm
ALTER TABLE SANPHAM
ADD CONSTRAINT CK_SANPHAM_GIA CHECK (GIA >= 0);

-- Ràng buộc kiểm tra để đảm bảo cột "TENSP" không để trống
ALTER TABLE SANPHAM
ADD CONSTRAINT CK_SANPHAM_TENSP CHECK (TENSP <> '');
-------------------------------------------------------------------------------------
--=============================KHÁCH HÀNG============================================
-- Ràng buộc duy nhất để đảm bảo giá trị trong cột "MAKH" là duy nhất trên mỗi dòng dữ liệu
ALTER TABLE KHACHHANG
ADD CONSTRAINT UQ_KHACHHANG_MAKH UNIQUE (MAKH);

-- Ràng buộc kiểm tra để đảm bảo giá trị trong cột "PHONE" có đúng 10 ký tự số
ALTER TABLE KHACHHANG
ADD CONSTRAINT CK_KHACHHANG_PHONE CHECK (LEN(PHONE) = 10 AND PHONE LIKE '[0-9]%');

-- Ràng buộc kiểm tra để đảm bảo cột "TENKH" không để trống
ALTER TABLE KHACHHANG
ADD CONSTRAINT CK_KHACHHANG_TENKH CHECK (TENKH <> '');

-------------------------------------------------------------------------------------
--=============================HÓA ĐƠN============================================
-- Ràng buộc duy nhất để đảm bảo giá trị trong cột "MAHD" là duy nhất trên mỗi dòng dữ liệu
ALTER TABLE HOADON
ADD CONSTRAINT UQ_HOADON_MASANPHAM UNIQUE (MAHD);

-- Ràng buộc kiểm tra để đảm bảo giá trị trong cột "TONGTIEN" không âm
ALTER TABLE HOADON
ADD CONSTRAINT CK_HOADON_TONGTIEN CHECK (TONGTIEN >= 0);

-- Ràng buộc kiểm tra để đảm bảo cột "NGAYHD" không để trống
ALTER TABLE HOADON
ADD CONSTRAINT CK_HOADON_NGAYHD CHECK (NGAYHD IS NOT NULL);

-------------------------------------------------------------------------------------
--==============================CHI TIẾT HÓA ĐƠN===================================
-- Ràng buộc duy nhất để đảm bảo sự kết hợp duy nhất của cặp (MASP, MAHD)
ALTER TABLE CHITIETHD
ADD CONSTRAINT UQ_CHITIETHD_MASP_MAHD UNIQUE (MASP, MAHD);

-- Ràng buộc kiểm tra để đảm bảo giá trị trong cột "SOLUONGSP" không âm
ALTER TABLE CHITIETHD
ADD CONSTRAINT CK_CHITIETHD_SOLUONGSP CHECK (SOLUONGSP >= 0);

-- Ràng buộc kiểm tra để đảm bảo cột "DONGIA" không để trống
ALTER TABLE CHITIETHD
ADD CONSTRAINT CK_CHITIETHD_DONGIA CHECK (DONGIA IS NOT NULL);

-------------------------------------------------------------------------------------

SET DATEFORMAT DMY
-- Nhập dữ liệu 
INSERT INTO NHACC (MANCC, TENNCC, DIACHINCC, PHONE)
VALUES 
		('NCC001', N'Công ty TNHH Nước Giải Khát', N'Bình Dương', '30137752'),
		('NCC002', N'Công ty TNHH Thực Phẩm', N'TPHCM', '985331366'),
		('NCC003', N'Công Ty TNHH Hàng Tiêu Dùng', N'TPHCM', '901892899');

INSERT INTO SANPHAM (MASP, TENSP, GIA, SOLUONG, MANCC) 
VALUES
		('SP001', N'Fanta cam', 7000, 50, 'NCC001'),
		('SP002', N'Sting đỏ', 10000, 100, 'NCC001'),
		('SP003', N'Sting vàng', 10000, 100, 'NCC001'),
		('SP004', N'Cocacola', 9000, 150, 'NCC001'),
		('SP005', N'Pepsi', 8000, 100, 'NCC001'),
		('SP006', N'Trà ô long TeaPlus', 12000, 80, 'NCC001'),
		('SP007', N'Redbull', 15000, 50, 'NCC001'),
		('SP008', N'Nutriboost', 11000, 80, 'NCC001'),
		('SP009', N'Revive', 12000, 120, 'NCC001'),
		('SP010', N'Warrior', 8000, 100, 'NCC001'),
		('SP011', N'Trứng gà', 32000, 200, 'NCC002'),
		('SP012', N'Trứng vịt', 36000, 200, 'NCC002'),
		('SP013', N'Mì gói', 5000, 300, 'NCC002'),
		('SP014', N'Xúc Xích', 24000, 200, 'NCC002'),
		('SP015', N'Bánh Snack', 6000, 200, 'NCC002'),
		('SP016', N'Sữa chua', 30000, 100, 'NCC002'),
		('SP017', N'Sữa đóng hộp', 30000, 100, 'NCC002'),
		('SP018', N'Kẹo', 25000, 100, 'NCC002'),
		('SP019', N'Kem', 59000, 150, 'NCC002'),
		('SP020', N'Bộ dao 6 cái', 200000, 50, 'NCC003'),
		('SP021', N'Bộ nồi inox', 800000, 20, 'NCC003'),
		('SP022', N'Thùng rác', 150000, 100, 'NCC003'),
		('SP023', N'Bộ chén dĩa', 90000, 30, 'NCC003'),
		('SP024', N'Túi đựng', 50000, 20, 'NCC003'),
		('SP025', N'Màng bọc thực phẩm', 250000, 50, 'NCC003'),
		('SP026', N'Thau nhựa', 130000, 80, 'NCC003'),
		('SP027', N'Bình nước', 90000, 50, 'NCC003'),
		('SP028', N'Chảo chống dính', 410000, 30, 'NCC003');


INSERT INTO KHACHHANG(MAKH, TENKH, DIACHIKH, PHONE)
VALUES	('KH001', N'Phạm Hồ Đăng Huy', N'TP.HCM', '779139003'),
		('KH002', N'Nguyễn Hoàng Thái Kỳ', N'Phú Yên', '987654321'),
		('KH003', N'Nguyễn Thanh Sáng', N'TP.HCM', '912345678'),
		('KH004', N'Trần Tiến Danh', N'TP.HCM', '912984932'),
		('KH005', N'Nguyễn Văn Nam', N'Tây Ninh', '989751723'),
		('KH006', N'Nguyễn Kim Anh', N'TP.HCM', '912345654'),
		('KH007', N'Nguyễn Thị Châu', N'Vũng Tàu', '978123765'),
		('KH008', N'Trần Văn Út', N'Hà Nội', '909456768'),
		('KH009', N'Trần Lệ Quyên', N'Hà Nội', '932987567'),
		('KH010', N'Bùi Đức Chí', N'TP.HCM', '989123456')

INSERT INTO HOADON(MAHD, MAKH, NGAYHD, TONGTIEN)
VALUES ('HD001', 'KH001', '2023-04-21', 331000),
       ('HD002', 'KH002', '2023-04-21', 730000),
       ('HD003', 'KH003', '2023-04-22', 3184000),
       ('HD004', 'KH002', '2023-04-23', 526000),
       ('HD005', 'KH001', '2023-04-23', 3467000);

INSERT INTO CHITIETHD(MASP, MAHD, SOLUONGSP, DONGIA)
VALUES
		('SP001', 'HD001', 3, 21000),
		('SP003', 'HD001', 10, 100000),
		('SP016', 'HD001', 7, 210000),
		('SP009', 'HD002', 6, 72000),
		('SP020', 'HD002', 3, 600000),
		('SP015', 'HD002', 3, 18000),
		('SP013', 'HD002', 8, 40000),
		('SP013', 'HD003', 4, 20000),
		('SP014', 'HD003', 6, 144000),
		('SP024', 'HD003', 5, 250000),
		('SP028', 'HD003', 5, 2050000),
		('SP023', 'HD003', 8, 720000),
		('SP002', 'HD004', 9, 90000),
		('SP003', 'HD004', 3, 30000),
		('SP011', 'HD004', 8, 256000),
		('SP013', 'HD004', 6, 30000),
		('SP016', 'HD004', 4, 120000),
		('SP007', 'HD004', 2, 30000),
		('SP008', 'HD004', 9, 99000),
		('SP018', 'HD005', 5, 125000),
		('SP019', 'HD005', 7, 413000),
		('SP021', 'HD005', 2, 1600000),
		('SP012', 'HD005', 8, 1200000);
-- Xem bảng
		SELECT * FROM NHACC
		SELECT * FROM KHACHHANG
		SELECT * FROM SANPHAM
		SELECT * FROM HOADON
		SELECT * FROM CHITIETHD
--In ra danh sách các sản phẩm (MASP,TENSP) do Công ty TNHH Nước Giải Khát cung cấp
SELECT MASP, TENSP
FROM SANPHAM
WHERE MANCC IN (
    SELECT MANCC
    FROM NHACC
    WHERE TENNCC = N'Công ty TNHH Nước Giải Khát'
);
SELECT MASP,TENSP FROM SANPHAM WHERE MANCC = 'NCC001'
--In ra danh sách các sản phẩm (MASP, TENSP) có số lượng lớn hơn 100
SELECT MASP, TENSP
FROM SANPHAM
WHERE SOLUONG > 100;
--Tìm các số hóa đơn đã mua sản phẩm có mã số “SP001” hoặc “SP002"
SELECT MAHD FROM CHITIETHD 
WHERE MASP IN('SP001','SP002')
-- In ra danh sách các sản phẩm (MASP, TENSP) của Công ty TNHH Nước Giải Khát có giá 10000 đến 15000 
SELECT * FROM SANPHAM
SELECT MASP, TENSP, MANCC
FROM SANPHAM
WHERE MANCC IN(SELECT MANCC
    FROM NHACC
    WHERE TENNCC = N'Công ty TNHH Nước Giải Khát') AND GIA BETWEEN 10000 AND 15000
--In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “SP” và kết thúc là “01”.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE'SP%01'
-- Lồng Phân Cấp

--In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (SELECT DISTINCT TOP 3 GIA
			  FROM SANPHAM
			  ORDER BY GIA DESC)
--In ra 2 khách hàng có tổng tiền hóa đơn cao nhất
SELECT TOP 2 TENKH, TONGTIEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
ORDER BY HOADON.TONGTIEN DESC

--Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất. 
SELECT * FROM HOADON 
SELECT * FROM KHACHHANG
SELECT MAKH, TENKH
FROM KHACHHANG	
WHERE MAKH = (SELECT TOP 1 MAKH FROM HOADON GROUP BY MAKH 
								ORDER BY COUNT(DISTINCT MAHD) DESC)
--Mỗi nhà cung cấp, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT NHACC.TENNCC, SANPHAM.MASP, SANPHAM.TENSP, SANPHAM.GIA
FROM NHACC
JOIN SANPHAM ON NHACC.MANCC = SANPHAM.MANCC
WHERE SANPHAM.GIA = (
  SELECT MAX(GIA)
  FROM SANPHAM
  WHERE MANCC = NHACC.MANCC
);
--Liệt kê tên các sản phẩm được bán trong từng hóa đơn
SELECT * FROM CHITIETHD
SELECT HOADON.MAHD, CHITIETHD.MASP,SP.TENSP
FROM HOADON
INNER JOIN CHITIETHD ON HOADON.MAHD = CHITIETHD.MAHD
JOIN SANPHAM SP ON SP.MASP = CHITIETHD.MASP
ORDER BY HOADON.MAHD;

SELECT HD.MAHD, SP.TENSP, CTHD.SOLUONGSP
FROM HOADON HD
JOIN CHITIETHD CTHD ON HD.MAHD = CTHD.MAHD
JOIN SANPHAM SP ON SP.MASP = CTHD.MASP
ORDER BY HD.MAHD ASC;

SELECT SANPHAM.TENSP, NHACC.TENNCC
FROM SANPHAM
INNER JOIN NHACC ON SANPHAM.MANCC = NHACC.MANCC
INNER JOIN CHITIETHD ON SANPHAM.MASP = CHITIETHD.MASP
INNER JOIN HOADON ON CHITIETHD.MAHD = HOADON.MAHD
WHERE CHITIETHD.SOLUONGSP > 10 AND HOADON.NGAYHD = '2023-04-21';

--Tìm kiếm tên khách hàng và tổng số tiền của tất cả các hóa đơn mà khách hàng đó đã mua
SELECT KHACHHANG.TENKH, SUM(HOADON.TONGTIEN) AS TONGTIEN
FROM KHACHHANG
INNER JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
GROUP BY KHACHHANG.TENKH;
--Liệt kê tên sản phẩm và tổng số lượng sản phẩm đã bán ra của từng sản phẩm:
SELECT SANPHAM.TENSP, SUM(CHITIETHD.SOLUONGSP) AS SOLUONGBAN
FROM SANPHAM
INNER JOIN CHITIETHD ON SANPHAM.MASP = CHITIETHD.MASP
GROUP BY SANPHAM.TENSP;

--Tìm kiếm tên nhà cung cấp và tổng số tiền của các hóa đơn mà nhà cung cấp đó cung cấp sản phẩm
SELECT NHACC.TENNCC, SUM(HOADON.TONGTIEN) AS TONGTIEN
FROM NHACC
INNER JOIN SANPHAM ON NHACC.MANCC = SANPHAM.MANCC
INNER JOIN CHITIETHD ON SANPHAM.MASP = CHITIETHD.MASP
INNER JOIN HOADON ON CHITIETHD.MAHD = HOADON.MAHD
GROUP BY NHACC.TENNCC;

--Liệt kê tên khách hàng và tên sản phẩm của các sản phẩm đã mua bởi khách hàng đó
SELECT KHACHHANG.TENKH, SANPHAM.TENSP
FROM KHACHHANG
INNER JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
INNER JOIN CHITIETHD ON HOADON.MAHD = CHITIETHD.MAHD
INNER JOIN SANPHAM ON CHITIETHD.MASP = SANPHAM.MASP;

--Liệt kê tên khách hàng và số lượng hóa đơn đã mua của mỗi khách hàng. 
--Sắp xếp kết quả theo số lượng hóa đơn giảm dần
SELECT KHACHHANG.TENKH, COUNT(HOADON.MAHD) AS SOHOADON
FROM KHACHHANG
INNER JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
GROUP BY KHACHHANG.TENKH
ORDER BY SOHOADON DESC;

--Liệt kê tên sản phẩm và số lượng sản phẩm đã bán ra trong mỗi tháng của năm 2023. 
--Sắp xếp kết quả theo tháng tăng dần
SELECT SANPHAM.TENSP, MONTH(HOADON.NGAYHD) AS THANG, SUM(CHITIETHD.SOLUONGSP) AS SOLUONGBAN
FROM SANPHAM
INNER JOIN CHITIETHD ON SANPHAM.MASP = CHITIETHD.MASP
INNER JOIN HOADON ON CHITIETHD.MAHD = HOADON.MAHD
WHERE YEAR(HOADON.NGAYHD) = 2023
GROUP BY SANPHAM.TENSP, MONTH(HOADON.NGAYHD)
ORDER BY THANG ASC;
--Liệt kê tên nhà cung cấp, tên sản phẩm, số lượng sản phẩm và tổng giá trị đơn hàng của 
--các hóa đơn mà nhà cung cấp có tên là "Công ty TNHH Nước Giải Khát" đã cung cấp sản phẩm.
SELECT NHACC.TENNCC, SANPHAM.TENSP, CHITIETHD.SOLUONGSP, HOADON.TONGTIEN
FROM NHACC
JOIN SANPHAM ON NHACC.MANCC = SANPHAM.MANCC
JOIN CHITIETHD ON SANPHAM.MASP = CHITIETHD.MASP
JOIN HOADON ON CHITIETHD.MAHD = HOADON.MAHD
WHERE NHACC.TENNCC = N'Công ty TNHH Nước Giải Khát';
--Hiển thị tên các sản phẩm và số lượng sản phẩm đã bán ra cho khách hàng có địa chỉ ở thành phố "TPHCM".
SELECT * FROM KHACHHANG
SELECT SANPHAM.TENSP, SUM(CHITIETHD.SOLUONGSP) AS SOLUONGBAN
FROM SANPHAM
JOIN CHITIETHD ON SANPHAM.MASP = CHITIETHD.MASP
JOIN HOADON ON CHITIETHD.MAHD = HOADON.MAHD
JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
WHERE KHACHHANG.DIACHIKH LIKE '%TP.HCM%'
GROUP BY SANPHAM.TENSP;
--Tính tổng giá trị đơn hàng của khách hàng có tên là 
--"Phạm Hồ Đăng Huy" và ngày lập hóa đơn từ ngày "2022-04-21" đến ngày "2022-04-23"
SELECT * FROM HOADON
SELECT SUM(HOADON.TONGTIEN) AS TONGTIENHD
FROM HOADON
JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
WHERE KHACHHANG.TENKH = N'Phạm Hồ Đăng Huy' AND HOADON.NGAYHD BETWEEN '2022-04-21' AND '2022-04-23';
--Tìm tên nhà cung cấp cung cấp sản phẩm có giá trị đơn đặt hàng cao nhất trong danh sách các đơn đặt hàng
SELECT NHACC.TENNCC
FROM NHACC
JOIN SANPHAM ON NHACC.MANCC = SANPHAM.MANCC
JOIN CHITIETHD ON SANPHAM.MASP = CHITIETHD.MASP
JOIN HOADON ON CHITIETHD.MAHD = HOADON.MAHD
WHERE HOADON.TONGTIEN = (SELECT MAX(TONGTIEN) FROM HOADON);
