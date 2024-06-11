FROM debian:bookworm-slim
ARG USERID=10001
ARG CUSTOM_PHP_INI_FILE="dev.zz-custom.ini"
ARG PHP_VERSION="8.3"
ARG S6_VERSION="v3.1.6.2"
ARG PHP_INI_DIR="/etc/php/8.3/apache/conf.d"

## Install packages needed for later commands and that are just useful when
## running containers.
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
  lsb-release \
  ca-certificates \
  curl \
  vim \
  inetutils-ping \
  iproute2 \
  xz-utils \
  bzip2 \
  file \
  media-types \
  unzip \
  git \
  procps

## Configure vim to not use mouse interaction since that messes with things when working in the container.
COPY docker-config/etc-vim-vimrc.local /etc/vim/vimrc.local

## Install s6-overlay
RUN DEBIAN_FRONTEND=noninteractive curl -o /opt/s6-overlay-noarch.tar.xz -L https://github.com/just-containers/s6-overlay/releases/download/$S6_VERSION/s6-overlay-noarch.tar.xz
RUN DEBIAN_FRONTEND=noninteractive curl -o /opt/s6-overlay-x86_64.tar.xz -L https://github.com/just-containers/s6-overlay/releases/download/$S6_VERSION/s6-overlay-x86_64.tar.xz
RUN DEBIAN_FRONTEND=noninteractive tar -C / -Jxpf /opt/s6-overlay-noarch.tar.xz
RUN DEBIAN_FRONTEND=noninteractive tar -C / -Jxpf /opt/s6-overlay-x86_64.tar.xz
RUN DEBIAN_FRONTEND=noninteractive rm -f /opt/s6-overlay-noarch.tar.xz
RUN DEBIAN_FRONTEND=noninteractive rm -f /opt/s6-overlay-x86_64.tar.xz

## Add Ondrej Sury's PHP package repository
RUN DEBIAN_FRONTEND=noninteractive curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/debsuryorg-archive-keyring.deb
RUN DEBIAN_FRONTEND=noninteractive sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN DEBIAN_FRONTEND=noninteractive apt-get update

## Install the packages we need for our Drupal site.
## Note that installing libapache2-mod-php8.3 enables these features/extensions by default:
## ctype, date, exif, ffi, fileinfo, filter, ftp, gettext, hash, iconv, json, openssl, pcntl,
## pcre, pdo, phar, posiz, random, readline, reflection, session, shmop, sockets, sodium,
## spl, standard, sysvmsg, sysvsem, sysvshm, tokenizer.
## OPcache, zlib.
## For apache, these Apache 2.4 Modules are enabled by default:
## mpm_event, authz_core, authz_host, authn_core, auth_basic, access_compat, authn_file,
## authz_user, alias, dir, autoindex, env, mime, negotiation, php8.3, setenvif, filter, deflate,
## status, reqtimeout
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apache2 \
    libapache2-mod-php$PHP_VERSION \
    php$PHP_VERSION-apcu \
    php$PHP_VERSION-bcmath \
    php$PHP_VERSION-gd \
    php$PHP_VERSION-mbstring \
    php$PHP_VERSION-imagick \
    php$PHP_VERSION-mysql \
    php$PHP_VERSION-xml \
    php$PHP_VERSION-zip \
    mariadb-client

