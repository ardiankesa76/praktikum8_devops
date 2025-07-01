FROM php:8.1-cli

WORKDIR /var/www/html

COPY . .

RUN apt-get update && apt-get install -y unzip git

# Install PHPUnit secara manual
RUN curl -L https://phar.phpunit.de/phpunit-9.phar -o /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

CMD [ "php", "index.php" ]
