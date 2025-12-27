-- #######################################################
-- VIEW
-- #######################################################


-- VIEW 1: INNER JOIN (menu + kategori)

CREATE VIEW vw_menu_kategori AS
SELECT  
    m.id_menu, 
    m.nama_menu, 
    m.harga, 
    m.stok, 
    k.id_kategori, 
    k.nama_kategori
FROM menu m
INNER JOIN kategori_menu k ON m.id_kategori = k.id_kategori;
GO

SELECT * FROM vw_menu_kategori;

-- VIEW 2: LEFT JOIN (pesanan + pelanggan + karyawan)

CREATE VIEW vw_laporan_pesanan AS
SELECT 
    p.id_pesanan, 
    p.tanggal, 
    p.total, 
    s.nama_status, 
    pm.nama_metode,
       pel.id_pelanggan, pel.nama AS nama_pelanggan, k.id_karyawan, k.nama AS nama_karyawan
FROM pesanan p
LEFT JOIN pelanggan pel ON p.id_pelanggan = pel.id_pelanggan
LEFT JOIN karyawan k ON p.id_karyawan = k.id_karyawan
LEFT JOIN status_pesanan s ON p.id_status = s.id_status
LEFT JOIN metode_pembayaran pm ON p.id_metode = pm.id_metode;
GO

SELECT * FROM vw_laporan_pesanan;

-- VIEW 3: RIGHT JOIN (menu yang belum pernah dipesan)

CREATE VIEW vw_menu_belum_dipesan AS
SELECT 
    m.id_menu, 
    m.nama_menu, 
    dp.id_pesanan
FROM menu m
RIGHT JOIN detail_pesanan dp ON m.id_menu = dp.id_menu
WHERE dp.id_pesanan IS NULL; -- for strict RIGHT semantics this may need LEFT version
GO

SELECT * FROM vw_menu_belum_dipesan