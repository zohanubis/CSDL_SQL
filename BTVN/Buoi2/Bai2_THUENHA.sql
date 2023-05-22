CREATE DATABASE Bai2_BTVN2
GO

USE Bai2_BTVN2
GO

CREATE TABLE LOAINHA (
	MALN VARCHAR(10) PRIMARY KEY, 
	TENLN NVARCHAR(100), 
	GHICHU NVARCHAR(100),
);
CREATE TABLE NHA (
	MANHA VARCHAR(10) PRIMARY KEY, 
	DIACHI NVARCHAR (100), 
	TIENTHUE DECIMAL (18,0), 
	MALN VARCHAR(10),
	CONSTRAINT FK_NHA_LOAINHA FOREIGN KEY (MALN) REFERENCES LOAINHA (MALN)
);
CREATE TABLE KHACHHANG (
	MAKH VARCHAR (10) PRIMARY KEY, 
	TENKH NVARCHAR (100), 
	DIACHI NVARCHAR (100), 
	DTHOAI VARCHAR(15), 
	KHANANGTHUE DECIMAL (18,0)
);
CREATE TABLE DANGTIN (
	MANHA VARCHAR(10), 
	NGAYDANG DATE,
	THOIHANDT INT,
	CONSTRAINT FK_DANGTIN_NHA FOREIGN KEY (MANHA) REFERENCES NHA(MANHA)
);
CREATE TABLE XEMNHA (
	MANHA VARCHAR(10), 
	MAKH VARCHAR (10), 
	NGAYXEMNHA DATE, 
	KETLUAN NVARCHAR(100),
	CONSTRAINT FK_XEMNHA_NHA FOREIGN KEY (MANHA) REFERENCES NHA(MANHA),
	CONSTRAINT FK_XEMNHA_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
);

INSERT INTO LOAINHA (MALN, TENLN, GHICHU) 
VALUES 
	('NC1', N'Cấp 1', NULL),
	('NC2', N'Cấp 2', NULL),
	('NC3', N'Cấp 3', NULL),
	('NC4', N'Cấp 4', NULL);
INSERT INTO NHA (MANHA, DIACHI, TIENTHUE, MALN) 
VALUES 
	('C2001', N'142 Lê Trọng Tấn, Tân Phú, TP. HCM', 10000000, (SELECT MALN FROM LOAINHA WHERE MALN = 'NC2')),
	('C3001', N'111 Bình Thới, Q11, TP. HCM', 7000000, (SELECT MALN FROM LOAINHA WHERE MALN = 'NC3')),
	('C4001', N'123 Tân Thới Nhất, Quận 12, TP. HCM', 4000000, (SELECT MALN FROM LOAINHA WHERE MALN = 'NC4')),
	('C4002', N'21 Tô Ký, Quận 12, TP. HCM', 3500000, (SELECT MALN FROM LOAINHA WHERE MALN = 'NC4'));
INSERT INTO KHACHHANG (MAKH, TENKH, DIACHI, DTHOAI, KHANANGTHUE) 
VALUES 
	('KH001', N'Trần Thanh Bình', N'123 Trương Định, Q3, TP. HCM', '0989123456', 10000000),
	('KH002', N'Trần Thị Lan', N'01 Lê Lai, Q1, TP. HCM', '0918456234', 9000000),
	('KH003', N'Lê Thành Nam', N'12 Ngô Quyền, Q5, TPP. HCM', '0909657456', 1100000048),
	('KH004', N'Nguyễn Thảo Mi', N'120 Thành Thái, Q10, TP. HCM', '0912657489', 3000000),
	('KH005', N'Lê Anh Tuấn', N'123 Trương Định, Q3, TP. HCM', '0989768567', 4000000);
SET DATEFORMAT DMY
INSERT INTO DANGTIN (MANHA, NGAYDANG, THOIHANDT) 
VALUES 
	('C2001', '01/05/2016', 7),
	('C4002', '02/05/2016', 10),
	('C4001', '04/06/2016', 30),
	('C4001', '13/06/2016', 7),
	('C3001', '12/06/2016', 7);
INSERT INTO XEMNHA (MANHA, MAKH, NGAYXEMNHA, KETLUAN) 
VALUES 
	('C2001', 'KH003', '07/05/2016', NULL),
	('C4002', 'KH002', '07/05/2016', NULL),
	('C4001', 'KH004', '05/06/2016', NULL),
	('C4001', 'KH002', '14/06/2016', NULL),
	('C3001', 'KH001', '15/06/2016', NULL);

--1. Cho biết tiền thuê của căn nhà có địa chỉ 111 Bình Thới, Q11, TP. HCM.
SELECT TIENTHUE 
FROM NHA 
WHERE DIACHI = N'111 Bình Thới, Q11, TP. HCM';
--2. Cho biết địa chỉ những căn nhà được xem vào ngày 5/6/2016.
SELECT NHA.DIACHI
FROM NHA 
INNER JOIN XEMNHA ON NHA.MANHA = XEMNHA.MANHA
WHERE XEMNHA.NGAYXEMNHA = '05/06/2016';
--3. Loại nhà cấp 4 ở Quận 12 có bao nhiêu căn?
SELECT COUNT(*) as SoCanNhaCap4
FROM NHA 
WHERE MALN = 'NC4' AND DIACHI LIKE N'%Quận 12%';
--4. Cho biết thông tin của khách hàng đã xem nhà có địa chỉ 142 Lê Trọng Tấn, Tân Phú, TP. HCM ngày 7/5/2016.
SELECT KHACHHANG.* FROM XEMNHA
JOIN KHACHHANG ON XEMNHA.MAKH = KHACHHANG.MAKH
JOIN NHA ON XEMNHA.MANHA = NHA.MANHA
WHERE NHA.DIACHI = N'142 Lê Trọng Tấn, Tân Phú, TP. HCM'
AND XEMNHA.NGAYXEMNHA = '2016-05-07';
--5. Cho biết thông tin loại nhà không có căn nhà nào cho thuê.
SELECT * FROM LOAINHA 
WHERE MALN NOT IN (SELECT MALN FROM NHA);
--6. Cho biết ngày 13/6/2016 có bao nhiêu căn nhà cấp 4 được đăng tin với giá cho thuê thấp hơn 4.000.000 đồng.
SELECT COUNT(*) as SoLuong
FROM DANGTIN dt
JOIN NHA n ON dt.MANHA = n.MANHA
WHERE n.TIENTHUE < 4000000 AND n.MALN = 'NC4' AND dt.NGAYDANG = '2016-06-13';
--7. Cho biết tổng số các căn nhà đã được thuê trong tháng 6/2016 có địa chỉ ở quận 11, TP. HCM.
SELECT COUNT(*) AS TONGSONHATHUE
FROM NHA JOIN DANGTIN ON NHA.MANHA = DANGTIN.MANHA
WHERE NHA.DIACHI LIKE '%Q11%' 
	AND MONTH(DANGTIN.NGAYDANG) = 6 
	AND YEAR(DANGTIN.NGAYDANG) = 2016;

