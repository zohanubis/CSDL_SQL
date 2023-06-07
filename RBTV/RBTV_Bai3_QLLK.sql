CREATE DATABASE RBTV_Bai3_QLLK

USE RBTV_Bai3_QLLK


CREATE TABLE LOAILK(
    MALOAI VARCHAR(10) PRIMARY KEY NOT NULL, 
    TENLOAI NVARCHAR(100)
)
CREATE TABLE LINHKIEN(
	MALK VARCHAR(10) PRIMARY KEY NOT NULL,
    TENLK NVARCHAR(100) ,
    NGAYSX DATE, 
    TGBH INT,
    MALOAI VARCHAR(10), 
    NSX VARCHAR(10), 
    DVT NVARCHAR(10)
)
CREATE TABLE KHACHHANG(
    MAKH VARCHAR(10) PRIMARY KEY NOT NULL, 
    TENKH NVARCHAR(100), 
    DCHI NVARCHAR(100), 
    DTHOAI VARCHAR(15)
)
CREATE TABLE HOADON(
	MAHD VARCHAR(10) PRIMARY KEY NOT NULL,
    NGAYHD DATE,
    MAKH VARCHAR(10), 
    TONGTIEN DECIMAL(18,0),
    CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY  (MAKH) REFERENCES KHACHHANG (MAKH)
)
CREATE TABLE CHITIETHD(
	MAHD VARCHAR(10),
    MALK VARCHAR(10), 
    SOLUONG INT, 
    DONGIA DECIMAL(18,0),
	CONSTRAINT PK_CHITIETHD PRIMARY KEY( MAHD,MALK),
    CONSTRAINT FK_CHITIETHD_LINHKIEN FOREIGN KEY (MALK) REFERENCES LINHKIEN(MALK),
    CONSTRAINT FK_CHITIETHD_HOADON FOREIGN KEY (MAHD) REFERENCES HOADON(MAHD)
)
--RÀNG BUỘC TOÀN VẸN
ALTER TABLE LINHKIEN
ADD CONSTRAINT CHK_LINHKIEN_NGAYSX
CHECK (NGAYSX <= GETDATE());

ALTER TABLE LINHKIEN
ADD CONSTRAINT UQ_LINHKIEN_TENLK
UNIQUE (TENLK);

ALTER TABLE LOAILK
ADD CONSTRAINT UQ_LOAILK_TENLOAI
UNIQUE (TENLOAI);

ALTER TABLE KHACHHANG
ADD CONSTRAINT DF_KHACHHANG_DIACHI
DEFAULT N'Không Xác Định' FOR DCHI;

ALTER TABLE LINHKIEN
ADD CONSTRAINT DF_LINHKIEN_TGBH
DEFAULT 12 FOR TGBH;


CREATE TRIGGER TRG_LINHKIEN_NGAYSX
ON LINHKIEN
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE NGAYSX > GETDATE())
    BEGIN
        RAISERROR ('Ngày sản xuất phải nhỏ hơn ngày hiện tại.', 16, 1)
        ROLLBACK TRANSACTION
    END
END;

CREATE TRIGGER TRG_CHITIETHD_UPDATE_TONGTIEN
ON CHITIETHD
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF (EXISTS(SELECT * FROM inserted) OR EXISTS(SELECT * FROM deleted))
    BEGIN
        UPDATE HOADON
        SET TONGTIEN = (SELECT SUM(SOLUONG * DONGIA) FROM CHITIETHD WHERE CHITIETHD.MAHD = HOADON.MAHD)
        FROM HOADON
        INNER JOIN inserted ON HOADON.MAHD = inserted.MAHD
        INNER JOIN deleted ON HOADON.MAHD = deleted.MAHD
    END
END;

--Nhập dữ liệu
INSERT INTO LOAILK (MALOAI, TENLOAI)
VALUES
  ('MOU', N'Chuột'),
  ('LAP', N'Máy tính xách tay'),
  ('CPU', N'Bộ xử lý'),
  ('PCX', N'Máy tính để bàn'),
  ('MAI', N'Mainboard');

 INSERT INTO LINHKIEN (MALK, TENLK, NGAYSX, TGBH, MALOAI, NSX, DVT)
