# Gunakan image PHP CLI sebagai base
FROM php:8.1-cli

# Set direktori kerja di dalam kontainer
WORKDIR /var/www/html

# Salin semua file dari direktori saat ini (workspace Jenkins) ke dalam direktori kerja kontainer
# Ini akan menyalin kode aplikasi Anda, termasuk composer.json dan composer.lock
COPY . .

# Instal dependensi sistem yang diperlukan:
# - apt-get update: Memperbarui daftar paket
# - apt-get install -y: Menginstal paket tanpa konfirmasi
# - unzip: Diperlukan oleh Composer
# - git: Diperlukan oleh Composer untuk mengunduh dependensi dari repositori Git
# - curl: Diperlukan untuk mengunduh Composer dan PHPUnit phar
RUN apt-get update && \
    apt-get install -y \
    unzip \
    git \
    curl \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Instal Composer
# Unduh Composer installer
# Jalankan installer PHP untuk menginstal Composer secara global
# Hapus installer setelah selesai
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instal dependensi PHP menggunakan Composer
# --no-dev: Jika Anda tidak ingin menginstal dependensi pengembangan di image produksi
# --optimize-autoloader: Untuk performa yang lebih baik
# --no-interaction: Menghindari pertanyaan interaktif
# --prefer-dist: Mengunduh dari rilis terkompresi (lebih cepat)
# Pastikan file composer.json dan composer.lock ada di direktori kerja
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Unduh dan instal PHPUnit secara global
# -L: Mengikuti redirect
# -o /usr/local/bin/phpunit: Menyimpan file sebagai phpunit di /usr/local/bin
# chmod +x: Membuat file dapat dieksekusi
RUN curl -L https://phar.phpunit.de/phpunit-9.phar -o /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit

# Anda bisa menambahkan COMMAND di sini jika Anda ingin kontainer menjalankan sesuatu secara default
# Contoh: CMD ["php", "index.php"]
