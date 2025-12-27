
-- SP UPDATE 1: Update Kategori Menu
CREATE PROCEDURE SP_UpdateKategoriMenu
    @id_kategori INT,
    @nama_kategori VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE kategori_menu
        SET nama_kategori = @nama_kategori
        WHERE id_kategori = @id_kategori;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Kategori menu berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID kategori tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdateKategoriMenu @id_kategori = 1, @nama_kategori = 'Kopi Premium';


-- SP UPDATE 2: Update Menu
CREATE PROCEDURE SP_UpdateMenu
    @id_menu INT,
    @id_kategori INT = NULL,
    @nama_menu VARCHAR(100) = NULL,
    @harga DECIMAL(10,2) = NULL,
    @stok INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE menu
        SET 
            id_kategori = ISNULL(@id_kategori, id_kategori),
            nama_menu = ISNULL(@nama_menu, nama_menu),
            harga = ISNULL(@harga, harga),
            stok = ISNULL(@stok, stok)
        WHERE id_menu = @id_menu;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Menu berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID menu tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdateMenu @id_menu = 1, @harga = 27000.00, @stok = 55;


-- SP UPDATE 3: Update Karyawan
CREATE PROCEDURE SP_UpdateKaryawan
    @id_karyawan INT,
    @nama VARCHAR(100) = NULL,
    @posisi VARCHAR(30) = NULL,
    @gaji DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE karyawan
        SET 
            nama = ISNULL(@nama, nama),
            posisi = ISNULL(@posisi, posisi),
            gaji = ISNULL(@gaji, gaji)
        WHERE id_karyawan = @id_karyawan;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Data karyawan berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID karyawan tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdateKaryawan @id_karyawan = 1, @gaji = 4500000.00;


-- SP UPDATE 4: Update Pelanggan
CREATE PROCEDURE SP_UpdatePelanggan
    @id_pelanggan INT,
    @nama VARCHAR(100) = NULL,
    @no_hp VARCHAR(20) = NULL,
    @poin INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE pelanggan
        SET 
            nama = ISNULL(@nama, nama),
            no_hp = ISNULL(@no_hp, no_hp),
            poin = ISNULL(@poin, poin)
        WHERE id_pelanggan = @id_pelanggan;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Data pelanggan berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID pelanggan tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdatePelanggan @id_pelanggan = 1, @poin = 200;


-- SP UPDATE 5: Update Metode Pembayaran
CREATE PROCEDURE SP_UpdateMetodePembayaran
    @id_metode INT,
    @nama_metode VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE metode_pembayaran
        SET nama_metode = @nama_metode
        WHERE id_metode = @id_metode;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Metode pembayaran berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID metode tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdateMetodePembayaran @id_metode = 1, @nama_metode = 'Tunai';


-- SP UPDATE 6: Update Status Pesanan
CREATE PROCEDURE SP_UpdateStatusPesanan
    @id_status INT,
    @nama_status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE status_pesanan
        SET nama_status = @nama_status
        WHERE id_status = @id_status;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Status pesanan berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID status tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdateStatusPesanan @id_status = 1, @nama_status = 'Draft Order';


-- SP UPDATE 7: Update Pesanan
CREATE PROCEDURE SP_UpdatePesanan
    @id_pesanan INT,
    @id_pelanggan INT = NULL,
    @id_karyawan INT = NULL,
    @id_metode INT = NULL,
    @id_status INT = NULL,
    @subtotal DECIMAL(10,2) = NULL,
    @diskon DECIMAL(10,2) = NULL,
    @ppn DECIMAL(10,2) = NULL,
    @total DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE pesanan
        SET 
            id_pelanggan = ISNULL(@id_pelanggan, id_pelanggan),
            id_karyawan = ISNULL(@id_karyawan, id_karyawan),
            id_metode = ISNULL(@id_metode, id_metode),
            id_status = ISNULL(@id_status, id_status),
            subtotal = ISNULL(@subtotal, subtotal),
            diskon = ISNULL(@diskon, diskon),
            ppn = ISNULL(@ppn, ppn),
            total = ISNULL(@total, total)
        WHERE id_pesanan = @id_pesanan;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Pesanan berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID pesanan tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdatePesanan @id_pesanan = 1, @id_status = 3, @total = 90000.00;


-- SP UPDATE 8: Update Detail Pesanan
CREATE PROCEDURE SP_UpdateDetailPesanan
    @id_detail INT,
    @id_pesanan INT = NULL,
    @id_menu INT = NULL,
    @jumlah INT = NULL,
    @harga_satuan DECIMAL(10,2) = NULL,
    @subtotal_item DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE detail_pesanan
        SET 
            id_pesanan = ISNULL(@id_pesanan, id_pesanan),
            id_menu = ISNULL(@id_menu, id_menu),
            jumlah = ISNULL(@jumlah, jumlah),
            harga_satuan = ISNULL(@harga_satuan, harga_satuan),
            subtotal_item = ISNULL(@subtotal_item, subtotal_item)
        WHERE id_detail = @id_detail;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Detail pesanan berhasil diupdate.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID detail tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdateDetailPesanan @id_detail = 1, @jumlah = 3, @subtotal_item = 75000.00;


-- SP UPDATE 9: Update Stok Menu (dengan log)
CREATE PROCEDURE SP_UpdateStokMenu
    @id_menu INT,
    @stok_baru INT,
    @keterangan VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @stok_lama INT;
        
        -- Ambil stok lama
        SELECT @stok_lama = stok FROM menu WHERE id_menu = @id_menu;
        
        IF @stok_lama IS NULL
        BEGIN
            SELECT 'GAGAL: ID menu tidak ditemukan.' AS Pesan;
            RETURN;
        END
        
        -- Update stok
        UPDATE menu
        SET stok = @stok_baru
        WHERE id_menu = @id_menu;
        
        -- Catat di log_stok
        INSERT INTO log_stok (id_menu, perubahan, stok_sebelum, stok_sesudah, keterangan)
        VALUES (@id_menu, @stok_baru - @stok_lama, @stok_lama, @stok_baru, @keterangan);
        
        SELECT 'SUCCESS: Stok menu berhasil diupdate dari ' + CAST(@stok_lama AS VARCHAR) + 
               ' menjadi ' + CAST(@stok_baru AS VARCHAR) AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdateStokMenu @id_menu = 1, @stok_baru = 70, @keterangan = 'Restock dari supplier';


-- SP UPDATE 10: Update Poin Pelanggan
CREATE PROCEDURE SP_UpdatePoinPelanggan
    @id_pelanggan INT,
    @tambah_poin INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE pelanggan
        SET poin = poin + @tambah_poin
        WHERE id_pelanggan = @id_pelanggan;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Poin pelanggan berhasil ditambah ' + CAST(@tambah_poin AS VARCHAR) + ' poin.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID pelanggan tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_UpdatePoinPelanggan @id_pelanggan = 1, @tambah_poin = 50;