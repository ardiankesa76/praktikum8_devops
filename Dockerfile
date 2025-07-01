# Gunakan image PHP CLI sebagai base
FROM php:8.1-cli

# Set direktori kerja di dalam kontainer
WORKDIR /var/www/html

# Salin semua file dari direktori saat ini (workspace Jenkins) ke dalam direktori kerja kontainer
COPY . .

# Instal dependensi sistem yang diperlukan:
# PASTIKAN GIT DIINSTAL DI SINI, SEBELUM DIGUNAKAN!
RUN apt-get update && \
    apt-get install -y \
    unzip \
    git \
    curl \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Perbaikan untuk "dubious ownership" Git: Beri tahu Git bahwa direktori ini aman
# Sekarang Git sudah terinstal, jadi perintah ini akan berfungsi
RUN git config --global --add safe.directory /var/www/html

# Instal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instal dependensi PHP menggunakan Composer
# Meningkatkan timeout proses Composer menjadi 300 detik (5 menit) untuk mengatasi potensi timeout jaringan
RUN COMPOSER_PROCESS_TIMEOUT=300 composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Unduh dan instal PHPUnit secara global
RUN curl -L https://phar.phpunit.de/phpunit-9.phar -o /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit