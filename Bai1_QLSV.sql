CREATE DATABASE Bai1_QLSV
GO

USE Bai1_QLSV
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
    MAKH VARCHAR(10) NOT NULL,
    CONSTRAINT PK_LOP PRIMARY KEY (MALOP),
    CONSTRAINT FK_LOP_KHOA FOREIGN KEY (MAKH) REFERENCES KHOA (MAKH)
);
CREATE TABLE SINHVIEN(
    MASV VARCHAR(10) NOT NULL, 
    HOTEN NVARCHAR(100), 
    NGSINH DATE, 
    GTINH NVARCHAR(5),
    DCHI NVARCHAR(100),
    MALOP VARCHAR(10) NOT NULL, 
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
    MASV VARCHAR(10) NOT NULL, 
    MAMH VARCHAR(10) NOT NULL, 
    LANTHI INT, 
    DIEMTHI INT,
    CONSTRAINT FK_DIEM_SINHVIEN FOREIGN KEY (MASV) REFERENCES SINHVIEN(MASV),
    CONSTRAINT FK_DIEM_MONHOC FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);
CREATE TABLE GIANGDAY(
    MAGV VARCHAR(10) NOT NULL, 
    MAMH VARCHAR(10) NOT NULL, 
    NAMHOC VARCHAR(10), 
    HOCKY INT
    CONSTRAINT PK_GIANGDAY  PRIMARY KEY (MAGV),
    CONSTRAINT FK_GIANGDAY_MONHOC FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);
CREATE TABLE THANNHAN(
    MATN VARCHAR(10) NOT NULL, 
    HOTEN NVARCHAR(100), 
    GIOITINH NVARCHAR(100),
    CONSTRAINT PK_THANNHAN  PRIMARY KEY (MATN)
);
CREATE TABLE QUANHE(
    MATN VARCHAR(10) NOT NULL,
    MASV VARCHAR(10) NOT NULL,
    QUANHE NVARCHAR(100),
    CONSTRAINT FK_QUANHE_THANNHAN FOREIGN KEY (MATN) REFERENCES THANNHAN(MATN),
    CONSTRAINT FK_QUANHE_SINHVIEN FOREIGN KEY (MASV) REFERENCES SINHVIEN (MASV)
);

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
		('10DHTH2',N'11 Đại học Tin học 2',40,'SV005','TH'),
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