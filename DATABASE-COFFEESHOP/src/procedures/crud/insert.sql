
-- SP INSERT 1: Insert Kategori Menu
CREATE PROCEDURE SP_InsertKategoriMenu
    @nama_kategori VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO kategori_menu (nama_kategori)
        VALUES (@nama_kategori);
        
        SELECT 'SUCCESS: Kategori menu berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertKategoriMenu @nama_kategori = 'Dessert';


-- SP INSERT 2: Insert Menu
CREATE PROCEDURE SP_InsertMenu
    @id_kategori INT,
    @nama_menu VARCHAR(100),
    @harga DECIMAL(10,2),
    @stok INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO menu (id_kategori, nama_menu, harga, stok)
        VALUES (@id_kategori, @nama_menu, @harga, @stok);
        
        SELECT 'SUCCESS: Menu berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertMenu @id_kategori = 1, @nama_menu = 'Americano', @harga = 30000.00, @stok = 40;


-- SP INSERT 3: Insert Karyawan
CREATE PROCEDURE SP_InsertKaryawan
    @nama VARCHAR(100),
    @posisi VARCHAR(30),
    @gaji DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO karyawan (nama, posisi, gaji)
        VALUES (@nama, @posisi, @gaji);
        
        SELECT 'SUCCESS: Karyawan berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertKaryawan @nama = 'Budi Santoso', @posisi = 'Barista', @gaji = 4200000.00;


-- SP INSERT 4: Insert Pelanggan
CREATE PROCEDURE SP_InsertPelanggan
    @nama VARCHAR(100),
    @no_hp VARCHAR(20) = NULL,
    @poin INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO pelanggan (nama, no_hp, poin)
        VALUES (@nama, @no_hp, @poin);
        
        SELECT 'SUCCESS: Pelanggan berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertPelanggan @nama = 'Siti Aminah', @no_hp = '081298765432', @poin = 0;


-- SP INSERT 5: Insert Metode Pembayaran
CREATE PROCEDURE SP_InsertMetodePembayaran
    @nama_metode VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO metode_pembayaran (nama_metode)
        VALUES (@nama_metode);
        
        SELECT 'SUCCESS: Metode pembayaran berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertMetodePembayaran @nama_metode = 'E-Wallet';


-- SP INSERT 6: Insert Status Pesanan
CREATE PROCEDURE SP_InsertStatusPesanan
    @nama_status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO status_pesanan (nama_status)
        VALUES (@nama_status);
        
        SELECT 'SUCCESS: Status pesanan berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertStatusPesanan @nama_status = 'Pending';


-- SP INSERT 7: Insert Pesanan
CREATE PROCEDURE SP_InsertPesanan
    @id_pelanggan INT = NULL,
    @id_karyawan INT,
    @id_metode INT,
    @id_status INT,
    @subtotal DECIMAL(10,2) = 0,
    @diskon DECIMAL(10,2) = 0,
    @ppn DECIMAL(10,2) = 0,
    @total DECIMAL(10,2) = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO pesanan (id_pelanggan, id_karyawan, id_metode, id_status, subtotal, diskon, ppn, total)
        VALUES (@id_pelanggan, @id_karyawan, @id_metode, @id_status, @subtotal, @diskon, @ppn, @total);
        
        DECLARE @NewID INT = SCOPE_IDENTITY();
        SELECT 'SUCCESS: Pesanan berhasil ditambahkan dengan ID: ' + CAST(@NewID AS VARCHAR) AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertPesanan @id_pelanggan = 1, @id_karyawan = 1, @id_metode = 1, @id_status = 1, @total = 50000.00;


-- SP INSERT 8: Insert Detail Pesanan
CREATE PROCEDURE SP_InsertDetailPesanan
    @id_pesanan INT,
    @id_menu INT,
    @jumlah INT,
    @harga_satuan DECIMAL(10,2),
    @subtotal_item DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO detail_pesanan (id_pesanan, id_menu, jumlah, harga_satuan, subtotal_item)
        VALUES (@id_pesanan, @id_menu, @jumlah, @harga_satuan, @subtotal_item);
        
        SELECT 'SUCCESS: Detail pesanan berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertDetailPesanan @id_pesanan = 1, @id_menu = 1, @jumlah = 2, @harga_satuan = 25000.00, @subtotal_item = 50000.00;


-- SP INSERT 9: Insert Log Stok
CREATE PROCEDURE SP_InsertLogStok
    @id_menu INT,
    @perubahan INT,
    @stok_sebelum INT,
    @stok_sesudah INT,
    @keterangan VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO log_stok (id_menu, perubahan, stok_sebelum, stok_sesudah, keterangan)
        VALUES (@id_menu, @perubahan, @stok_sebelum, @stok_sesudah, @keterangan);
        
        SELECT 'SUCCESS: Log stok berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertLogStok @id_menu = 1, @perubahan = 10, @stok_sebelum = 50, @stok_sesudah = 60, @keterangan = 'Restock';


-- SP INSERT 10: Insert Log Transaksi
CREATE PROCEDURE SP_InsertLogTransaksi
    @id_pesanan INT,
    @total DECIMAL(10,2),
    @catatan VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO log_transaksi (id_pesanan, total, catatan)
        VALUES (@id_pesanan, @total, @catatan);
        
        SELECT 'SUCCESS: Log transaksi berhasil ditambahkan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_InsertLogTransaksi @id_pesanan = 1, @total = 88000.00, @catatan = 'Pembayaran lunas';