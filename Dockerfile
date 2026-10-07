# ============================================================
# TCExam — Production Dockerfile (Alpine Linux + PHP 8.2-FPM)
# ============================================================

FROM php:8.2-fpm-alpine

LABEL maintainer="Tecnick.com LTD <info@tecnick.com>"
LABEL description="TCExam Computer-Based Assessment System"

# 1. Install build dependencies and runtime libraries
RUN apk add --no-cache \
        bash \
        curl \
        freetype \
        freetype-dev \
        icu-dev \
        icu-libs \
        libjpeg-turbo \
        libjpeg-turbo-dev \
        libpng \
        libpng-dev \
        libxml2-dev \
        libzip \
        libzip-dev \
        mariadb-client \
        oniguruma-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        curl \
        gd \
        intl \
        mbstring \
        mysqli \
        opcache \
        pdo_mysql \
        xml \
        zip \
    && apk del --no-cache \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        oniguruma-dev \
    && rm -rf /tmp/* /var/cache/apk/*

# 2. Configure PHP production overrides
COPY docker/php/php-custom.ini /usr/local/etc/php/conf.d/99-tcexam.ini

# 3. Copy application codebase
WORKDIR /var/www/html
COPY . /var/www/html

# 4. Prepare entrypoint script
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 5. Set up initial permissions
RUN mkdir -p /var/www/html/cache /var/www/html/admin/backup \
    && chown -R www-data:www-data /var/www/html/cache /var/www/html/admin/backup

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
