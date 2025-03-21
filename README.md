# SSH-Berantai 🚀

Alat bantu SSH dengan kemampuan koneksi berantai dan monitoring via Telegram.

![SSH-Berantai Banner](https://blog.classy.id/upload/gambar_berita/2257e285f30e3bceccfaa835f3f59324_20250321081523.jpeg)
![SSH-Berantai Banner](https://blog.classy.id/upload/gambar_berita/afd82ce6232fcdf4791d4c71c5e77e94_20250321154858.png)

## 🌟 Fitur Utama

- ✅ Login SSH otomatis tanpa harus mengetik password berulang kali
- ✅ Koneksi berantai ke beberapa server sekaligus
- ✅ Monitoring sistem langsung melalui htop/btop
- ✅ Notifikasi dan log otomatis ke Telegram
- ✅ Instalasi otomatis paket yang dibutuhkan

## 📋 Persyaratan

- Linux/Unix sistem
- Paket `sshpass` (akan diinstal otomatis jika belum ada)
- Bot Telegram (untuk fitur notifikasi)

## 🔧 Cara Penggunaan

### Pengaturan Dasar

1. Clone repository ini:
   ```bash
   git clone https://github.com/classyid/ssh-berantai.git
   cd ssh-berantai
   
2. Edit file konfigurasi dengan detail server Anda:
   ```bash
   nano ssh-berantai.sh
   ```

3. Sesuaikan variabel berikut:
   - `HOST1`, `PORT1`, `USER1`, `PASS1` untuk server pertama
   - `HOST2`, `PORT2`, `USER2`, `PASS2` untuk server kedua
   - `TELEGRAM_BOT_TOKEN` dan `TELEGRAM_CHAT_ID` untuk notifikasi

4. Berikan izin eksekusi:
   ```bash
   chmod +x ssh-berantai.sh
   ```

5. Jalankan script:
   ```bash
   ./ssh-berantai.sh
   ```

### Contoh Penggunaan

```bash
# Login ke server-1 dan menjalankan htop
./ssh-login.sh

# Login berantai dari server-1 ke server-2 dan menjalankan btop
./ssh-berantai.sh
```

## 🛡️ Keamanan

**Peringatan**: Menyimpan password dalam script bukanlah praktik keamanan yang baik. Untuk penggunaan jangka panjang, sebaiknya gunakan SSH key authentication.

Petunjuk pembuatan SSH key:
1. Buat SSH key: `ssh-keygen -t rsa -b 4096`
2. Salin ke server: `ssh-copy-id -p PORT username@host`
3. Setelah itu Anda bisa menghapus variabel PASS dalam script

## 📜 Lisensi

Proyek ini dilisensikan di bawah Lisensi MIT - lihat file [LICENSE](LICENSE) untuk detailnya.

## 🤝 Kontribusi

Kontribusi selalu disambut! Silakan buat fork repository, lakukan perubahan, dan ajukan pull request.
```
