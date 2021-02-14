FROM php:7.4-fpm

RUN apt-get update && apt-get -y upgrade \
    && apt-get install --no-install-recommends -y \
        libpq-dev \
        libmagickwand-dev \
        zlib1g-dev \
        libicu-dev \
        libzip-dev \
        libxslt-dev \
        curl \
        g++ \
        apt-utils \
        git \
        msmtp

RUN docker-php-ext-install \
        pdo \
        pdo_mysql \
        bcmath \
        intl \
        xsl \
        zip \
        soap \
        opcache \
        sockets \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd

# Copy configurations
# COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
# Disabled: https://github.com/magento/magento2-functional-testing-framework/issues/808
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./config.ini /usr/local/etc/php/conf.d
COPY ./config.pool.conf /usr/local/etc/php-fpm.d/

ARG HOST_UID=1000
RUN usermod -u ${HOST_UID} www-data && \
    groupmod -g ${HOST_UID} www-data


# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.10.20

RUN set -eux; \
  curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer; \
  php -r " \
    \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
      unlink('/tmp/installer.php'); \
      echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
      exit(1); \
    }"; \
  php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}; \
  composer --ansi --version --no-interaction;
RUN mkdir /composer && chown www-data:www-data /composer
RUN chown www-data:www-data /composer

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -;\
  apt-get install -y nodejs; \
  npm install -g grunt-cli

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apk/* \
    && apt-get -y autoremove && apt-get -y autoclean

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
