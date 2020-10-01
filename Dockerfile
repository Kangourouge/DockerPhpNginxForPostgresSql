FROM vixns/php-nginx:7.3-debian

COPY ./docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

RUN apt-get update && apt-get install -y unzip libzip-dev libpq-dev git
RUN docker-php-ext-configure zip --with-libzip \
&& docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo_pgsql zip

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# install Hirak Prestissimo globally to speed up download of Composer packages (parallelized prefetching)
RUN set -eux; \
    composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --optimize-autoloader --classmap-authoritative; \
	composer clear-cache
ENV PATH="${PATH}:/root/.composer/vendor/bin"
