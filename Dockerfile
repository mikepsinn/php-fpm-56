FROM php:5.6-fpm

MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>

ADD ./laravel.ini /usr/local/etc/php/conf.d
ADD ./laravel.pool.conf /usr/local/etc/php-fpm.d/

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libmemcached-dev \
    curl \
    libpng12-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# install mcrypt library
RUN docker-php-ext-install mcrypt

# Install mongodb driver
RUN pecl install mongodb

# configure gd library
RUN docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-freetype-dir=/usr/include/freetype2

# Install extensions using the helper script provided by the base image
RUN docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql \
    gd \
    mysqli \
    sockets \
    bcmath

# Install memcached
RUN pecl install memcached \
    && docker-php-ext-enable memcached

# Install xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
