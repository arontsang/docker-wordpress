FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install  --no-install-recommends --no-install-suggests -y \
        git \
        ca-certificates \
        curl
RUN git clone --depth 1 --single-branch --branch 6.4.1 https://github.com/WordPress/WordPress.git /app
RUN curl https://github.com/rtCamp/login-with-google/archive/refs/tags/1.3.2.tar.gz -s -L | tar -xvz  -C /app/wp-content/plugins/


FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
      zlib1g-dev \
      libfreetype-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install gd mysqli

RUN groupadd -r wordpress && useradd --no-log-init -r -g wordpress wordpress
COPY --from=build --chown=wordpress:wordpress /app /var/www/html/
#ADD --chown=wordpress:wordpress https://raw.githubusercontent.com/docker-library/wordpress/ac65dab/wp-config-docker.php /var/apphome/wordpress/wp-config.php
COPY  --chown=wordpress:wordpress wp-config.php /var/www/html/wp-config.php
