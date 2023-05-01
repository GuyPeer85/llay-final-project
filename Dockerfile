# Sets the second base image to use as PHP 7.4 with FastCGI Process Manager (FPM)
FROM php:7.4-fpm  

# Updates the list of available packages and installs the Nginx web server
RUN apt-get update && apt-get install -y nginx

# Installs the PHP extensions for MySQL and PDO
RUN docker-php-ext-install mysqli pdo pdo_mysql  

COPY nginx.conf /etc/nginx/nginx.conf  

RUN mkdir -p /var/www/html/app  

COPY index.php /var/www/html/app/  

EXPOSE 80  

# Configures PHP-FPM to run in the foreground
CMD sed -i 's/;daemonize = yes/daemonize = no/g' /usr/local/etc/php-fpm.conf && \
    # Configures PHP-FPM to listen on port 9000
    sed -i 's/listen = \/var\/run\/php\/php7.4-fpm.sock/listen = 127.0.0.1:9000/g' /usr/local/etc/php-fpm.d/www.conf && \
    # Starts the Nginx server
    nginx && \
    # Starts the PHP FastCGI Process Manager (FPM)
    php-fpm