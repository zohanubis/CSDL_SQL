CREATE DATABASE QL_BANHANG

USE QL_BANHANG

CREATE TABLE KHACHHANG(
	MAKH VARCHAR(10) PRIMARY KEY NOT NULL,
	HOTEN NVARCHAR(100),
	NGAYSINH DATE,
	DIACHI NVARCHAR(100),
	DIENTHOAI VARCHAR(15)
);
CREATE TABLE MATHANG(
	MAMH VARCHAR(10) PRIMARY KEY NOT NULL,
	TENMH NVARCHAR(100), 
	DVT NVARCHAR(100),
	NUOCSX NVARCHAR(100)
);
CREATE TABLE HOADON(
	SOHD VARCHAR(10) PRIMARY KEY NOT NULL,
	NGAYLAPHD DATE, 
	NGAYGIAODK DATE,
	MAKH VARCHAR(10),
	CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)	
);
CREATE TABLE CTHOADON(
	SOHD VARCHAR(10),
	MAMH VARCHAR(10),
	SOLUONG INT,
	DONGIA DECIMAL(18,0),
	CONSTRAINT FK_CTHOADON_HOADON FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD),
	CONSTRAINT FK_CTHOADON_MATHANG FOREIGN KEY (MAMH) REFERENCES MATHANG(MAMH)
);
--Nhập liệu
INSERT INTO KHACHHANG (MAKH, HOTEN, NGAYSINH, DIACHI, DIENTHOAI)
VALUES ('KH001',N'Nguyễn Hoàng Thái Kỳ', '1990-01-15', N'Hà Nội', '0123456789'),
       ('KH002', N'Nguyễn Thanh Sáng', '1985-05-10', N'Hồ Chí Minh', '0987654321'),
       ('KH003',N'Phạm Hồ Đăng Huy', '1995-08-20', N'Đà Nẵng', '0369876543');

INSERT INTO MATHANG (MAMH, TENMH, DVT, NUOCSX)
VALUES ('MH001', N'Bánh mì', 'Cái', N'Việt Nam'),
       ('MH002', N'Xúc xích', 'Cái', N'Hàn Quốc'),
       ('MH003', N'Hạt nêm', 'Gói', N'Việt Nam'),
       ('MH004', N'Sting', 'Chai', N'Nhật Bản'),
       ('MH005', N'Sữa đặc', 'Hộp', N'Hàn Quốc'),
       ('MH006', N'Đường', 'Kg', N'Việt Nam'),
       ('MH007', N'Chảo', 'Cái', N'Nhật Bản'),
       ('MH008', N'Bột ngọt', 'Gói', N'Hàn Quốc'),
       ('MH009', N'Nước mắm', 'Chai', N'Việt Nam'),
       ('MH010', N'Cá mồi', 'Hộp', N'Nhật Bản');
INSERT INTO HOADON (SOHD, NGAYLAPHD, NGAYGIAODK, MAKH)
VALUES ('HD001', '2022-06-10', '2022-06-15', 'KH001'),
       ('HD002', '2022-06-12', '2022-06-18', 'KH002'),
       ('HD003', '2022-06-20', '2022-06-25', 'KH003'),
       ('HD004', '2022-06-22', '2022-06-27', 'KH001'),
       ('HD005', '2022-06-25', '2022-06-30', 'KH002');
INSERT INTO CTHOADON (SOHD, MAMH, SOLUONG, DONGIA)
VALUES ('HD001', 'MH001', 2, 15000),
       ('HD001', 'MH002', 1, 25000),
       ('HD002', 'MH002', 3, 25000),
       ('HD003', 'MH001', 5, 15000),
       ('HD003', 'MH003', 2, 12000),
       ('HD004', 'MH005', 4, 30000),
       ('HD004', 'MH006', 3, 20000),
       ('HD005', 'MH004', 1, 35000),
       ('HD005', 'MH010', 2, 40000),
       ('HD005', 'MH009', 3, 18000);

--1.Liệt kê danh sách mặt hành không được sản xuất ở Việt Nam, MAMH, TENMH
SELECT MAMH, TENMH
FROM MATHANG
WHERE NUOCSX <> N'Việt Nam';
--2.Cho biết các khách hàng có mua hàng trong tháng 6 năm 2022(NGAYLAPHD từ 01/06/2022 đến 30/06/2022), thông tin gồm
-- MAKH, HOTEN, DIACHI, DIENTHOAI, NGAYLAPHD
SELECT KHACHHANG.MAKH, HOTEN, DIACHI, DIENTHOAI, NGAYLAPHD
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
WHERE NGAYLAPHD BETWEEN '2022-06-01' AND '2022-06-30';
--3. Hiện thị danh sách mặt hàng(MAMH, TENMH) và số lượng hóa đơn có bán mặt hàng đó. Lưu ý: mặt hàng nào chưa bán thì hiện thị số lượng là 0
SELECT MATHANG.MAMH, TENMH, COUNT(SOHD) AS SOLUONG_HOADON
FROM MATHANG
LEFT JOIN CTHOADON ON MATHANG.MAMH = CTHOADON.MAMH
GROUP BY MATHANG.MAMH, TENMH;
--4. Cho biết mặt hàng(MAMH, TENMH) nào có tổng số lượng bán nhiều nhất
SELECT MATHANG.MAMH, TENMH
FROM MATHANG
JOIN CTHOADON ON MATHANG.MAMH = CTHOADON.MAMH
GROUP BY MATHANG.MAMH, TENMH
ORDER BY SUM(SOLUONG) DESC

