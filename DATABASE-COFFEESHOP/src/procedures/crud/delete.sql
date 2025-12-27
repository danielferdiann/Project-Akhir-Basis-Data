
-- SP DELETE 1: Delete Kategori Menu
CREATE PROCEDURE SP_DeleteKategoriMenu
    @id_kategori INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Cek apakah kategori masih digunakan
        IF EXISTS (SELECT 1 FROM menu WHERE id_kategori = @id_kategori)
        BEGIN
            SELECT 'GAGAL: Kategori masih digunakan oleh menu. Hapus menu terlebih dahulu.' AS Pesan;
            RETURN;
        END
        
        DELETE FROM kategori_menu
        WHERE id_kategori = @id_kategori;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Kategori menu berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID kategori tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteKategoriMenu @id_kategori = 5;


-- SP DELETE 2: Delete Menu
CREATE PROCEDURE SP_DeleteMenu
    @id_menu INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Cek apakah menu masih ada di detail pesanan
        IF EXISTS (SELECT 1 FROM detail_pesanan WHERE id_menu = @id_menu)
        BEGIN
            SELECT 'GAGAL: Menu masih terkait dengan pesanan. Tidak dapat dihapus.' AS Pesan;
            RETURN;
        END
        
        DELETE FROM menu
        WHERE id_menu = @id_menu;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Menu berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID menu tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteMenu @id_menu = 10;


-- SP DELETE 3: Delete Karyawan
CREATE PROCEDURE SP_DeleteKaryawan
    @id_karyawan INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Cek apakah karyawan masih terkait dengan pesanan
        IF EXISTS (SELECT 1 FROM pesanan WHERE id_karyawan = @id_karyawan)
        BEGIN
            SELECT 'GAGAL: Karyawan masih terkait dengan pesanan. Tidak dapat dihapus.' AS Pesan;
            RETURN;
        END
        
        DELETE FROM karyawan
        WHERE id_karyawan = @id_karyawan;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Data karyawan berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID karyawan tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteKaryawan @id_karyawan = 5;


-- SP DELETE 4: Delete Pelanggan
CREATE PROCEDURE SP_DeletePelanggan
    @id_pelanggan INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Karena ON DELETE SET NULL, pesanan akan tetap ada tapi id_pelanggan menjadi NULL
        DELETE FROM pelanggan
        WHERE id_pelanggan = @id_pelanggan;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Data pelanggan berhasil dihapus. Pesanan terkait tetap tersimpan.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID pelanggan tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeletePelanggan @id_pelanggan = 3;


-- SP DELETE 5: Delete Metode Pembayaran
CREATE PROCEDURE SP_DeleteMetodePembayaran
    @id_metode INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Cek apakah metode masih digunakan
        IF EXISTS (SELECT 1 FROM pesanan WHERE id_metode = @id_metode)
        BEGIN
            SELECT 'GAGAL: Metode pembayaran masih digunakan. Tidak dapat dihapus.' AS Pesan;
            RETURN;
        END
        
        DELETE FROM metode_pembayaran
        WHERE id_metode = @id_metode;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Metode pembayaran berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID metode tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteMetodePembayaran @id_metode = 5;


-- SP DELETE 6: Delete Status Pesanan
CREATE PROCEDURE SP_DeleteStatusPesanan
    @id_status INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Cek apakah status masih digunakan
        IF EXISTS (SELECT 1 FROM pesanan WHERE id_status = @id_status)
        BEGIN
            SELECT 'GAGAL: Status pesanan masih digunakan. Tidak dapat dihapus.' AS Pesan;
            RETURN;
        END
        
        DELETE FROM status_pesanan
        WHERE id_status = @id_status;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Status pesanan berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID status tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteStatusPesanan @id_status = 5;


-- SP DELETE 7: Delete Pesanan (CASCADE ke detail_pesanan dan log_transaksi)
CREATE PROCEDURE SP_DeletePesanan
    @id_pesanan INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Hapus log transaksi terkait
        DELETE FROM log_transaksi WHERE id_pesanan = @id_pesanan;
        
        -- Hapus pesanan (detail_pesanan akan otomatis terhapus karena ON DELETE CASCADE)
        DELETE FROM pesanan WHERE id_pesanan = @id_pesanan;
        
        IF @@ROWCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
            SELECT 'SUCCESS: Pesanan dan semua detail terkait berhasil dihapus.' AS Pesan;
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'GAGAL: ID pesanan tidak ditemukan.' AS Pesan;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeletePesanan @id_pesanan = 10;


-- SP DELETE 8: Delete Detail Pesanan
CREATE PROCEDURE SP_DeleteDetailPesanan
    @id_detail INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM detail_pesanan
        WHERE id_detail = @id_detail;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Detail pesanan berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID detail tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteDetailPesanan @id_detail = 10;


-- SP DELETE 9: Delete Log Stok
CREATE PROCEDURE SP_DeleteLogStok
    @id_log_stok INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM log_stok
        WHERE id_log_stok = @id_log_stok;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Log stok berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID log stok tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteLogStok @id_log_stok = 5;


-- SP DELETE 10: Delete Log Transaksi
CREATE PROCEDURE SP_DeleteLogTransaksi
    @id_log INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM log_transaksi
        WHERE id_log = @id_log;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Log transaksi berhasil dihapus.' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID log tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_DeleteLogTransaksi @id_log = 5;


-- SP DELETE 11: Soft Delete Pesanan (Ubah status menjadi Cancelled)
CREATE PROCEDURE SP_SoftDeletePesanan
    @id_pesanan INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE pesanan
        SET id_status = 4 -- Status Cancelled
        WHERE id_pesanan = @id_pesanan;
        
        IF @@ROWCOUNT > 0
            SELECT 'SUCCESS: Pesanan dibatalkan (soft delete).' AS Pesan;
        ELSE
            SELECT 'GAGAL: ID pesanan tidak ditemukan.' AS Pesan;
    END TRY
    BEGIN CATCH
        SELECT 'GAGAL: ' + ERROR_MESSAGE() AS Pesan;
    END CATCH
END;
GO

-- Contoh Uji:
-- EXEC SP_SoftDeletePesanan @id_pesanan = 2;