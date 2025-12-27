# Coffee Shop Database Management System

Proyek ini berisi perancangan basis data lengkap untuk sistem manajemen Coffee Shop, mencakup manajemen menu, transaksi pelanggan, hingga otomatisasi stok.

## 📊 Entity Relationship Diagram (ERD)
![ERD](./docs/erdcoffeeshop.jpg)

## 🚀 Fitur Utama
- **Otomatisasi Stok**: Menggunakan *Trigger* untuk update stok saat transaksi atau restock.
- **Transaksi Terintegrasi**: *Stored Procedure* untuk menangani pesanan baru secara atomik.
- **Laporan Penjualan**: *Views* untuk melihat performa karyawan dan menu terlaris.
- **Loyalty Program**: Perhitungan poin pelanggan otomatis.

## 🛠️ Cara Instalasi
Jalankan script dengan urutan berikut untuk menghindari error Foreign Key:
1. `src/schema/database.sql`
2. `src/tables/tables.sql`
3. `src/functions/Function.sql`
4. `src/procedures/` (semua file)
5. `src/triggers/Trigger.sql`
6. `scripts/seed_data.sql` (untuk data demo)
