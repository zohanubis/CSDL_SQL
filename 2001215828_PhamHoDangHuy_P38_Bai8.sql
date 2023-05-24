CREATE DATABASE QL_PHONGTRAO_Bai8

USE QL_PHONGTRAO_Bai8

CREATE TABLE PHONG(
	MAPH VARCHAR(10) NOT NULL,
	TENPHONG NVARCHAR(10), 
	MANQL VARCHAR(10)
	CONSTRAINT PK_PHONG PRIMARY KEY (MAPH)
);
CREATE TABLE NHANVIEN(
	MANV VARCHAR(10) NOT NULL,
	HOTEN NVARCHAR(100), 
	NGAYSINH DATE,
	PHAI NVARCHAR(5),
	MAPH VARCHAR(10),
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (MANV),
	CONSTRAINT FK_NHANVIEN_PHONG FOREIGN KEY (MAPH) REFERENCES PHONG(MAPH)
);
CREATE TABLE TROCHOI(
	MATC VARCHAR(10) NOT NULL,
	TENTROCHOI NVARCHAR(100),
	NGAYCHOI DATE,
	SOLUONGDK INT,
	CONSTRAINT PK_TROCHOI PRIMARY KEY (MATC)
);
CREATE TABLE DANGKY(
	MANV VARCHAR(10),
	MATC VARCHAR(10),
	CONSTRAINT FK_DANGKY_NHANVIEN FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV),
	CONSTRAINT FK_DANGKY_TROCHOI FOREIGN KEY (MATC) REFERENCES TROCHOI(MATC)
);
--Nhập liệu
INSERT INTO PHONG (MAPH, TENPHONG, MANQL)
VALUES ('P1', N'Tài Chính', 'NQL1'),
       ('P2', N'Kế Toán', 'NQL2'),
       ('P3', N'Nhân Sự', 'NQL1');
INSERT INTO NHANVIEN (MANV, HOTEN, NGAYSINH, PHAI, MAPH)
VALUES  
	('NV1', N'Nguyễn Văn Nam', '1990-01-01', N'Nam', 'P1'),
       ('NV2', N'Nguyễn Kim Ánh', '1985-05-10', N'Nữ', 'P1'),
       ('NV3', N'Nguyễn Thị Châu', '1995-03-15', N'Nam', 'P2'),
       ('NV4', N'Trần Văn Út', '1992-07-20', N'Nữ', 'P2'),
       ('NV5', N'Bùi Đức Chí', '1988-11-30', N'Nam', 'P3'),
       ('NV6', N'Trần Lệ Quyên', '1993-09-05', N'Nữ', 'P3'),
       ('NV7', N'Trần Minh Tú', '1998-06-25', N'Nam', 'P1'),
       ('NV8', N'Trần Khánh An', '1991-04-12', N'Nữ', 'P1'),
       ('NV9', N'Lê Văn Toàn', '1997-02-18', N'Nam', 'P2'),
       ('NV10', N'Nguyễn Ngọc Phan', '1994-08-08', N'Nữ', 'P3'),
	   ('NV11', N'Nguyễn Thành Nam', '1970-01-01', N'Nam', 'P1');


INSERT INTO TROCHOI (MATC, TENTROCHOI, NGAYCHOI, SOLUONGDK)
VALUES ('TC6', N'Trò chơi 6', '2023-05-01', 0),
		('TC1', N'Trò chơi 1', '2023-01-10', 3),
       ('TC2', N'Trò chơi 2', '2023-02-15', 5),
       ('TC3', N'Trò chơi 3', '2023-03-20', 4),
       ('TC4', N'Trò chơi 4', '2023-04-25', 2),
       ('TC5', N'Trò chơi 5', '2023-05-01', 6);

INSERT INTO DANGKY (MANV, MATC)
VALUES ('NV1', 'TC2'),
		('NV1', 'TC1'),
       ('NV2', 'TC1'),
       ('NV3', 'TC1'),
       ('NV4', 'TC2'),
       ('NV5', 'TC2'),
       ('NV6', 'TC3'),
       ('NV7', 'TC3'),
       ('NV8', 'TC4'),
       ('NV9', 'TC4'),
       ('NV10', 'TC5');
--1. Cho biết danh sách nhân viên (MANV, HOTEN) của phòng ban có tên : N'Tài Chính' và có tuổi >= 50
SELECT * FROM NHANVIEN
SELECT NV.MANV, NV.HOTEN
FROM NHANVIEN NV
INNER JOIN PHONG P ON NV.MAPH = P.MAPH
WHERE P.TENPHONG = N'Tài Chính' AND DATEDIFF(YEAR, NV.NGAYSINH, GETDATE()) >= 50;
--2. Cho biết danh sách nhân vien (MANV, HOTEN) tham gia từ 2 trò chơi trở lên
SELECT NV.MANV, NV.HOTEN
FROM NHANVIEN NV
INNER JOIN DANGKY DK ON NV.MANV = DK.MANV
GROUP BY NV.MANV, NV.HOTEN
HAVING COUNT(DISTINCT DK.MATC) >= 2;
--3. Cho biết danh sách trò chơi (MATC, TENTROCHOI) mà không có nhân viên nào đăng kí\
SELECT * FROM TROCHOI
SELECT TC.MATC, TC.TENTROCHOI
FROM TROCHOI TC
LEFT JOIN DANGKY DK ON TC.MATC = DK.MATC
WHERE DK.MANV IS NULL;
