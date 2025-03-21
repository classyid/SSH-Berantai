#!/bin/bash

# Detail koneksi
HOST="IP-SERVER"
PORT="22"
USER="root"
PASS="Password" # Ganti dengan password asli

# Variabel untuk Telegram
TELEGRAM_BOT_TOKEN="<TOKEN-TELEGRAM>"
TELEGRAM_CHAT_ID="<CHAT-ID>"

# Fungsi untuk mengirim pesan ke Telegram
send_to_telegram() {
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="$1" \
        -d parse_mode="HTML"
}

# Buat file untuk menyimpan log
LOG_FILE="/tmp/ssh_log_$(date +%Y%m%d_%H%M%S).txt"

# Log info koneksi
echo "Waktu koneksi: $(date)" > $LOG_FILE
echo "Host: ${HOST}" >> $LOG_FILE
echo "Port: ${PORT}" >> $LOG_FILE
echo "User: ${USER}" >> $LOG_FILE
echo "----- Log Koneksi -----" >> $LOG_FILE

# Kirim notifikasi ke Telegram bahwa koneksi dimulai
send_to_telegram "🚀 <b>Memulai koneksi SSH</b>
Host: ${HOST}
Port: ${PORT}
User: ${USER}
Waktu: $(date)"

# Pastikan sshpass terinstall
which sshpass >/dev/null || sudo apt-get install -y sshpass

# Coba login ke SSH dan jalankan htop setelah login berhasil
echo "Mencoba koneksi SSH ke $USER@$HOST:$PORT dan menjalankan htop..." | tee -a $LOG_FILE
sshpass -p "$PASS" ssh -t -p "$PORT" "$USER@$HOST" "htop; bash -l" 2>> $LOG_FILE

# Simpan status exit
EXIT_CODE=$?

# Log status exit
echo "Sesi SSH telah berakhir dengan kode: $EXIT_CODE" | tee -a $LOG_FILE

# Kirim notifikasi ke Telegram bahwa koneksi berakhir
send_to_telegram "⚠️ <b>Sesi SSH telah berakhir</b>
Host: ${HOST}
Kode Exit: ${EXIT_CODE}
Waktu Berakhir: $(date)"

# Kirim file log ke Telegram
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendDocument" \
    -F chat_id="${TELEGRAM_CHAT_ID}" \
    -F document=@"$LOG_FILE" \
    -F caption="Log SSH: $(date)"

echo "File log disimpan di: $LOG_FILE"
