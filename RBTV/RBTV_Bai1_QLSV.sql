CREATE DATABASE Bai1_QLSV_RBTV
GO

USE Bai1_QLSV_RBTV
GO

CREATE TABLE KHOA(
    MAKH VARCHAR(10) NOT NULL , 
    TENKH NVARCHAR(100)
    CONSTRAINT PK_KHOA PRIMARY KEY (MAKH)
);
CREATE TABLE LOP(
    MALOP VARCHAR(10)NOT NULL , 
    TENLOP NVARCHAR(100),
    SISO INT, 
    LOPTRUONG VARCHAR(10), 
    MAKH VARCHAR(10),
    CONSTRAINT PK_LOP PRIMARY KEY (MALOP),
    CONSTRAINT FK_LOP_KHOA FOREIGN KEY (MAKH) REFERENCES KHOA (MAKH)
);
CREATE TABLE SINHVIEN(
    MASV VARCHAR(10) NOT NULL, 
    HOTEN NVARCHAR(100), 
    NGSINH DATE, 
    GTINH NVARCHAR(5),
    DCHI NVARCHAR(100),
    MALOP VARCHAR(10), 
    CONSTRAINT PK_SINHVIEN PRIMARY KEY (MASV),
    CONSTRAINT FK_SINHVIEN_LOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
);
CREATE TABLE GIANGVIEN(
    MAGV VARCHAR(10) NOT NULL, 
    TENGV NVARCHAR(100),     
    MAKH VARCHAR(10),
    CONSTRAINT PK_GIANGVIEN PRIMARY KEY (MAGV),
    CONSTRAINT FK_GIANGVIEN_KHOA FOREIGN KEY (MAKH) REFERENCES KHOA (MAKH)

);
CREATE TABLE MONHOC(
    MAMH VARCHAR(10) NOT NULL,
    TENMH NVARCHAR(100), 
    SOTC INT,
    CONSTRAINT PK_MONHOC PRIMARY KEY (MAMH)
);
CREATE TABLE DIEM(
    MASV VARCHAR(10), 
    MAMH VARCHAR(10), 
    LANTHI INT, 
    DIEMTHI INT,
    CONSTRAINT FK_DIEM_SINHVIEN FOREIGN KEY (MASV) REFERENCES SINHVIEN(MASV),
    CONSTRAINT FK_DIEM_MONHOC FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);
CREATE TABLE GIANGDAY(
    MAGV VARCHAR(10), 
    MAMH VARCHAR(10), 
    NAMHOC VARCHAR(10), 
    HOCKY INT
    CONSTRAINT FK_GIANGDAY_GIANGVIEN FOREIGN KEY (MAGV) REFERENCES GIANGVIEN (MAGV),
    CONSTRAINT FK_GIANGDAY_MONHOC FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);
CREATE TABLE THANNHAN(
    MATN VARCHAR(10) NOT NULL, 
    HOTEN NVARCHAR(100), 
    GIOITINH NVARCHAR(100),
    CONSTRAINT PK_THANNHAN  PRIMARY KEY (MATN)
);
CREATE TABLE QUANHE(
    MATN VARCHAR(10) ,
    MASV VARCHAR(10) ,
    QUANHE NVARCHAR(100),
    CONSTRAINT FK_QUANHE_THANNHAN FOREIGN KEY (MATN) REFERENCES THANNHAN(MATN),
    CONSTRAINT FK_QUANHE_SINHVIEN FOREIGN KEY (MASV) REFERENCES SINHVIEN (MASV)
);
--1. Dùng Check Constraint viết tất cả các ràng buộc miền giá trị có trong cơ sở dữ liệu trên.
ALTER TABLE KHOA
ADD CONSTRAINT CHK_TENKH CHECK (LEN(TENKH) <= 100);
ALTER TABLE LOP
ADD CONSTRAINT CHK_TENLOP CHECK (LEN(TENLOP) <= 100);
ALTER TABLE MONHOC
ADD CONSTRAINT CHK_TENMH CHECK (LEN(TENMH) <= 100);