## Clean out unneeded files
RUN DEBIAN_FRONTEND=noninteractive rm -rf /var/lib/apt /var/log/apt* /var/cache/* /var/log/dpkg*

## Add a user with the correct user id so that dev instances
## will get the current user, and deployed instances
## can be set to something predictable so file permissions
## can also be set properly.
RUN groupadd --gid $USERID webuser \
    && useradd --uid $USERID --gid $USERID webuser

## Enable PHP extensions:
RUN DEBIAN_FRONTEND=noninteractive /usr/sbin/phpenmod apcu bcmath gd opcache imagick pdo_mysql zip
## Disable some PHP extensions:
RUN DEBIAN_FRONTEND=noninteractive /usr/sbin/phpdismod ftp

## Enable Apache modules
RUN DEBIAN_FRONTEND=noninteractive /usr/sbin/a2enmod rewrite remoteip

## Copy PHP config
COPY docker-config/php/$CUSTOM_PHP_INI_FILE "$PHP_INI_DIR/zz-custom.ini"

## Adjust Apache config
COPY docker-config/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/www-data/webuser/g' /etc/apache2/envvars

## Configure S6
RUN mkdir -p /etc/s6-overlay/
COPY docker-config/s6/ /etc/s6-overlay/s6-rc.d/

# Create a directory outside of docroot for uploaded files
RUN mkdir /drupal_private \
    && chown -R webuser:webuser /drupal_private \
    && find /drupal_private -type f -exec chmod 600 '{}' \;

# Change the owner and group of /var/www.
RUN chown -R webuser:webuser /var/www/
# Copy the src directory piece by piece to take advantage
# of Docker's build cache.

COPY --chown=10001:10001 src/web/*.php /var/www/html/web/
COPY --chown=10001:10001 src/web/.htaccess /var/www/html/web/.htaccess
COPY --chown=10001:10001 src/web/robots.txt /var/www/html/web/robots.txt
COPY --chown=10001:10001 src/web/profiles /var/www/html/web/profiles
COPY --chown=10001:10001 docker-config/drupal/settings.php /var/www/html/web/sites/default/settings.php
COPY --chown=10001:10001 docker-config/drupal/dev.services.yml /var/www/html/web/sites/dev.services.yml

RUN chmod 640 /var/www/html/web/*.php \
    && chmod 640 /var/www/html/web/.htaccess \
    && chmod 640 /var/www/html/web/robots.txt \
    && chmod 640 /var/www/html/web/sites/default/settings.php \
    && find /var/www/html/web/profiles -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
    && find /var/www/html/web/profiles -type f -exec chmod u=rw,g=r,o= '{}' \;

COPY --chown=10001:10001 src/web/sites /var/www/html/web/sites
RUN find /var/www/html/web/sites -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
    && find /var/www/html/web/sites -type f -exec chmod u=rw,g=r,o= '{}' \;

COPY --chown=10001:10001 src/web/core /var/www/html/web/core
RUN find /var/www/html/web/core -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
    && find /var/www/html/web/core -type f -exec chmod u=rw,g=r,o= '{}' \;

#COPY --chown=10001:10001 src/web/libraries /var/www/html/web/libraries
#RUN find /var/www/html/web/libraries -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
#    && find /var/www/html/web/libraries -type f -exec chmod u=rw,g=r,o= '{}' \;

COPY --chown=10001:10001 src/web/themes /var/www/html/web/themes
RUN find /var/www/html/web/themes -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
    && find /var/www/html/web/themes -type f -exec chmod u=rw,g=r,o= '{}' \;

#COPY --chown=10001:10001 src/web/themes/contrib /var/www/html/web/themes/contrib
#RUN find /var/www/html/web/themes/contrib -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
#    && find /var/www/html/web/themes/contrib -type f -exec chmod u=rw,g=r,o= '{}' \;

COPY --chown=10001:10001 src/web/modules /var/www/html/web/modules
RUN find /var/www/html/web/modules -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
    && find /var/www/html/web/modules -type f -exec chmod u=rw,g=r,o= '{}' \;

COPY --chown=10001:10001 src/web/modules/contrib /var/www/html/web/modules/contrib
RUN find /var/www/html/web/modules/contrib -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
    && find /var/www/html/web/modules/contrib -type f -exec chmod u=rw,g=r,o= '{}' \;

# Composer dependencies might change more often than custom
# modules or themes, if that is case, move these sections
# down to speed things up.
COPY --chown=10001:10001 src/composer* /var/www/html/
COPY --chown=10001:10001 src/vendor /var/www/html/vendor
RUN chmod 640 /var/www/html/composer* \
    && find /var/www/html/vendor -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
    && find /var/www/html/vendor -type f -exec chmod u=rw,g=r,o= '{}' \;

# Make sure drush is excutable
RUN chmod +x /var/www/html/vendor/bin/drush

# When you have multiple custom modules and/or themes,
# it might be a good idea to split up the copy commands
# per custom module and/or custom theme.

#COPY --chown=10001:10001 src/web/themes/custom /var/www/html/web/themes/custom
#RUN find /var/www/html/web/themes/custom -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
#    && find /var/www/html/web/themes/custom -type f -exec chmod u=rw,g=r,o= '{}' \;

#COPY --chown=10001:10001 src/web/modules/custom /var/www/html/web/modules/custom
#RUN find /var/www/html/web/modules/custom -type d -exec chmod u=rwx,g=rx,o= '{}' \; \
#    && find /var/www/html/web/modules/custom -type f -exec chmod u=rw,g=r,o= '{}' \;

# Config sync is likely the directory that will change the most often.
COPY --chown=10001:10001 src/config_sync /var/www/html/config_sync
RUN chmod 755 /var/www/html/config_sync \
    && find /var/www/html/config_sync -type f -exec chmod u=rw,g=rw,o= '{}' \;

ENTRYPOINT ["/init"]