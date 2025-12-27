-- #######################################################
-- FUNCTION
-- #######################################################


--------------------- FUNCTION 1 ---------------------
CREATE FUNCTION FN_HitungServiceCharge (@Subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @ServiceChargeRate DECIMAL(4,2) = 0.05; -- 5%
    DECLARE @AmbangBatas DECIMAL(10,2) = 50000.00; -- Rp 50.000

    DECLARE @ServiceCharge DECIMAL(10,2);

    IF @Subtotal >= @AmbangBatas
    BEGIN
        SET @ServiceCharge = @Subtotal * @ServiceChargeRate;
    END
    ELSE
    BEGIN
        SET @ServiceCharge = 0.00;
    END

    RETURN @ServiceCharge;
END;
GO

-- Cara Uji:
-- SELECT dbo.FN_HitungServiceCharge(120000.00) AS ServiceChargeTinggi; -- Hasil: 6000.00
-- SELECT dbo.FN_HitungServiceCharge(30000.00) AS ServiceChargeRendah;  -- Hasil: 0.00

--------------------- FUNCTION 2 ---------------------
CREATE FUNCTION FN_HitungTotalRevenueKaryawan (
    @id_karyawan INT,
    @TanggalMulai DATE,
    @TanggalSelesai DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2);

    SELECT @TotalRevenue = ISNULL(SUM(total), 0.00)
    FROM pesanan
    WHERE id_karyawan = @id_karyawan
      AND id_status = 3 -- Hanya hitung pesanan yang 'Completed'
      AND tanggal >= @TanggalMulai
      AND tanggal < DATEADD(DAY, 1, @TanggalSelesai); -- Agar mencakup tanggal selesai

    RETURN @TotalRevenue;
END;
GO

-- Cara Uji:
-- Total penjualan oleh Karyawan ID 2 (Agung) dari 2025-12-07 sampai 2025-12-07 (Data seed awal)
-- SELECT dbo.FN_HitungTotalRevenueKaryawan(2, '2025-12-07', '2025-12-07') AS RevenueAgung;


--------------------- FUNCTION 3 ---------------------
CREATE FUNCTION FN_DaftarMenuPerKategori (@id_kategori INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        id_menu,
        nama_menu,
        harga,
        stok
    FROM
        menu
    WHERE
        id_kategori = @id_kategori
);
GO

-- Cara Uji:
-- Ambil semua Menu Kategori Coffee (ID 1)
-- SELECT * FROM dbo.FN_DaftarMenuPerKategori(1);

--------------------- FUNCTION 4 ---------------------
CREATE FUNCTION FN_LogStokTerakhir (@id_menu INT)
RETURNS @LogStok TABLE 
(
    waktu DATETIME,
    perubahan INT,
    stok_sebelum INT,
    stok_sesudah INT,
    keterangan VARCHAR(100)
)
AS
BEGIN
    INSERT INTO @LogStok (waktu, perubahan, stok_sebelum, stok_sesudah, keterangan)
    SELECT TOP 5
        waktu,
        perubahan,
        stok_sebelum,
        stok_sesudah,
        keterangan
    FROM
        log_stok
    WHERE
        id_menu = @id_menu
    ORDER BY
        waktu DESC;
    
    RETURN;
END;
GO

-- Cara Uji: 
-- Saat ini log_stok mungkin kosong/sedikit. Kita uji Menu ID 5 (Kentang Goreng) yang sudah kita kurangi stoknya saat uji SP1
-- SELECT * FROM dbo.FN_LogStokTerakhir(5);