--2. Dùng Unique Constraint viết ràng buộc kiểm tra duy nhất cho các cột TENKH,TENLOP, TENMH.
ALTER TABLE KHOA
ADD CONSTRAINT UQ_TENKH UNIQUE (TENKH);
--Hợp lệ
INSERT INTO KHOA (MAKH, TENKH) VALUES ('KH001', N'Hóa Học');
--Không hợp lệ
INSERT INTO LOP (MALOP, TENLOP, SISO, LOPTRUONG, MAKH) VALUES ('LH001', N'10 Đại học Sinh học 1', 55, 'SV008', 'SH');
ALTER TABLE LOP
ADD CONSTRAINT UQ_TENLOP UNIQUE (TENLOP);
--Hợp lệ
INSERT INTO LOP (MALOP, TENLOP, SISO, LOPTRUONG, MAKH) VALUES ('LH005', N'10 Đại học Sinh học 4', 60, 'SV007', 'TP');
--Không hợp lệ
INSERT INTO LOP (MALOP, TENLOP, SISO, LOPTRUONG, MAKH) VALUES ('LH003', N'10 Đại học Sinh học 1', 60, 'SV007', 'TP');
INSERT INTO LOP (MALOP, TENLOP, SISO, LOPTRUONG, MAKH) VALUES ('LH002', N'10 Đại học Tin học 1', 50, 'SV001', 'TH');
ALTER TABLE MONHOC
ADD CONSTRAINT UQ_TENMH UNIQUE (TENMH);

--3. Dùng Default Constraint viết các ràng buộc giá trị mặc định cho các cột như sau:
--LOPTRUONG có giá trị mặc định là Chua xac dinh, SOTC mặc định là 3.
ALTER TABLE LOP
ADD CONSTRAINT DF_LOPTRUONG DEFAULT N'Chưa xác định' FOR LOPTRUONG;
--Hợp lệ
-- Chèn dữ liệu vào bảng LOP với giá trị mặc định cho cột LOPTRUONG
INSERT INTO LOP (MALOP, TENLOP, SISO, MAKH) 
VALUES ('13DHTH1', N'Lớp Đại học Tin học 1', 30, 'TH');

-- Chèn dữ liệu vào bảng LOP với giá trị cụ thể cho cột LOPTRUONG
INSERT INTO LOP (MALOP, TENLOP, SISO, LOPTRUONG, MAKH) 
VALUES ('14DHTH1', N'Lớp Đại học Tin học 2', 25, 'SV012', 'TH');

--Không hợp lệ
-- Chèn dữ liệu vào bảng LOP với giá trị không hợp lệ cho cột LOPTRUONG
INSERT INTO LOP (MALOP, TENLOP, SISO, LOPTRUONG, MAKH) 
VALUES ('15DHTH1', N'Lớp Đại học Tin học 3', 35, 'SinhVien001', 'TH');

