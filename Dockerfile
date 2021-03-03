FROM vixns/php-nginx:8.0-debian

COPY ./docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./docker/opcache/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

USER root

RUN apt-get update && apt-get install -y unzip libzip-dev libpq-dev git
RUN docker-php-ext-configure zip \
&& docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo_pgsql zip

RUN HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1); \
    setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var; \
    setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var;

RUN chown -R www-data:www-data /var/www /run /var/lib/nginx;

USER www-data

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

ENV PATH="${PATH}:/root/.composer/vendor/bin"
