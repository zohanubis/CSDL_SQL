CREATE DATABASE QL_KHAMBENH
GO

USE QL_KHAMBENH

CREATE TABLE BENHNHAN(
    MABN VARCHAR(10) NOT NULL,
    TENBN NVARCHAR(50),
    TUOI INT,
    SDT NVARCHAR(15),
    CONSTRAINT PK_BENHNHAN PRIMARY KEY (MABN)
);
CREATE TABLE BACSI(
    MABS VARCHAR(10) NOT NULL,
    TENBS NVARCHAR(50),
    KHOA NVARCHAR(50),
    SDT VARCHAR(15),
    CONSTRAINT PK_BACSI PRIMARY KEY (MABS)
);
CREATE TABLE KHAMBENH (
    MABN VARCHAR(10) NOT NULL,
    MABS VARCHAR(10) NOT NULL,
    NGAYKHAM DATA,
    CONSTRAINT PK_KHAMBENH PRIMARY KEY (MABN,MABS),
    CONSTRAINT FK_KHAMBENH_BENHNHAN FOREIGN KEY (MABN) REFERENCES BENHNHAN(MABN),
    CONSTRAINT FK_KHAMBENH_BACSI FOREIGN KEY (MABS) REFERENCES BACSI(MABS)
);
CREATE TABLE TOATHUOC (
    MATT VARCHAR(10) NOT NULL,
    MABN VARCHAR(10) NOT NULL,
    MABS VARCHAR(10) NOT NULL,
    TENTHUOC NVARCHAR(50),
    SOLUONG INT, DONGIA DECIMAL(18,0),
    CONSTRAINT PK_TOATHUOC PRIMARY KEY(MATT),
    CONSTRAINT FK_TOATHUOC_BENHNHAN FOREIGN KEY (MABN) REFERENCES BENHNHAN(MABN),
    CONSTRAINT FK_TOATHUOC_BACSI FOREIGN KEY (MABS) REFERENCES BACSI(MABS)
);
------------------RÀNG BUỘC TOÀN VẸN------------------
--a. Ràng buộc kiểm tra giá trị mặc định "Chưa xác định" cho thuộc tính số điện thoại trên quan hệ BACSI
ALTER TABLE BACSI
ADD CONSTRAINT DF_BACSI_SDT DEFAULT N'Chưa xác định' FOR SDT;
--b. Ràng buộc kiểm tra thuộc tính KHOA trên quan hệ BACSI chỉ nhận 1 trong 2 giá trị: Khoa nội hoặc Khoa ngoại
ALTER TABLE BACSI
ADD CONSTRAINT CK_BACSI_KHOA CHECK (KHOA IN (N'Khoa nội', N'Khoa ngoại'));
--c. Trigger viết ràng buộc kiểm tra khi thêm một phiếu khám thì ngày khám phải sau ngày hiện tại
CREATE TRIGGER TRG_KHAMBENH_NgayKham
ON KHAMBENH
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE NGAYKHAM <= GETDATE())
    BEGIN
        RAISERROR('Ngày khám phải sau ngày hiện tại.', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
--d. Trigger viết ràng buộc kiểm tra khi thêm một toa thuốc thì đơn giá phải lớn hơn 0
CREATE TRIGGER TRG_TOATHUOC_DonGia
ON TOATHUOC
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE DONGIA <= 0)
    BEGIN
        RAISERROR('Đơn giá phải lớn hơn 0.', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
---------------------------TRUY VẤN-------------------------
--a. Danh sách các bệnh nhân khám bệnh vào ngày 09-06-2023 (MABN, TENBN)
SELECT B.MABN, B.TENBN
FROM KHAMBENH K
JOIN BENHNHAN B ON K.MABN = B.MABN
WHERE K.NGAYKHAM = '2023-06-09';
--b. Thông tin bác sĩ đã khám cho bệnh nhân có mã bệnh nhân BN001, khám vào ngày 10-06-2023 (MABS, TENBS)
SELECT K.MABS, BS.TENBS
FROM KHAMBENH K
JOIN BACSI BS ON K.MABS = BS.MABS
WHERE K.MABN = 'BN001' AND K.NGAYKHAM = '2023-06-10';
--c. Danh sách những bệnh nhân chưa được bác sĩ khám (MABN, TENBN, SDT)
SELECT B.MABN, B.TENBN, B.SDT
FROM BENHNHAN B
LEFT JOIN KHAMBENH K ON B.MABN = K.MABN
WHERE K.MABN IS NULL;
--d. Thông tin bác sĩ đã khám nhiều bệnh nhân nhất (MABS, TENBS):
SELECT TOP 1 K.MABS, BS.TENBS
FROM KHAMBENH K
JOIN BACSI BS ON K.MABS = BS.MABS
GROUP BY K.MABS, BS.TENBS
ORDER BY COUNT(K.MABN) DESC;





