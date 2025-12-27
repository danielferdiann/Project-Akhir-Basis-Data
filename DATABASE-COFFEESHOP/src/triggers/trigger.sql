    -- #######################################################
    -- TRIGGER
    -- #######################################################


    -- TRIGGER 1 : (AFTER INSERT)
    CREATE TRIGGER TR_KurangiStok
    ON detail_pesanan
    AFTER INSERT
    AS
    BEGIN
        -- Update stok di tabel 'menu'
        UPDATE M
        SET M.stok = M.stok - I.jumlah
        FROM menu M
        INNER JOIN inserted I ON M.id_menu = I.id_menu;
    
        -- Insert catatan ke log_stok
        INSERT INTO log_stok (id_menu, perubahan, stok_sebelum, stok_sesudah, keterangan)
        SELECT
            I.id_menu,
            -I.jumlah AS perubahan, -- Perubahan negatif (pengurangan)
            M.stok + I.jumlah AS stok_sebelum, -- Stok sebelum dikurangi (stok lama + jumlah yang dikurangi)
            M.stok AS stok_sesudah,
            'Pengurangan karena pesanan ID: ' + CAST(I.id_pesanan AS VARCHAR)
        FROM inserted I
        INNER JOIN menu M ON M.id_menu = I.id_menu;
    END;
    GO

    SELECT stok FROM menu WHERE id_menu = 1;
    INSERT INTO detail_pesanan (id_pesanan, id_menu, jumlah, harga_satuan, subtotal_item) 
    VALUES (1, 1, 5, 25000.00, 125000.00);

    -- TRIGGER 2 : (AFTER UPDATE)
    CREATE TRIGGER TR_UpdateSelesai
    ON pesanan
    AFTER UPDATE
    AS
    BEGIN
        -- Hanya proses jika status berubah menjadi 'Completed' (ID 3)
        IF UPDATE(id_status) AND (SELECT id_status FROM inserted) = 3 AND (SELECT id_status FROM deleted) <> 3
        BEGIN
        
            -- 1. Tambah Poin Pelanggan (Jika ada id_pelanggan)
            UPDATE P
            SET P.poin = P.poin + FLOOR(I.total / 10000.0) -- Dapatkan 1 poin setiap kelipatan 10.000
            FROM pelanggan P
            INNER JOIN inserted I ON P.id_pelanggan = I.id_pelanggan
            WHERE I.id_pelanggan IS NOT NULL;

            -- 2. Catat ke Log Transaksi
            INSERT INTO log_transaksi (id_pesanan, total, catatan)
            SELECT
                id_pesanan,
                total,
                'Transaksi selesai dan poin pelanggan telah ditambahkan.'
            FROM inserted;
        END
    END;
    GO

    SELECT poin FROM pelanggan WHERE id_pelanggan = 1;

    INSERT INTO pesanan (id_pelanggan, id_karyawan, id_metode, id_status, subtotal, diskon, ppn, total, tanggal) 
    VALUES (1, 1, 1, 2, 100000.00, 0, 10000.00, 110000.00, GETDATE());

    UPDATE pesanan SET id_status = 3 WHERE id_pesanan = 4;

    -- TRIGGER 3 : (VALIDASI HARGA DAN STOK)
    CREATE TRIGGER TR_ValidasiMenu
    ON menu
    INSTEAD OF INSERT
    AS
    BEGIN
        -- Cek apakah ada baris yang harga atau stoknya tidak valid (<= 0)
        IF EXISTS (SELECT 1 FROM inserted WHERE harga <= 0 OR stok < 0)
        BEGIN
            -- Jika ditemukan data yang tidak valid, batalkan operasi INSERT
            RAISERROR ('GAGAL INPUT: Harga menu harus lebih besar dari nol dan Stok tidak boleh negatif. Operasi dibatalkan.', 16, 1);
            RETURN;
        END
        ELSE
        BEGIN
            -- Jika semua data valid, lanjutkan operasi INSERT yang sebenarnya
            INSERT INTO menu (id_kategori, nama_menu, harga, stok)
            SELECT id_kategori, nama_menu, harga, stok
            FROM inserted;
        END
    END;
    GO

    -- Coba masukkan menu dengan harga 0
    INSERT INTO menu (id_kategori, nama_menu, harga, stok) 
    VALUES (1, 'Air Putih Gratis', 0.00, 100);
    -- Coba masukkan menu dengan harga valid
    INSERT INTO menu (id_kategori, nama_menu, harga, stok) 
    VALUES (1, 'Kopi Valid', 15000.00, 50);


    -- TRIGGER 4 : PENCEGAHAN HAPUS KATEGORI
    CREATE TRIGGER TR_CekKategoriMenu
    ON kategori_menu
    INSTEAD OF DELETE
    AS
    BEGIN
        -- Cek apakah ada ID Kategori yang akan dihapus masih digunakan di tabel 'menu'
        IF EXISTS (
            SELECT 1
            FROM deleted D
            INNER JOIN menu M ON D.id_kategori = M.id_kategori
        )
        BEGIN
            -- Jika ditemukan ketergantungan, batalkan operasi DELETE
            RAISERROR ('GAGAL HAPUS: Kategori tidak dapat dihapus karena masih digunakan oleh beberapa item Menu. Hapus menu terlebih dahulu.', 16, 1);
            RETURN;
        END
        ELSE
        BEGIN
            -- Jika tidak ada ketergantungan, lakukan operasi DELETE yang sebenarnya
            DELETE FROM kategori_menu
            WHERE id_kategori IN (SELECT id_kategori FROM deleted);
        END
    END;
    GO

    -- SKENARIO GAGAL
    -- Cek kategori mana yang mau dihapus:
    SELECT * FROM kategori_menu WHERE id_kategori = 1;

    -- Cek menu yang terikat:
    SELECT * FROM menu WHERE id_kategori = 1;

    -- Perintah HAPUS (Trigger akan memblokir ini)
    DELETE FROM kategori_menu WHERE id_kategori = 1;

    -- SKENARIO BERHASIL
    -- A. Masukkan Kategori Baru (misal ID 5)
    INSERT INTO kategori_menu (nama_kategori) VALUES 
    ('Tes Kosong');

    -- B. Perintah HAPUS (Trigger akan mengizinkan)
    DELETE FROM kategori_menu WHERE nama_kategori = 'Tes Kosong';

    SELECT * FROM kategori_menu; -- cek kategori