VALUES
  ('MOU001', N'Chuột quang có dây', '2014-01-01', 12, 'MOU', 'Genius', N'Cái'),
  ('MOU002', N'Chuột quang không dây', '2015-02-04', 12, 'MOU', 'Mitsumi', N'Cái'),
  ('MOU003', N'Chuột không dây', '2014-04-02', 24, 'MOU', 'Abroad', N'Cái'),
  ('CPU001', N'CPU ADM', '2015-04-05', 24, 'CPU', 'Abroad', N'Cái'),
  ('CPU002', N'CPU INTEL', '2016-02-07', 36, 'CPU', 'Mitsumi', N'Cái'),
  ('CPU003', N'CPU ASUS', '2015-12-08', 36, 'CPU', 'Abroad', 'Cái'),
  ('MAI001', N'Mainboard ASUS', '2015-12-04', 36, 'MAI', 'Mitsumi', N'Cái'),
  ('MAI002', N'Mainboard ATXX', '2016-03-03', 12, 'MAI', 'Mitsumi', N'Cái'),
  ('MAI003', N'Mainboard ACER', '2015-04-14', 12, 'MAI', 'Genius', N'Cái'),
  ('PCX001', N'Acer 20144', '2015-10-19', 12, 'PCX', 'Acer', N'Bộ');

INSERT INTO KHACHHANG (MAKH, TENKH, DCHI, DTHOAI)
VALUES
  ('KH001', N'Nguyễn Thu Tâm', N'Tây Ninh', '0989751723'),
  ('KH002', N'Đinh Bảo Lộc', N'Lâm Đồng', '091823465444'),
  ('KH003', N'Trần Thanh Diệu', N'TP. HCM', '0978123765'),
  ('KH004', N'Hồ Tuấn Thành', N'Hà Nội', '0909456768'),
  ('KH005', N'Huỳnh Kim Ánh', N'Khánh Hòa', '0932987567');
SET DATEFORMAT DMY
INSERT INTO HOADON (MAHD, NGAYHD, MAKH, TONGTIEN)
VALUES
  ('HD001', '01/04/2015', 'KH001', NULL),
  ('HD002', '15/05/2016', 'KH005', NULL),
  ('HD003', '14/06/2016', 'KH004', NULL),
  ('HD004', '03/06/2016', 'KH005', NULL),
  ('HD005', '05/06/2016', 'KH001', NULL),
  ('HD006', '07/07/2016', 'KH003', NULL),
  ('HD007', '12/08/2016', 'KH002', NULL),
  ('HD008', '25/09/2016', 'KH003', NULL);

INSERT INTO CHITIETHD (MAHD, MALK, SOLUONG, DONGIA)
VALUES
  ('HD001', 'MOU001', 2, 1000000),
  ('HD002', 'MOU002', 1, 2000000),
  ('HD003', 'MOU003', 6, 3000000),
  ('HD004', 'CPU001', 5, 500000),
  ('HD005', 'CPU002', 6, 560000),
  ('HD006', 'CPU003', 3, 400000),
  ('HD006', 'MAI001', 1, 200000),
  ('HD007', 'MAI002', 1, 150000),
  ('HD007', 'MAI003', 2, 160000),
  ('HD007', 'MOU001', 1, 1000000),
  ('HD008', 'CPU001', 2, 500000);

SELECT * FROM HOADON
SELECT * FROM CHITIETHD
--UPDATE Tổng Tiền trên mỗi hóa đơn
UPDATE HOADON
SET TONGTIEN = (
    SELECT SUM(CHITIETHD.SOLUONG * CHITIETHD.DONGIA)
    FROM CHITIETHD
    WHERE CHITIETHD.MAHD = HOADON.MAHD
)
--2. Cho biết tên những linh kiện được sản xuất bởi nhà sản xuất Genius và có đơn vị tính là Cái.
SELECT TENLK
FROM LINHKIEN
WHERE NSX = 'Genius' AND DVT = N'Cái'
--3. Cho biết thông tin những linh kiện có thời gian bảo hành là 24 tháng.
SELECT *
FROM LINHKIEN
WHERE TGBH = 24
--4. Hoá đơn nào được lập trong tháng 06/2016?
SELECT *
FROM HOADON
WHERE MONTH(NGAYHD) = 6 AND YEAR(NGAYHD) = 2016
--5. Tên và đơn vị tính của các linh kiện có đơn giá lớn hơn 1.000.000 VND.
SELECT LK.TENLK, LK.DVT
FROM LINHKIEN LK
INNER JOIN CHITIETHD CT ON LK.MALK = CT.MALK
WHERE CT.DONGIA > 1000000
--6. Thông tin những linh kiện (MALK, TENLK, NSX, DVT) được bán ra trước ngày 31/05/2015.
SELECT LK.MALK, LK.TENLK, LK.NSX, LK.DVT
FROM LINHKIEN LK
INNER JOIN CHITIETHD CT ON LK.MALK = CT.MALK
INNER JOIN HOADON HD ON CT.MAHD = HD.MAHD
WHERE HD.NGAYHD < '2015-05-31'
--7. Cho biết danh sách những khách hàng mua linh kiện trong tháng 06/2016 có địa chỉ ở TP. HCM.(Chưa thêm dữ liệu)
SELECT KH.*FROM KHACHHANG KH
INNER JOIN HOADON HD ON KH.MAKH = HD.MAKH
INNER JOIN CHITIETHD CT ON HD.MAHD = CT.MAHD
INNER JOIN LINHKIEN LK ON CT.MALK = LK.MALK
WHERE HD.NGAYHD >= '2016-06-01' AND HD.NGAYHD <= '2016-06-30'
  AND KH.DCHI LIKE '%TP. HCM%'
