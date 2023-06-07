CREATE DATABASE Bai3_BTVN2
GO

USE Bai3_BTVN2
GO

CREATE TABLE LOAICC (
	MALCC VARCHAR(10) PRIMARY KEY, 
	TENLCC NVARCHAR(100),
);
CREATE TABLE CHUNGCHI (
	MACC VARCHAR(10) PRIMARY KEY, 
	TENCC NVARCHAR(100), 
	THOIGIANHOC INT, 
	MALCC VARCHAR(10),
	CONSTRAINT FK_CHUNGCHI_LOAICC FOREIGN KEY (MALCC) REFERENCES LOAICC(MALCC)
);
CREATE TABLE HOCVIEN (
	MAHV VARCHAR(10) PRIMARY KEY, 
	HOTEN NVARCHAR(100), 
	NGAYSINH DATE, 
	GIOITINH NVARCHAR(10), 
	DIACHI NVARCHAR(100)
);
CREATE TABLE LOPHOC (
	MALH VARCHAR(10) PRIMARY KEY, 
	TENLH NVARCHAR(100), 
	NGAYBD DATE, 
	NGAYKT DATE, 
	MACC VARCHAR(10), 
	HOCPHI DECIMAL(18,0),
	CONSTRAINT FK_LOPHOC_CHUNGCHI FOREIGN KEY (MACC) REFERENCES CHUNGCHI(MACC)
);
CREATE TABLE DANGKY (
	MAHV VARCHAR (10), 
	MALH VARCHAR (10), 
	NGAYDK DATE,
	TIENDATCOC DECIMAL (18,0), 
	TIENCONLAI DECIMAL (18,0), 
	CONSTRAINT PK_DANGKY PRIMARY KEY (MAHV, MALH),
	CONSTRAINT FK_DANGKY_HOCVIEN FOREIGN KEY (MAHV) REFERENCES HOCVIEN (MAHV),
	CONSTRAINT FK_DANGKY_LOPHOC FOREIGN KEY (MALH) REFERENCES LOPHOC (MALH)
);

-- Ràng buộc miền giá trị cho cột THOIGIANHOC trong bảng CHUNGCHI
ALTER TABLE CHUNGCHI
ADD CONSTRAINT CHK_CHUNGCHI_THOIGIANHOC
CHECK (THOIGIANHOC IN (2, 4, 6, 3, 5, 7));

-- Ràng buộc kiểm tra duy nhất cho cột TENLCC trong bảng LOAICC
ALTER TABLE LOAICC
ADD CONSTRAINT UK_LOAICC_TENLCC
UNIQUE (TENLCC);

-- Ràng buộc kiểm tra duy nhất cho cột TENCC trong bảng CHUNGCHI
ALTER TABLE CHUNGCHI
ADD CONSTRAINT UK_CHUNGCHI_TENCC
UNIQUE (TENCC);

-- Ràng buộc giá trị mặc định cho cột TIENCONLAI trong bảng DANGKY
ALTER TABLE DANGKY
ADD CONSTRAINT DF_DANGKY_TIENCONLAI
DEFAULT 0 FOR TIENCONLAI;

