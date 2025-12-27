-- #######################################################
-- STORED PROCEDURE
-- #######################################################

CREATE TYPE TabelDetailPesananType AS TABLE (
    id_menu INT NOT NULL,
    jumlah INT NOT NULL,
    harga_satuan DECIMAL(10,2) NOT NULL,
    subtotal_item DECIMAL(10,2) NOT NULL
);

-- STORED PROCEDURE 1 : (Transaksi Penuh)
ALTER PROCEDURE SP_ProsesPesananBaru (
    @id_pelanggan INT,
    @id_karyawan INT,
    @id_metode INT,
    -- Hapus: @Subtotal, @Diskon, @Ppn
    @Total DECIMAL(10,2),
    @TabelDetail AS [dbo].[TabelDetailPesananType] READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    DECLARE @NewPesananID INT;

    -- 1. Insert Header Pesanan (Diasumsikan Status 3 = Completed)
    -- Perhatikan: Kolom subtotal, diskon, ppn diisi NULL atau 0
    INSERT INTO pesanan (id_pelanggan, id_karyawan, id_metode, id_status, total, tanggal, subtotal, diskon, ppn)
    VALUES (@id_pelanggan, @id_karyawan, @id_metode, 3, @Total, GETDATE(), @Total, 0.00, 0.00); -- Simplifikasi: Asumsi Total = Subtotal
    
    SET @NewPesananID = SCOPE_IDENTITY();
    
    IF @NewPesananID IS NULL OR @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('GAGAL: Insert header pesanan gagal.', 16, 1);
        RETURN;
    END

    -- 2. Insert Detail Pesanan
    INSERT INTO detail_pesanan (id_pesanan, id_menu, jumlah, harga_satuan, subtotal_item)
    SELECT 
        @NewPesananID, id_menu, jumlah, harga_satuan, subtotal_item
    FROM @TabelDetail;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('GAGAL: Insert detail pesanan gagal. Transaksi dibatalkan.', 16, 1);
        RETURN;
    END

    -- 3. Semua berhasil
    COMMIT TRANSACTION;
    SELECT 'SUCCESS: Transaksi berhasil diproses. ID: ' + CAST(@NewPesananID AS VARCHAR);

END;
GO


-- STORED PROCEDURE 2 : (Penukaran Poin)
ALTER PROCEDURE SP_TransferPoinPelanggan (
    @id_pesanan INT,
    @id_pelanggan INT,
    @PoinDipakai INT,
    @NilaiDiskon DECIMAL(10,2)
    -- Parameter @TotalBaru sudah dihapus dari sini
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    -- 1. Kurangi Poin Pelanggan
    UPDATE pelanggan
    SET poin = poin - @PoinDipakai
    WHERE id_pelanggan = @id_pelanggan AND poin >= @PoinDipakai;
    
    IF @@ERROR <> 0 OR @@ROWCOUNT = 0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('GAGAL: Poin tidak cukup atau ID pelanggan tidak valid.', 16, 1);
        RETURN;
    END

    -- 2. Update Diskon dan Total di Pesanan
    UPDATE pesanan
    SET diskon = diskon + @NilaiDiskon, 
        total = total - @NilaiDiskon -- Asumsi diskon dikurangi dari total lama
    WHERE id_pesanan = @id_pesanan;

    IF @@ERROR <> 0 OR @@ROWCOUNT = 0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('GAGAL: Update pesanan gagal. Poin pelanggan dikembalikan.', 16, 1);
        RETURN;
    END

    -- 3. Semua berhasil
    COMMIT TRANSACTION;
    SELECT 'SUCCESS: Penukaran poin senilai ' + CAST(@NilaiDiskon AS VARCHAR) + ' berhasil diterapkan.';
END;
GO

-- STORED PROCEDURE 3 : (Data Riwayat Menu)
CREATE PROCEDURE SP_GetRiwayatMenuTerjual
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        M.nama_menu,
        KM.nama_kategori,
        SUM(DP.jumlah) AS TotalTerjual,
        SUM(DP.subtotal_item) AS TotalRevenue
    FROM
        detail_pesanan DP
    INNER JOIN menu M ON DP.id_menu = M.id_menu
    INNER JOIN kategori_menu KM ON M.id_kategori = KM.id_kategori
    GROUP BY
        M.nama_menu, KM.nama_kategori
    ORDER BY
        TotalTerjual DESC;
END;
GO


-- STORED PROCEDURE 4 : (Cek Stok dibawah Batas Aman ex:<50)
CREATE PROCEDURE SP_CekStokRendah
    @BatasStok INT = 10 -- Default batas 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        id_menu,
        nama_menu,
        stok,
        'Stok perlu diisi ulang' AS Status
    FROM
        menu
    WHERE
        stok <= @BatasStok
    ORDER BY
        stok ASC;
END;
GO

--------------------- ##### UJI SP 1 ##### ---------------------
-- 1. DEKLARASI TABLE TYPE
DECLARE @DetailItems AS TabelDetailPesananType; 

-- 2. ISI DETAIL PESANAN
-- Isi detail pesanan untuk pesanan baru (Total 96000 + PPN)
INSERT INTO @DetailItems (id_menu, jumlah, harga_satuan, subtotal_item)
VALUES 
(3, 1, 40000.00, 40000.00), -- Matcha Latte
(5, 2, 28000.00, 56000.00); -- Kentang Goreng (2 porsi)

-- 3. EKSEKUSI STORED PROCEDURE (Hanya perlu Total)
EXEC SP_ProsesPesananBaru 
    @id_pelanggan = 2,  -- Wawa
    @id_karyawan = 1,   -- Rina
    @id_metode = 2,     -- QRIS
    @Total = 105600.00, -- Total Akhir yang Dibayar
    @TabelDetail = @DetailItems; 

-- Cek hasilnya:
SELECT * FROM pesanan ORDER BY id_pesanan DESC;
SELECT * FROM detail_pesanan ORDER BY id_detail DESC;

--------------------- ##### UJI SP 2 ##### ---------------------

-- 1. Cek Awal (untuk verifikasi TCL)
SELECT poin FROM pelanggan WHERE id_pelanggan = 1; 
SELECT total, diskon FROM pesanan WHERE id_pesanan = 5; 

-- 2. Eksekusi SP yang sudah diperbaiki
EXEC SP_TransferPoinPelanggan
    @id_pesanan = 5,
    @id_pelanggan = 1,
    @PoinDipakai = 5,       -- Gunakan 5 poin saja
    @NilaiDiskon = 500.00;  -- Nilai diskon 500

-- 3. Cek Akhir (poin berkurang 5, total berkurang 500)
SELECT poin FROM pelanggan WHERE id_pelanggan = 1; 
SELECT total, diskon FROM pesanan WHERE id_pesanan = 5;


--------------------- ##### UJI SP 3 ##### ---------------------
EXEC SP_GetRiwayatMenuTerjual;

--------------------- ##### UJI SP 4 ##### ---------------------
-- Cek menu mana yang stoknya di bawah 50
EXEC SP_CekStokRendah @BatasStok = 50;