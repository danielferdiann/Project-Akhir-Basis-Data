
-- 1. KATEGORI MENU (ID: 1, 2, 3, 4)
INSERT INTO kategori_menu (nama_kategori) VALUES
('Coffee'), ('Non-Coffee'), ('Makanan Ringan'), ('Makanan Berat');


-- 2. KARYAWAN (ID: 1, 2)
INSERT INTO karyawan (nama, posisi, gaji) VALUES
('Rina Wijaya', 'Barista', 4000000.00),
('Agung Pramono', 'Kasir', 3500000.00);


-- 3. METODE PEMBAYARAN (ID: 1, 2, 3)
INSERT INTO metode_pembayaran (nama_metode) VALUES
('Cash'), ('QRIS'), ('Debit Card');


-- 4. STATUS PESANAN (ID: 1, 2, 3, 4)
INSERT INTO status_pesanan (nama_status) VALUES
('Draft'), ('Processing'), ('Completed'), ('Cancelled');


-- 5. PELANGGAN (ID: 1, 2, 3)
INSERT INTO pelanggan (nama, no_hp, poin) VALUES
('Laura', '081234567890', 150),
('Wawa', '087654321098', 50),
('Pelanggan Tanpa HP', NULL, 0);


-- 6. MENU (ID: 1, 2, 3, 4, 5, 6)
INSERT INTO menu (id_kategori, nama_menu, harga, stok) VALUES
(1, 'Espresso', 25000.00, 50),
(1, 'Cappuccino', 35000.00, 45),
(2, 'Matcha Latte', 40000.00, 60),
(2, 'Lemon Tea', 20000.00, 70),
(3, 'Kentang Goreng', 28000.00, 80),
(4, 'Nasi Goreng Kampung', 45000.00, 30);


-- 7. PESANAN (ID: 1, 2, 3)
INSERT INTO pesanan (id_pelanggan, id_karyawan, id_metode, id_status, subtotal, diskon, ppn, total, tanggal) VALUES
(1, 2, 2, 3, 88000.00, 8000.00, 8000.00, 88000.00, '2025-12-07 10:30:00'), 
(NULL, 1, 1, 3, 25000.00, 0.00, 2500.00, 27500.00, '2025-12-07 14:00:00'), 
(2, 2, 3, 3, 113000.00, 10000.00, 10300.00, 113300.00, '2025-12-07 18:45:00'); 


-- 8. DETAIL PESANAN
INSERT INTO detail_pesanan (id_pesanan, id_menu, jumlah, harga_satuan, subtotal_item) VALUES
(1, 2, 1, 35000.00, 35000.00), 
(1, 1, 1, 25000.00, 25000.00), 
(1, 5, 1, 28000.00, 28000.00), 
(2, 1, 1, 25000.00, 25000.00), 
(3, 3, 1, 40000.00, 40000.00), 
(3, 6, 1, 45000.00, 45000.00), 
(3, 5, 1, 28000.00, 28000.00);