-- Trigger kiểm tra học phí trong bảng LOPHOC
CREATE TRIGGER TRG_LOPHOC_HOCPHI
ON LOPHOC
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM inserted
        WHERE HOCPHI <= 0
    )
    BEGIN
        RAISERROR ('Hoc phi phai lon hon 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

-- Trigger kiểm tra tiền đặt cọc trong bảng DANGKY
CREATE TRIGGER TRG_DANGKY_TIENDATCOC
ON DANGKY
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT d.MAHV, d.MALH, l.HOCPHI
        FROM inserted AS d
        INNER JOIN LOPHOC AS l ON d.MALH = l.MALH
        WHERE d.TIENDATCOC < l.HOCPHI * 0.5
    )
    BEGIN
        RAISERROR ('Tien dat coc phai lon hon hoac bang 50%% tien hoc phi.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

INSERT INTO LOAICC (MALCC, TENLCC)
VALUES 
    ('CCA', N'Chứng chỉ A'),
    ('CCB', N'Chứng chỉ B'),
    ('CAD', N'Chứng chỉ AutoCad');
INSERT INTO CHUNGCHI (MACC, TENCC, THOIGIANHOC, MALCC)
VALUES ('CCA1', N'Chứng chỉ A hạng 1', 5, 'CCA'),
       ('CCA2', N'Chứng chỉ A hạng 2', 6, 'CCA'),
       ('CCB1', N'Chứng chỉ B hạng 1', 6, 'CCB'),
       ('CCB2', N'Chứng chỉ B hạng 2', 8, 'CCB'),
       ('CAD1', N'Chứng chỉ AutoCad', 9, 'CAD');
INSERT INTO HOCVIEN (MAHV, HOTEN, NGAYSINH, GIOITINH, DIACHI)
VALUES	('HV001', N'Trần Thanh Bình', '1998-12-04', N'Nữ', N'123, Trương Định, Q3, TP. HCM.'),
		('HV002', N'Trần Thị Lan', '1997-01-12', N'Nữ', N'1, Paster, Q3, TP. HCM'),
		('HV003', N'Lê Thành Nam', '1999-06-23', N'Nam', N'12, Ngô Quyền, Q5, TP. HCM'),
		('HV004', N'Nguyễn Thảo Mi', '1987-02-12', N'Nữ', N'120, Thành Thái, Q10, TP. HCM');
INSERT INTO LOPHOC (MALH, TENLH, NGAYBD, NGAYKT, MACC, HOCPHI)
VALUES	('CCA101', N'Chứng chỉ A 2,4,6', '2016-04-25', '2016-05-30', 'CCA1', 500000),
		('CCA202', N'Chứng chỉ A 3,5,7', '2016-04-26', '2016-06-15', 'CCA2', 600000),
		('CCB101', N'Chứng chỉ B 2,4,6', '2016-07-07', '2016-08-20', 'CCB1', 650000),
		('CCB201', N'Chứng chỉ B 3,5,7', '2016-07-08', '2016-09-10', 'CCB2', 700000);
INSERT INTO DANGKY (MAHV, MALH, NGAYDK, TIENDATCOC, TIENCONLAI)
VALUES	('HV001', 'CCA101', '2016-04-24', 500000, 0),
		('HV002', 'CCA202', '2016-04-26', 600000, 0),
		('HV003', 'CCB101', '2016-07-07', 500000, 150000),
		('HV004', 'CCB201', '2016-07-08', 500000, 200000);
--1. Cho biết ngày bắt đầu và kết thúc của lớp có mã là CCA202.
SELECT NGAYBD, NGAYKT FROM LOPHOC WHERE MALH = 'CCA202'
--2. Cho biết thời gian học của lớp CCB101.
SELECT THOIGIANHOC
FROM CHUNGCHI
WHERE MACC = 'CCB1';
--3. Lớp CCA101 có bao nhiêu học viên nữ có địa chỉ ở TP.HCM?
SELECT COUNT(*) AS SoHVNu FROM DANGKY
INNER JOIN HOCVIEN ON HOCVIEN.MAHV = DANGKY.MAHV
WHERE HOCVIEN.GIOITINH = N'Nữ' 
	AND HOCVIEN.DIACHI LIKE N'%TP. HCM%'
	AND DANGKY.MALH = 'CCA101'
--4. Những lớp nào có số tiền học phí cao nhất? Thông tin liệt kê gồm: MALH,TENLH, NGAYBD.
SELECT TOP 1 MALH, TENLH, NGAYBD 
FROM LOPHOC 
ORDER BY HOCPHI DESC 
--5. Cho biết thông tin của những học viên đăng ký học lớp Chứng chỉ A ngày 24/4/2016.
SELECT HV.MAHV, HV.HOTEN, HV.NGAYSINH, HV.GIOITINH, HV.DIACHI
FROM HOCVIEN HV
INNER JOIN DANGKY DK ON HV.MAHV = DK.MAHV
INNER JOIN LOPHOC LH ON DK.MALH = LH.MALH
INNER JOIN CHUNGCHI CC ON LH.MACC = CC.MACC
WHERE CC.TENCC = N'Chứng chỉ A' AND DK.NGAYDK = '2016-04-24'
--6. Cho biết có bao nhiêu học viên đăng ký lớp chứng chỉ A 2, 4, 6 có ngày bắt đầu là 25/4/2016.
SELECT COUNT(*) AS SoLuongHocVien
FROM HOCVIEN HV
INNER JOIN DANGKY DK ON HV.MAHV = DK.MAHV
INNER JOIN LOPHOC LH ON DK.MALH = LH.MALH
INNER JOIN CHUNGCHI CC ON LH.MACC = CC.MACC
WHERE CC.TENCC = N'Chứng chỉ A'
AND LH.TENLH = N'Chứng chỉ A 2,4,6'AND LH.NGAYBD = '2016-04-25'

--7. Học viên Lê Thành Nam đã đăng ký học mấy lớp chứng chỉ trong năm 2016. Cho biết thông tin của những lớp mà học viên này tham gia: Mã lớp, thời gian học,học phí.
SELECT LH.MALH, LH.NGAYBD, LH.NGAYKT, LH.HOCPHI
FROM HOCVIEN HV
INNER JOIN DANGKY DK ON HV.MAHV = DK.MAHV
INNER JOIN LOPHOC LH ON DK.MALH = LH.MALH
WHERE HV.HOTEN = N'Lê Thành Nam' AND YEAR(DK.NGAYDK) = 2016s