ALTER TABLE MONHOC
ADD CONSTRAINT DF_SOTC DEFAULT 3 FOR SOTC;
--Hợp lệ
INSERT INTO MONHOC (MAMH, TENMH,SOTC) VALUES ('MH001', N'Cơ Sở Dữ Liệu','');
--Không hợp lệ
INSERT INTO MONHOC (MAMH, TENMH, SOTC) VALUES ('MH003', N'Tin học văn phòng', 2);
SELECT * FROM MONHOC
--4. Viết trigger kiểm tra mỗi sinh viên chỉ được thi tối đa 3 lần cho mỗi môn học. drop trigger <Tên_trigger>
CREATE TRIGGER TRG_KIEMTRA_SINHVIEN
ON DIEM
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (	
        SELECT MASV, MAMH
        FROM DIEM
        WHERE LANTHI > 3
        GROUP BY MASV, MAMH
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR (N'Mỗi sinh viên chỉ được thi tối đa 3 lần trong 1 môn!', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
CREATE TRIGGER TRG_KIEMTRA_SINHVIEN ON DIEM
FOR INSERT AS
	BEGIN
		IF((SELECT COUNT(*) FROM DIEM D, inserted I
			WHERE D.MAMH  =I.MAMH AND D.MASV= I.MASV
			GROUP BY D.MASV, D.MAMH)< 4)
			COMMIT TRAN
		ELSE
			PRINT N'Mỗi sinh viên chỉ được thi tối đa 3 lần trong 1 môn!'
			ROLLBACK TRAN
		END
--Hợp lệ
-- Sinh viên SV001 chỉ thi 3 lần môn CSDL
INSERT INTO DIEM (MASV, MAMH, LANTHI, DIEMTHI)
VALUES ('SV001', 'CSDL', 2, 8),
       ('SV001', 'CSDL', 3, 7),
       ('SV001', 'CSDL', 4, 6);
INSERT INTO DIEM (MASV, MAMH, LANTHI, DIEMTHI)
VALUES
       ('SV002', 'THVP', 3, 8),
       ('SV002', 'THVP', 4, 9);

--5. Viết trigger thực hiện cập nhật sĩ số SISO trên bảng LOP mỗi khi thêm, xóa hay sửa dữ liệu trên bảng SINHVIEN.
CREATE TRIGGER TRG_CAPNHAT_SISO
ON SINHVIEN
FOR INSERT, DELETE,UPDATE
AS
BEGIN
    UPDATE LOP
    SET SISO = SISO +1 
    WHERE  LOP.MALOP=(SELECT LOP.MALOP FROM inserted)
	UPDATE LOP
    SET SISO = SISO -1 
    WHERE  LOP.MALOP=(SELECT LOP.MALOP FROM deleted)
END

-- Thêm dữ liệu vào bảng SINHVIEN
INSERT INTO SINHVIEN (MASV, HOTEN, NGSINH, GTINH, DCHI, MALOP)
VALUES ('SV012', 'Nguyen Van A', '2000-01-01', N'Nam', N'TPHCM', '10DHSH1');
SELECT * FROM SINHVIEN
SELECT * FROM KHOA
SELECT * FROM LOP

-- Xóa trigger TRG_CAPNHAT_SISO
DROP TRIGGER TRG_CAPNHAT_SISO;

DELETE FROM SINHVIEN WHERE MASV = 'SV012';

SELECT COUNT(*) AS SISO FROM SINHVIEN WHERE MALOP = '10DHSH1';

UPDATE LOP SET SISO = '55' WHERE MALOP = '10DHSH1';


--NHẬP LIỆU 
INSERT INTO KHOA (MAKH, TENKH)
VALUES
    ('SH', N'Công nghệ sinh học'),
    ('TH', N'Công nghệ thông tin'),
    ('TP', N'Công nghệ thực phẩm'),
    ('QT', N'Quản trị kinh doanh'),
    ('TC', N'Tài chính kế toán');
INSERT INTO LOP (MALOP, TENLOP, SISO, LOPTRUONG,MAKH)
VALUES	('10DHSH1',N'10 Đại học Sinh học 1',55,'SV008','SH'),
		('10DHTH1',N'10 Đại học Tin học 1',50,'SV001','TH'),
		('11DHTH2',N'11 Đại học Tin học 2',40,'SV005','TH'),
		('12DHTC1',N'12 Đại học Tài chính 1',75,'SV009','TC'),
		('12DHTP1',N'12 Đại học Thực phẩm',60,'SV007','TP');	
INSERT INTO GIANGVIEN (MAGV, TENGV, MAKH)
VALUES
    ('GV001', N'Phạm Thế Bảo', 'TH'),
    ('GV002', N'Lê Thể Truyền', 'TH'),
    ('GV003', N'Trương Anh Dũng', 'SH'),
    ('GV004', N'Bùi Chí Anh', 'TC'),
    ('GV005', N'Lê Công Hậu', 'QT'),
    ('GV006', N'Lê Trung Thành', 'TP');
INSERT INTO MONHOC (MAMH, TENMH, SOTC)
VALUES
    ('CSDL', N'Cơ Sở Dữ Liệu', 3),
    ('KTLT', N'Kỹ thuật lập trình', 3),
    ('THVP', N'Tin học văn phòng', 3),
    ('TRR', N'Toán rời rạc', 3),
    ('TTNT', N'Trí tuệ nhân tạo', 2),
    ('TTQT', N'Thanh toán quốc tế', 2);	
INSERT INTO SINHVIEN (MASV, HOTEN, NGSINH, GTINH, DCHI, MALOP)
VALUES
	('SV001', N'Trần Lệ Quyên', '1995-01-21', N'Nữ', N'TPHCM', '10DHTH1'),
    ('SV002', N'Nguyễn Thế Bình', '1996-06-04', N'Nam', N'Tây Ninh', '11DHTH2'),
    ('SV003', N'Tô Ánh Nguyệt', '1995-05-02', N'Nữ', N'Vũng Tàu', '12DHTP1'),
    ('SV004', N'Nguyễn Thế Anh', '1996-12-15', N'Nam', N'Đồng Nai', '12DHTP1'),
    ('SV005', N'Lê Thanh Bình', '1994-12-09', N'Nam', N'Long Anh', '10DHTH1'),
    ('SV006', N'Phạm Quang Hậu', '1995-10-12', N'Nam', N'Tây Ninh', '10DHTH1'),
    ('SV007', N'Lê Cẩm Tú', '1989-02-13', N'Nữ', N'Bình Thuận', '12DHTP1'),
    ('SV008', N'Trương Thế Sang', '1993-04-04', N'Nam', N'Bình Dương', '10DHSH1'),
    ('SV009', N'Đậu Quang Ánh', '1994-12-03', N'Nam', N'Long An', '12DHTC1'),
    ('SV010', N'Huỳnh Kim Chi', '1996-10-18', N'Nữ', N'TPHCM', '11DHTH2'),
    ('SV011', N'Trịnh Đình Ánh', '1995-11-15', N'Nam', N'Bình Thuận', '10DHTH1');
INSERT INTO DIEM (MASV, MAMH, LANTHI, DIEMTHI)
VALUES
    ('SV001', 'CSDL', 1, 9),
    ('SV002', 'THVP', 1, 3),
    ('SV002', 'THVP', 2, 7),
    ('SV004', 'THVP', 1, 6),
    ('SV004', 'TTQT', 1, 5),
    ('SV005', 'CSDL', 1, 3),
    ('SV005', 'CSDL', 2, 6),
    ('SV006', 'KTLT', 1, 4),
    ('SV009', 'TTQT', 1, 4),
    ('SV010', 'THVP', 1, 8),
    ('SV010', 'TRR', 1, 7);
INSERT INTO GIANGDAY (MAGV, MAMH, NAMHOC, HOCKY)
VALUES
    ('GV001', 'CSDL', '2021-2022', 1),
    ('GV001', 'KTLT', '2020-2021', 2),
    ('GV001', 'TTNT', '2020-2021', 1),
    ('GV002', 'CSDL', '2021-2022', 2),
    ('GV002', 'KTLT', '2021-2022', 2);
INSERT INTO THANNHAN (MATN, HOTEN, GIOITINH)
VALUES
    ('TN001', N'Nguyễn Thế Thành', 'Nam'),
    ('TN002', N'Tô Ánh Hồng', N'Nữ'),
    ('TN003', N'Lê Thanh An', 'Nam'),
    ('TN004', N'Phạm Thanh Tiền', N'Nữ'),
    ('TN006', N'Đậu Văn Thanh', 'Nam'),
    ('TN007', N'Nguyễn Thi Ánh', N'Nữ'),
    ('TN008', N'Lê Quang Định', 'Nam'),
    ('TN009', N'Huỳnh Văn Tư', 'Nam');
INSERT INTO QUANHE (MATN, MASV, QUANHE)
VALUES
    ('TN001', 'SV002', N'Bố'),
    ('TN003', 'SV005', N'Bố'),
    ('TN004', 'SV007', N'Mẹ'),
    ('TN006', 'SV009', N'Bố'),
    ('TN007', 'SV002', N'Mẹ'),
    ('TN008', 'SV005', N'Bố'),
    ('TN008', 'SV007', N'Bố');
-- Truy vấn

--2. Cập nhật địa chỉ của sinh viên có mã số SV002 là ‘CẦN THƠ’.
SELECT * FROM SINHVIEN
UPDATE SINHVIEN
SET DCHI = N'CẦN THƠ'
WHERE MASV = 'SV002';
--3. Tạo bảng ảo lưu trữ danh sách sinh viên (Mã SV, họ tên), tên lớp tương ứng của sinh viên.
SELECT SINHVIEN.MASV, SINHVIEN.HOTEN, LOP.TENLOP AS DANHSACHSINHVIEN
FROM SINHVIEN
JOIN LOP ON SINHVIEN.MALOP = LOP.MALOP;
--4. Liệt kê danh sách sinh viên (Mã SV, Họ tên) của những sinh viên có địa chỉ ở Vũng Tàu.
SELECT MASV, HOTEN
FROM SINHVIEN
WHERE DCHI = N'Vũng Tàu';
--5. Cho biết số tín chỉ của môn Toán rời rạc?
SELECT SOTC
FROM MONHOC
WHERE TENMH = N'Toán rời rạc';
--6. Cho biết danh sách các lớp (Tên lớp) thuộc khoa Công nghệ Thông tin?
SELECT TENLOP
FROM LOP
JOIN KHOA ON LOP.MAKH = KHOA.MAKH
WHERE TENKH = N'Công nghệ Thông tin';
--7.Cho biết danh sách sinh viên (Mã SV, họ tên) của những sinh viên nam có họ “Nguyễn”?
SELECT MASV, HOTEN
FROM SINHVIEN
WHERE GTINH = N'Nam' AND HOTEN LIKE N'Nguyễn%';
--8. Cho biết họ tên, ngày sinh, địa chỉ của những sinh viên nam học lớp 10DHTH1?
SELECT MASV, HOTEN, DCHI
FROM SINHVIEN
WHERE GTINH = N'Nam' AND MALOP = '10DHTH1'
--9. Cho biết tên những môn học có 1 hoặc 2 tín chỉ?
SELECT TENMH
FROM MONHOC
WHERE SOTC IN (1, 2);
--10. Cho biết họ tên, địa chỉ những sinh viên nữ thuộc khoa Công nghệ Thông tin?
SELECT SINHVIEN.HOTEN, SINHVIEN.DCHI
FROM SINHVIEN
JOIN LOP ON SINHVIEN.MALOP = LOP.MALOP
JOIN KHOA ON LOP.MAKH = KHOA.MAKH
WHERE KHOA.TENKH = N'Công nghệ Thông tin' AND SINHVIEN.GTINH = N'Nữ';
--11. Cho biết tên những sinh viên nữ có địa chỉ ở TP. HCM hoặc Vũng Tàu?
SELECT HOTEN FROM SINHVIEN 
WHERE GTINH = N'Nữ' AND (DCHI ='TPHCM' OR DCHI = N'Vũng Tàu')
--12. Cho biết họ tên những sinh viên lớp 10DHTH1 có điểm thi trong khoảng từ 6 đến 8?	
--SELECT SINHVIEN.HOTEN
--FROM SINHVIEN
--JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV
--JOIN LOP ON SINHVIEN.MALOP = LOP.MALOP
--WHERE LOP.TENLOP = '10DHTH1' AND DIEM.DIEMTHI BETWEEN 6 AND 8;
SELECT HOTEN
FROM SINHVIEN
WHERE MALOP = '10DHTH1'
  AND MASV IN (
    SELECT MASV
    FROM DIEM
    WHERE DIEMTHI BETWEEN 6 AND 8
  );

--13. Cho biết những sinh viên khoa Công nghệ Thông tin học môn CSDL có điểm thi lớn hơn 5? !

SELECT SINHVIEN.HOTEN
FROM SINHVIEN
JOIN LOP ON SINHVIEN.MALOP = LOP.MALOP
JOIN KHOA ON LOP.MAKH = KHOA.MAKH
JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV
JOIN MONHOC ON DIEM.MAMH = MONHOC.MAMH
WHERE KHOA.TENKH = N'Công nghệ Thông tin'
  AND MONHOC.TENMH = N'Cơ Sở Dữ Liệu'
  AND DIEMTHI > 5

--14. Liệt kê danh sách tên khoa và số lượng lớp trong từng khoa.
SELECT KHOA.TENKH, COUNT(LOP.MALOP) AS SoLuongLop
FROM KHOA
LEFT JOIN LOP ON KHOA.MAKH = LOP.MAKH
GROUP BY KHOA.TENKH;
--15. Liệt kê danh sách tên lớp và số lượng sinh viên trong từng lớp.
SELECT LOP.TENLOP, COUNT(SINHVIEN.MASV) AS SoLuongSinhVien
FROM LOP
LEFT JOIN SINHVIEN ON LOP.MALOP = SINHVIEN.MALOP
GROUP BY LOP.TENLOP;
--16. Liệt kê danh sách tên khoa và số lượng sinh viên trong từng khoa. Sắp xếp các khoa theo thứ tự số lượng sinh viên tăng dần.
SELECT KHOA.TENKH, COUNT(SINHVIEN.MASV) AS SoLuongSinhVien
FROM KHOA
LEFT JOIN LOP ON KHOA.MAKH = LOP.MAKH
LEFT JOIN SINHVIEN ON LOP.MALOP = SINHVIEN.MALOP
GROUP BY KHOA.TENKH
ORDER BY SoLuongSinhVien ASC;
--17. Liệt kê mã sinh viên, họ tên và điểm trung bình của từng sinh viên.
SELECT SINHVIEN.MASV, SINHVIEN.HOTEN, AVG(DIEM.DIEMTHI) AS DiemTrungBinh
FROM SINHVIEN
LEFT JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV
GROUP BY SINHVIEN.MASV, SINHVIEN.HOTEN;
--18. Cho biết họ tên và tổng số môn học của từng sinh viên nam đã học.
SELECT SINHVIEN.HOTEN, COUNT(DISTINCT MONHOC.MAMH) AS TongSoMonHoc
FROM SINHVIEN
JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV
JOIN MONHOC ON DIEM.MAMH = MONHOC.MAMH
WHERE SINHVIEN.GTINH = N'Nam'
GROUP BY SINHVIEN.HOTEN;
--19. Cho biết những khoa có ít nhất 2 lớp?
SELECT KHOA.TENKH
FROM KHOA
JOIN LOP ON KHOA.MAKH = LOP.MAKH
GROUP BY KHOA.TENKH
HAVING COUNT(LOP.MALOP) >= 2;
--20. Cho biết những lớp có ít nhất 2 sinh viên?
SELECT LOP.TENLOP
FROM LOP
JOIN SINHVIEN ON LOP.MALOP = SINHVIEN.MALOP
GROUP BY LOP.TENLOP
HAVING COUNT(SINHVIEN.MASV) >= 2;
--21. Cho biết danh sách các khoa (TENKHOA) có số lượng sinh viên dưới 500 người.
SELECT KHOA.TENKH
FROM KHOA
JOIN LOP ON KHOA.MAKH = LOP.MAKH
JOIN SINHVIEN ON LOP.MALOP = SINHVIEN.MALOP
GROUP BY KHOA.TENKH
HAVING COUNT(SINHVIEN.MASV) < 500;
--22. Cho biết tên những môn học có số tín chỉ lớn hơn 1 và có ít nhất 2 sinh viên đăng ký học?
SELECT TENMH
FROM MONHOC
JOIN DIEM ON MONHOC.MAMH = DIEM.MAMH
GROUP BY TENMH
HAVING COUNT(DISTINCT DIEM.MASV) >= 2 AND SUM(MONHOC.SOTC) > 1;
--23. Cho biết tên những môn học có số tín chỉ lớn nhất và số tín chỉ tương ứng?
SELECT TENMH, SOTC
FROM MONHOC
WHERE SOTC = ( 
  SELECT MAX(SOTC)
  FROM MONHOC
);
--24. Kết hợp thông tin sinh viên và thông tin thân nhân thành một tập kết quả (dùng toán tử Union).
SELECT MASV AS ID, HOTEN AS Ten, N'Sinh viên' AS Loai
FROM SINHVIEN
UNION
SELECT MATN AS ID, HOTEN AS Ten, N'Thân nhân' AS Loai
FROM THANNHAN;
--25. Cho biết thông tin sinh viên lớp 12DHTP1 (dùng Inner join)? !
SELECT SINHVIEN.MASV, SINHVIEN.HOTEN, SINHVIEN.NGSINH, SINHVIEN.GTINH, SINHVIEN.DCHI
FROM SINHVIEN
INNER JOIN LOP ON SINHVIEN.MALOP = LOP.MALOP
WHERE LOP.TENLOP = '12DHTP1';
--26. Tìm tất cả những sinh viên không có điểm môn học nào (Dùng Left join)?
SELECT SINHVIEN.MASV, SINHVIEN.HOTEN
FROM SINHVIEN
LEFT JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV
WHERE DIEM.MASV IS NULL;
--27. Cho biết tên sinh viên và mã tất cả các môn học cùng với điểm số của môn học
--đó mà sinh viên đã tham gia học (tham gia học là có điểm thi) (Dùng right join)?
SELECT SINHVIEN.HOTEN, DIEM.MAMH, DIEM.DIEMTHI
FROM SINHVIEN
RIGHT JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV;
