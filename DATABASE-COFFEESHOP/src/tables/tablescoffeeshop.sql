USE COFFEESHOP;
GO

-- 1. KATEGORI MENU
CREATE TABLE kategori_menu (
    id_kategori INT PRIMARY KEY IDENTITY(1,1),
    nama_kategori VARCHAR(50) NOT NULL UNIQUE
);

-- 2. KARYAWAN
CREATE TABLE karyawan (
    id_karyawan INT PRIMARY KEY IDENTITY(1,1),
    nama VARCHAR(100) NOT NULL,
    posisi VARCHAR(30),
    gaji DECIMAL(10,2)
);

-- 3. METODE PEMBAYARAN
CREATE TABLE metode_pembayaran (
    id_metode INT PRIMARY KEY IDENTITY(1,1),
    nama_metode VARCHAR(30) NOT NULL UNIQUE
);

-- 4. STATUS PESANAN
CREATE TABLE status_pesanan (
    id_status INT PRIMARY KEY IDENTITY(1,1),
    nama_status VARCHAR(20) NOT NULL UNIQUE
);

-- 5. PELANGGAN
CREATE TABLE pelanggan (
    id_pelanggan INT PRIMARY KEY IDENTITY(1,1),
    nama VARCHAR(100) NOT NULL,
    no_hp VARCHAR(20) UNIQUE,
    poin INT DEFAULT 0
);

-- 6. MENU
CREATE TABLE menu (
    id_menu INT PRIMARY KEY IDENTITY(1,1),
    id_kategori INT NOT NULL,
    nama_menu VARCHAR(100) NOT NULL,
    harga DECIMAL(10,2) NOT NULL,
    stok INT DEFAULT 0,
    FOREIGN KEY (id_kategori) REFERENCES kategori_menu(id_kategori)
);

-- 7. PESANAN
CREATE TABLE pesanan (
    id_pesanan INT PRIMARY KEY IDENTITY(1,1),
    id_pelanggan INT,
    id_karyawan INT NOT NULL,
    id_metode INT NOT NULL,
    id_status INT NOT NULL,
    subtotal DECIMAL(10,2) DEFAULT 0,
    diskon DECIMAL(10,2) DEFAULT 0,
    ppn DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    tanggal DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan) ON DELETE SET NULL,
    FOREIGN KEY (id_karyawan) REFERENCES karyawan(id_karyawan),
    FOREIGN KEY (id_metode) REFERENCES metode_pembayaran(id_metode),
    FOREIGN KEY (id_status) REFERENCES status_pesanan(id_status)
);

-- 8. DETAIL PESANAN
CREATE TABLE detail_pesanan (
    id_detail INT PRIMARY KEY IDENTITY(1,1),
    id_pesanan INT NOT NULL,
    id_menu INT NOT NULL,
    jumlah INT NOT NULL,
    harga_satuan DECIMAL(10,2) NOT NULL,
    subtotal_item DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE CASCADE,
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
);

-- 9. LOG STOK
CREATE TABLE log_stok (
    id_log_stok INT PRIMARY KEY IDENTITY(1,1),
    id_menu INT NOT NULL,
    perubahan INT NOT NULL,
    stok_sebelum INT,
    stok_sesudah INT,
    waktu DATETIME DEFAULT GETDATE(),
    keterangan VARCHAR(100),
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
);

-- 10. LOG TRANSAKSI
CREATE TABLE log_transaksi (
    id_log INT PRIMARY KEY IDENTITY(1,1),
    id_pesanan INT NOT NULL,
    waktu DATETIME DEFAULT GETDATE(),
    total DECIMAL(10,2),
    catatan VARCHAR(100),
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan)
);
