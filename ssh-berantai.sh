#!/bin/bash

# Detail koneksi server pertama
HOST1="IP-SERVER"
PORT1="22"
USER1="root"
PASS1="Password"

# Detail koneksi server kedua
HOST2="IP-SERVER-2" 
PORT2="22"
USER2="root"
PASS2="Password"

# Variabel untuk Telegram
TELEGRAM_BOT_TOKEN="<ID-TOKEN>"
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
echo "Koneksi: ${USER1}@${HOST1}:${PORT1} -> ${USER2}@${HOST2}:${PORT2}" >> $LOG_FILE
echo "----- Log Koneksi -----" >> $LOG_FILE

# Kirim notifikasi ke Telegram bahwa koneksi dimulai
send_to_telegram "🚀 <b>Memulai koneksi SSH berantai</b>
Host1: ${HOST1} -> Host2: ${HOST2}
Waktu: $(date)"

# Pastikan sshpass terinstall
which sshpass >/dev/null || sudo apt-get install -y sshpass

# Coba login ke SSH server pertama dan dari sana ke server kedua, jalankan btop
echo "Mencoba koneksi SSH berantai..." | tee -a $LOG_FILE
sshpass -p "$PASS1" ssh -t -p "$PORT1" "$USER1@$HOST1" "which sshpass >/dev/null || (echo 'Menginstall sshpass...' && sudo apt-get update && sudo apt-get install -y sshpass); echo 'Terhubung ke server kedua...'; sshpass -p '$PASS2' ssh -t -p '$PORT2' '$USER2@$HOST2' 'which btop >/dev/null || (echo \"Menginstall btop...\" && sudo apt-get update && sudo apt-get install -y btop); btop; bash -l'; echo 'Kembali ke server pertama'; bash -l" 2>> $LOG_FILE

# Simpan status exit
EXIT_CODE=$?

# Log status exit
echo "Sesi SSH telah berakhir dengan kode: $EXIT_CODE" | tee -a $LOG_FILE

# Kirim notifikasi ke Telegram bahwa koneksi berakhir
send_to_telegram "⚠️ <b>Sesi SSH berantai telah berakhir</b>
Host1: ${HOST1} -> Host2: ${HOST2}
Kode Exit: ${EXIT_CODE}
Waktu Berakhir: $(date)"

# Kirim file log ke Telegram
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendDocument" \
    -F chat_id="${TELEGRAM_CHAT_ID}" \
    -F document=@"$LOG_FILE" \
    -F caption="Log SSH: $(date)"

echo "File log disimpan di: $LOG_FILE"
