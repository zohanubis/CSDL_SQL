--Phần 3
CREATE DATABASE Bai1_THCSDL
GO
USE Bai1_THCSDL
GO

CREATE TABLE TACGIA
(
	MATG VARCHAR(10),
	TENTG NVARCHAR(100),
	DIACHI NVARCHAR(100),
	CONSTRAINT PK_TACGIA PRIMARY KEY (MATG)
);

CREATE TABLE LOAISACH(
	MALOAI VARCHAR(10),
	TENLOAI NVARCHAR(100),
	CONSTRAINT PK_LOAISACH PRIMARY KEY (MALOAI)
);
CREATE TABLE NHAXUATBAN(
	MANXB VARCHAR(10),
	TENNXB NVARCHAR(100),
	DCNXB NVARCHAR(100),
	DTNXB VARCHAR(20),
	CONSTRAINT PK_NHAXUATBAN PRIMARY KEY (MANXB)
);
CREATE TABLE SACH(
	MASH VARCHAR(10),
	TENSH NVARCHAR(100),
	NAMXB VARCHAR(5),
	MANXB VARCHAR(10),
	MATG VARCHAR(10),
	MALOAI VARCHAR(10),
	CONSTRAINT PK_SACH PRIMARY KEY (MASH),
	CONSTRAINT FK_SACH_NHAXUATBAN FOREIGN KEY (MANXB) REFERENCES NHAXUATBAN(MANXB),
	CONSTRAINT FK_SACH_TACGIA FOREIGN KEY (MATG) REFERENCES TACGIA(MATG),
	CONSTRAINT FK_SACH_LOAISACH FOREIGN KEY (MALOAI) REFERENCES LOAISACH(MALOAI)
);
CREATE TABLE DOCGIA
(
	MADG VARCHAR(10),
	TENDG NVARCHAR(100),
	NGAYSINH DATE,
	GIOITINH VARCHAR(5),
	LIENHE VARCHAR(20),
	CONSTRAINT PK_DOCGIA PRIMARY KEY (MADG)
);

CREATE TABLE MUONTRASACH(
	MADG VARCHAR(10),
	MASH VARCHAR(10),
	NGAYMUON DATE,
	NGAYTRA DATE,
	CONSTRAINT FK_MUONTRASACH_DOCGIA FOREIGN KEY (MADG) REFERENCES DOCGIA(MADG),
	CONSTRAINT FK_MUONTRASACH_SACH FOREIGN KEY (MASH) REFERENCES SACH(MASH)
);

ALTER TABLE TACGIA
ADD CONSTRAINT CHK_TACGIA_MATG
CHECK (LEN(MATG) <= 10);

ALTER TABLE LOAISACH
ADD CONSTRAINT CHK_LOAISACH_MALOAI
CHECK (LEN(MALOAI) <= 10);

ALTER TABLE NHAXUATBAN
ADD CONSTRAINT CHK_NHAXUATBAN_MANXB
CHECK (LEN(MANXB) <= 10);

ALTER TABLE SACH
ADD CONSTRAINT CHK_SACH_MASH
CHECK (LEN(MASH) <= 10);

ALTER TABLE DOCGIA
ADD CONSTRAINT CHK_DOCGIA_MADG
CHECK (LEN(MADG) <= 10);
--------------------------------------------------
ALTER TABLE NHAXUATBAN
ADD CONSTRAINT UQ_NHAXUATBAN_TENNXB
UNIQUE (TENNXB);
---------------------------------------
ALTER TABLE LOAISACH
ADD CONSTRAINT UQ_LOAISACH_TENLOAI
UNIQUE (TENLOAI);
------------------------------
ALTER TABLE MUONTRASACH
ADD CONSTRAINT DF_MUONTRASACH_NGAYTRA
DEFAULT NULL FOR NGAYTRA;
----------------------------------
CREATE TRIGGER TRG_MUONTRASACH_NGAYMUON
ON MUONTRASACH
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE NGAYMUON > NGAYTRA)
    BEGIN
        RAISERROR ('Ngày mượn nhỏ hơn ngày trả sách', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
--------------------------------------------------
CREATE TRIGGER TRG_DOCGIA_TUOI
ON DOCGIA
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (
            SELECT * 
            FROM inserted
            WHERE DATEDIFF(YEAR, NGAYSINH, GETDATE()) < 18
        )
        BEGIN
            RAISERROR ('Tuổi độc giả phải lớn hơn hoặc bằng 18.', 16, 1);
            ROLLBACK TRANSACTION;
        END;
    END;
END;

