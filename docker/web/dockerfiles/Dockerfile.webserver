# Utilizamos la ultima imagen de ubuntu como imagen base
FROM ubuntu:24.04

# Establecemos el timezone
ENV TZ=Europe/Madrid

# 1. Instalamos el comando add-apt-repository y añadimos el PPA de Ondřej Surý
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common gnupg2 ca-certificates && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update

# Instalamos Apache y PHP
RUN apt-get install -y --no-install-recommends \
    apache2 \
    php8.5=8.5.12* \
    libapache2-mod-php8.5=8.5.12* \
    php8.5-cli=8.5.12* \
    php8.5-common=8.5.12* \
    php8.5-mysql=8.5.12* \
    php8.5-pgsql=8.5.12* \
    php8.5-sqlite3=8.5.12* \
    php8.5-gd=8.5.12* \
    php8.5-zip=8.5.12* \
    php8.5-bcmath=8.5.12* \
    php8.5-mbstring=8.5.12* \
    php8.5-xml=8.5.12* \
    php8.5-curl=8.5.12* \
    php8.5-intl=8.5.12* \
    unzip \
    zip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Desactivamos el modulo autoindex
RUN a2dismod -f autoindex

# Activamos los módulos rewrite y SSL
RUN a2enmod rewrite
RUN a2enmod ssl

# Creamos directorios necesarios con permisos para el usuario de apache
RUN mkdir -p /var/run/apache2 /var/lock/apache2 /var/log/apache2
RUN chown -R www-data:www-data \
 /var/run/apache2 /var/lock/apache2 /var/log/apache2

# Establecemos el directorio de trabajo en el directorio web raiz
WORKDIR /var/www/html/

# Copiamos nuestra aplicacion al directorio de trabajo del contenedor
COPY ./app /var/www/html/

# Instalamos Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalamos las dependencias de Composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Establecer permisos para Laravel
RUN chown -R www-data:www-data \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache && \
    chmod -R 775 \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache

# Establecemos la raiz web de Apache en el directorio public del proyecto
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copiamos el archivo de configuración de la página y ejecutamos a2enmod
COPY ./config/tallerdigital-ssl.conf /etc/apache2/sites-available/tallerdigital-ssl.conf
RUN a2dissite 000-default && a2ensite tallerdigital-ssl

# Cambiamos de usuario
USER www-data

# Ponemos el puerto 80 del contenedor en escucha
EXPOSE 80

# Levantamos el demonio de Apache
CMD ["apachectl", "-D", "FOREGROUND"]