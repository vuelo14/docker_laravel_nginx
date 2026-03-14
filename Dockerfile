FROM php:8.2-fpm-alpine

WORKDIR /var/www/html

# Menambahkan postgresql-dev ke build dependencies dan menginstal pdo_pgsql & pgsql
RUN apk update && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    oniguruma-dev \
    postgresql-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    && apk del .build-deps

# Menambahkan libpq (runtime untuk postgres), nodejs, dan npm
RUN apk add --no-cache \
    libwebp \
    libzip \
    libpng \
    jpeg \
    freetype \
    oniguruma \
    libpq \
    curl \
    git \
    bash \
    nodejs \
    npm

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN chown -R www-data:www-data /var/www/html

USER www-data

EXPOSE 9000
CMD ["php-fpm"]
