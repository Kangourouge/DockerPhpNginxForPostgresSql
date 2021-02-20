# DOCKER PHP-NGINX for postgreSQL

## Usage

### Dockerfile
```dockerfile
# Dockerfile
FROM kangourouge/php-nginx-for-postgres:7.4

# Overide nginx conf if needed.
COPY path/to/your.file.conf /etc/nginx/conf.d/default.conf:cached

# Overide php-fpm conf if needed.
COPY path/to/your.file.conf /usr/local/etc/php-fpm.d/www.conf
```
Then build and run