--8. Cho biết tổng số lượng linh kiện trong hoá đơn HD007.
SELECT SUM(CT.SOLUONG) AS TONG_SOLUONG
FROM CHITIETHD CT
WHERE CT.MAHD = 'HD007'
--9. Trong tháng 05/2016 có bao nhiêu khách hàng ở Tây Ninh đến mua hàng? (Chưa thêm dữ liệu)
SELECT COUNT(DISTINCT KH.MAKH) AS SOKHACHHANG
FROM KHACHHANG KH
INNER JOIN HOADON HD ON KH.MAKH = HD.MAKH
WHERE HD.NGAYHD >= '2016-05-01' AND HD.NGAYHD <= '2016-05-31'
  AND KH.DCHI LIKE '%Tây Ninh%'
--10.Cho biết số điện thoại và địa chỉ của khách hàng có mã KH001.
SELECT DTHOAI, DCHI
FROM KHACHHANG
WHERE MAKH = 'KH001'
--11.Trong tháng 05/2016 đã lập bao nhiêu đơn hàng?
SELECT COUNT(*) AS SoDonHang
FROM HOADON
WHERE NGAYHD >= '2016-05-01' AND NGAYHD <= '2016-05-31'
--12.Tổng tiền của hoá đơn HD006 là bao nhiêu?
SELECT TONGTIEN
FROM HOADON
WHERE MAHD = 'HD006'
--13.Tổng tiền của 2 hoá đơn HD005 và HD007 là bao nhiêu?
SELECT SUM(TONGTIEN) AS TongTien
FROM HOADON
WHERE MAHD IN ('HD005', 'HD007')	
--14.Liệt kê mã hoá đơn và số linh kiện khác nhau trong từng hoá đơn.
SELECT MAHD, COUNT(DISTINCT MALK) AS SoLinhKienKhacNhau
FROM CHITIETHD
GROUP BY MAHD
--15.Cho biết tên nhà sản xuất và số linh kiện đã bán của từng nhà sản xuất.
SELECT LK.NSX, COUNT(CHI.MALK) AS SoLinhKienDaBan
FROM LINHKIEN LK
LEFT JOIN CHITIETHD CHI ON LK.MALK = CHI.MALK
GROUP BY LK.NSX
--16.Liệt kê mã hoá đơn và tổng tiền của từng hoá đơn.
SELECT MAHD, TONGTIEN
FROM HOADON
--17. Lập danh sách bao gồm tên khách hàng và mã hoá đơn có tổng tiền lớn hơn 10.000.000 VND.
SELECT KH.TENKH, HD.MAHD
FROM HOADON HD
INNER JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
WHERE HD.TONGTIEN > 10000000
--18. Mỗi loại linh kiện có bao nhiêu linh kiện.
SELECT MALOAI, COUNT(*) AS SoLuongLinhKien
FROM LINHKIEN
GROUP BY MALOAI

--19. Những hoá đơn nào (MAHD) có số linh kiện lớn hơn 10? (Chưa thêm dữ liệu)	
SELECT MAHD
FROM CHITIETHD
GROUP BY MAHD
HAVING COUNT(*) > 10
--20. Cho biết trị giá của những hoá đơn được lập ngày 07/07/2016.
SELECT TONGTIEN
FROM HOADON
WHERE NGAYHD = '2016-07-07'
--21. Cho biết tên và số lượng của từng mặt hàng trong hoá đơn HD007
SELECT LK.TENLK, CT.SOLUONG
FROM CHITIETHD CT
JOIN LINHKIEN LK ON CT.MALK = LK.MALK
WHERE CT.MAHD = 'HD007'