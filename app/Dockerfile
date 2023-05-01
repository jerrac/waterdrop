ARG php8_apache_image_tag
FROM php:$php8_apache_image_tag as aptupdate
RUN apt-get update

FROM php:$php8_apache_image_tag as buildbase
ARG php8_apache_extensions_directory

#FROM buildbase as install_bcmath
#RUN docker-php-ext-install bcmath && docker-php-ext-enable bcmath
#
#FROM buildbase as install_calendar
#RUN docker-php-ext-install calendar && docker-php-ext-enable calendar
#
#FROM buildbase as install_dba
#RUN docker-php-ext-install dba && docker-php-ext-enable dba
#
#FROM buildbase as install_dl_test
#RUN docker-php-ext-install dl_test && docker-php-ext-enable dl_test
#
#FROM buildbase as install_enchant
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libenchant-2-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install enchant && docker-php-ext-enable enchant
#
#FROM buildbase as install_exif
#RUN docker-php-ext-install exif && docker-php-ext-enable exif
#
#FROM buildbase as install_ffi
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libffi-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install ffi && docker-php-ext-enable ffi

FROM buildbase as install_gd
COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
RUN apt-get install -y --no-install-recommends \
       libfreetype-dev libjpeg-dev libpng-dev zlib1g-dev libavif-dev libwebp-dev libxpm-dev
RUN rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure gd --with-avif --with-webp --with-jpeg --with-xpm --with-freetype --enable-gd-jis-conv
RUN docker-php-ext-install -j$(nproc) gd

#FROM buildbase as install_gettext
#RUN docker-php-ext-install gettext && docker-php-ext-enable gettext
#
#FROM buildbase as install_gmp
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libgmp-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install -j$(nproc) gmp
#
#FROM buildbase as install_imap
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libc-client-dev libkrb5-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
#RUN docker-php-ext-install -j$(nproc) imap && docker-php-ext-enable imap
#
#FROM buildbase as install_intl
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libicu-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install -j$(nproc) intl && docker-php-ext-enable intl
#
#FROM buildbase as install_ldap
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libldap2-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install -j$(nproc) ldap && docker-php-ext-enable ldap
#
#FROM buildbase as install_mysqli
#RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
#
FROM buildbase as install_opcache
RUN docker-php-ext-enable opcache
#
#FROM buildbase as install_pcntl
#RUN docker-php-ext-install pcntl && docker-php-ext-enable pcntl
#
#FROM buildbase as install_pdo_dblib
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends freetds-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install -j$(nproc) pdo_dblib && docker-php-ext-enable pdo_dblib

FROM buildbase as install_pdo_mysql
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

FROM buildbase as install_pdo_pgsql
COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
RUN apt-get install -y --no-install-recommends libpq-dev
RUN rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install -j$(nproc) pdo_pgsql && docker-php-ext-enable pdo_pgsql

FROM buildbase as install_pgsql
COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
RUN apt-get install -y --no-install-recommends libpq-dev
RUN rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install -j$(nproc) pgsql && docker-php-ext-enable pgsql

#FROM buildbase as install_pspell
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libpspell-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install -j$(nproc) pspell && docker-php-ext-enable pspell
#
#FROM buildbase as install_shmop
#RUN docker-php-ext-install shmop && docker-php-ext-enable shmop
#
#FROM buildbase as install_snmp
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libsnmp-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install -j$(nproc) snmp && docker-php-ext-enable snmp
#
#FROM buildbase as install_soap
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libxml2-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install soap && docker-php-ext-enable soap
#
#FROM buildbase as install_sockets
#RUN docker-php-ext-install sockets && docker-php-ext-enable sockets
#
#FROM buildbase as install_sysvmsg
#RUN docker-php-ext-install sysvmsg && docker-php-ext-enable sysvmsg
#
#FROM buildbase as install_sysvsem
#RUN docker-php-ext-install sysvsem && docker-php-ext-enable sysvsem
#
#FROM buildbase as install_sysvshm
#RUN docker-php-ext-install sysvshm && docker-php-ext-enable sysvshm
#
#FROM buildbase as install_tidy
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libtidy-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install tidy && docker-php-ext-enable tidy
#
#FROM buildbase as install_xsl
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libxslt1-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install xsl && docker-php-ext-enable xsl
#
#FROM buildbase as install_zend_test
#RUN docker-php-ext-install zend_test && docker-php-ext-enable zend_test
#
#FROM buildbase as install_zip
#COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
#RUN apt-get install -y --no-install-recommends libzip-dev
#RUN rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install zip && docker-php-ext-enable zip
#
FROM buildbase as merge_exts
#COPY --from=install_bcmath $php8_apache_extensions_directory/bcmath.so $php8_apache_extensions_directory/bcmath.so
#COPY --from=install_bcmath /usr/local/etc/php/conf.d/docker-php-ext-bcmath.ini /usr/local/etc/php/conf.d/docker-php-ext-bcmath.ini
#
#COPY --from=install_calendar $php8_apache_extensions_directory/calendar.so $php8_apache_extensions_directory/calendar.so
#COPY --from=install_calendar /usr/local/etc/php/conf.d/docker-php-ext-calendar.ini /usr/local/etc/php/conf.d/docker-php-ext-calendar.ini
#
#COPY --from=install_dba $php8_apache_extensions_directory/dba.so $php8_apache_extensions_directory/dba.so
#COPY --from=install_dba /usr/local/etc/php/conf.d/docker-php-ext-dba.ini /usr/local/etc/php/conf.d/docker-php-ext-dba.ini
#
#COPY --from=install_dl_test $php8_apache_extensions_directory/dl_test.so $php8_apache_extensions_directory/dl_test.so
#COPY --from=install_dl_test /usr/local/etc/php/conf.d/docker-php-ext-dl_test.ini /usr/local/etc/php/conf.d/docker-php-ext-dl_test.ini
#
#COPY --from=install_enchant $php8_apache_extensions_directory/enchant.so $php8_apache_extensions_directory/enchant.so
#COPY --from=install_enchant /usr/local/etc/php/conf.d/docker-php-ext-enchant.ini /usr/local/etc/php/conf.d/docker-php-ext-enchant.ini
#COPY --from=install_enchant /usr/lib/x86_64-linux-gnu/libenchant-2* /usr/lib/x86_64-linux-gnu/
#
#COPY --from=install_exif $php8_apache_extensions_directory/exif.so $php8_apache_extensions_directory/exif.so
#COPY --from=install_exif /usr/local/etc/php/conf.d/docker-php-ext-exif.ini /usr/local/etc/php/conf.d/docker-php-ext-exif.ini
#
#COPY --from=install_ffi $php8_apache_extensions_directory/ffi.so $php8_apache_extensions_directory/ffi.so
#COPY --from=install_ffi /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini

COPY --from=install_gd $php8_apache_extensions_directory/gd.so $php8_apache_extensions_directory/gd.so
COPY --from=install_gd /usr/local/etc/php/conf.d/docker-php-ext-gd.ini /usr/local/etc/php/conf.d/docker-php-ext-gd.ini
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libpng* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libwebp* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libjpeg* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libXpm* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libfreetype* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libdav1d* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libgav* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libX11* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libabsl* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libxcb* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libavif* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libXau* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libXdmcp* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libbsd* /usr/lib/x86_64-linux-gnu/
COPY --from=install_gd /usr/lib/x86_64-linux-gnu/libmd* /usr/lib/x86_64-linux-gnu/

#COPY --from=install_gettext $php8_apache_extensions_directory/gettext.so $php8_apache_extensions_directory/gettext.so
#COPY --from=install_gettext /usr/local/etc/php/conf.d/docker-php-ext-gettext.ini /usr/local/etc/php/conf.d/docker-php-ext-gettext.ini
#
#COPY --from=install_gmp $php8_apache_extensions_directory/gmp.so $php8_apache_extensions_directory/gmp.so
#COPY --from=install_gmp /usr/local/etc/php/conf.d/docker-php-ext-gmp.ini /usr/local/etc/php/conf.d/docker-php-ext-gmp.ini
#
#COPY --from=install_imap $php8_apache_extensions_directory/imap.so $php8_apache_extensions_directory/imap.so
#COPY --from=install_imap /usr/local/etc/php/conf.d/docker-php-ext-imap.ini /usr/local/etc/php/conf.d/docker-php-ext-imap.ini
#COPY --from=install_imap /usr/lib/libc-client* /usr/lib/
#
#COPY --from=install_intl $php8_apache_extensions_directory/intl.so $php8_apache_extensions_directory/intl.so
#COPY --from=install_intl /usr/local/etc/php/conf.d/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
#
#COPY --from=install_ldap $php8_apache_extensions_directory/ldap.so $php8_apache_extensions_directory/ldap.so
#COPY --from=install_ldap /usr/local/etc/php/conf.d/docker-php-ext-ldap.ini /usr/local/etc/php/conf.d/docker-php-ext-ldap.ini
#
#COPY --from=install_mysqli $php8_apache_extensions_directory/mysqli.so $php8_apache_extensions_directory/mysqli.so
#COPY --from=install_mysqli /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini

COPY --from=install_opcache $php8_apache_extensions_directory/opcache.so $php8_apache_extensions_directory/opcache.so
COPY --from=install_opcache /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

#COPY --from=install_pcntl $php8_apache_extensions_directory/pcntl.so $php8_apache_extensions_directory/pcntl.so
#COPY --from=install_pcntl /usr/local/etc/php/conf.d/docker-php-ext-pcntl.ini /usr/local/etc/php/conf.d/docker-php-ext-pcntl.ini

COPY --from=install_pdo_mysql $php8_apache_extensions_directory/pdo_mysql.so $php8_apache_extensions_directory/pdo_mysql.so
COPY --from=install_pdo_mysql /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini

COPY --from=install_pdo_pgsql $php8_apache_extensions_directory/pdo_pgsql.so $php8_apache_extensions_directory/pdo_pgsql.so
COPY --from=install_pdo_pgsql /usr/local/etc/php/conf.d/docker-php-ext-pdo_pgsql.ini /usr/local/etc/php/conf.d/docker-php-ext-pdo_pgsql.ini
COPY --from=install_pdo_pgsql /usr/lib/x86_64-linux-gnu/libpq* /usr/lib/x86_64-linux-gnu/

COPY --from=install_pgsql $php8_apache_extensions_directory/pgsql.so $php8_apache_extensions_directory/pgsql.so
COPY --from=install_pgsql /usr/local/etc/php/conf.d/docker-php-ext-pgsql.ini /usr/local/etc/php/conf.d/docker-php-ext-pgsql.ini

#COPY --from=install_pspell $php8_apache_extensions_directory/pspell.so $php8_apache_extensions_directory/pspell.so
#COPY --from=install_pspell /usr/local/etc/php/conf.d/docker-php-ext-pspell.ini /usr/local/etc/php/conf.d/docker-php-ext-pspell.ini
#COPY --from=install_pspell /usr/lib/x86_64-linux-gnu/libaspell* /usr/lib/x86_64-linux-gnu/
#
#COPY --from=install_shmop $php8_apache_extensions_directory/shmop.so $php8_apache_extensions_directory/shmop.so
#COPY --from=install_shmop /usr/local/etc/php/conf.d/docker-php-ext-shmop.ini /usr/local/etc/php/conf.d/docker-php-ext-shmop.ini
#
#COPY --from=install_snmp $php8_apache_extensions_directory/snmp.so $php8_apache_extensions_directory/snmp.so
#COPY --from=install_snmp /usr/local/etc/php/conf.d/docker-php-ext-snmp.ini /usr/local/etc/php/conf.d/docker-php-ext-snmp.ini
#COPY --from=install_snmp /usr/lib/x86_64-linux-gnu/libnetsnmp* /usr/lib/x86_64-linux-gnu/
#COPY --from=install_snmp /usr/share/snmp /usr/share/snmp
#COPY --from=install_snmp /var/lib/snmp /var/lib/snmp
#COPY --from=install_snmp /etc/snmp /etc/snmp
#
#COPY --from=install_soap $php8_apache_extensions_directory/soap.so $php8_apache_extensions_directory/soap.so
#COPY --from=install_soap /usr/local/etc/php/conf.d/docker-php-ext-soap.ini /usr/local/etc/php/conf.d/docker-php-ext-soap.ini
#
#COPY --from=install_sockets $php8_apache_extensions_directory/sockets.so $php8_apache_extensions_directory/sockets.so
#COPY --from=install_sockets /usr/local/etc/php/conf.d/docker-php-ext-sockets.ini /usr/local/etc/php/conf.d/docker-php-ext-sockets.ini
#
#COPY --from=install_sysvmsg $php8_apache_extensions_directory/sysvmsg.so $php8_apache_extensions_directory/sysvmsg.so
#COPY --from=install_sysvmsg /usr/local/etc/php/conf.d/docker-php-ext-sysvmsg.ini /usr/local/etc/php/conf.d/docker-php-ext-sysvmsg.ini
#
#COPY --from=install_sysvsem $php8_apache_extensions_directory/sysvsem.so $php8_apache_extensions_directory/sysvsem.so
#COPY --from=install_sysvsem /usr/local/etc/php/conf.d/docker-php-ext-sysvsem.ini /usr/local/etc/php/conf.d/docker-php-ext-sysvsem.ini
#
#COPY --from=install_sysvshm $php8_apache_extensions_directory/sysvshm.so $php8_apache_extensions_directory/sysvshm.so
#COPY --from=install_sysvshm /usr/local/etc/php/conf.d/docker-php-ext-sysvshm.ini /usr/local/etc/php/conf.d/docker-php-ext-sysvshm.ini
#
#COPY --from=install_tidy $php8_apache_extensions_directory/tidy.so $php8_apache_extensions_directory/tidy.so
#COPY --from=install_tidy /usr/local/etc/php/conf.d/docker-php-ext-tidy.ini /usr/local/etc/php/conf.d/docker-php-ext-tidy.ini
#COPY --from=install_tidy /usr/lib/x86_64-linux-gnu/libtidy* /usr/lib/x86_64-linux-gnu/
#
#COPY --from=install_xsl $php8_apache_extensions_directory/xsl.so $php8_apache_extensions_directory/xsl.so
#COPY --from=install_xsl /usr/local/etc/php/conf.d/docker-php-ext-xsl.ini /usr/local/etc/php/conf.d/docker-php-ext-xsl.ini
#COPY --from=install_xsl /usr/lib/x86_64-linux-gnu/libexslt* /usr/lib/x86_64-linux-gnu/
#COPY --from=install_xsl /usr/lib/x86_64-linux-gnu/libxslt* /usr/lib/x86_64-linux-gnu/
#
#COPY --from=install_zend_test $php8_apache_extensions_directory/zend_test.so $php8_apache_extensions_directory/zend_test.so
#COPY --from=install_zend_test /usr/local/etc/php/conf.d/docker-php-ext-zend_test.ini /usr/local/etc/php/conf.d/docker-php-ext-zend_test.ini
#
#COPY --from=install_zip $php8_apache_extensions_directory/zip.so $php8_apache_extensions_directory/zip.so
#COPY --from=install_zip /usr/local/etc/php/conf.d/docker-php-ext-zip.ini /usr/local/etc/php/conf.d/docker-php-ext-zip.ini
#COPY --from=install_zip  /usr/lib/x86_64-linux-gnu/libzip.so* /usr/lib/x86_64-linux-gnu/

FROM merge_exts as overlay_varnish
ARG S6_OVERLAY_VERSION=3.1.2.1

COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/

# Install required and useful packages.
RUN apt-get install -y --no-install-recommends \
    xz-utils \
    bind9-dnsutils \
    debian-archive-keyring \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    curl \
    gpg \
    mariadb-client \
    vim

# Configure varnish repo and install it.
RUN mkdir -p /etc/apt/keyrings/
RUN curl -fsSL https://packagecloud.io/varnishcache/varnish72/gpgkey | gpg --dearmor > /etc/apt/keyrings/varnishcache_varnish72-archive-keyring.gpg
COPY docker-config/varnish/etc-apt-sources-list-d-varnish72.list /etc/apt/sources.list.d/varnish72.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends varnish
RUN curl -fsSL https://packagecloud.io/varnishcache/varnish72/gpgkey | gpg --dearmor > /etc/apt/keyrings/varnishcache_varnish72-archive-keyring.gpg
COPY docker-config/varnish/etc-apt-sources-list-d-varnish72.list /etc/apt/sources.list.d/varnish72.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends varnish

# Clean up apt.
RUN rm -rf /var/lib/apt/lists/*

# Install S6-Overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
RUN rm -f /tmp/*.tar.xz

# Configure S6-Overlay.
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d
RUN mkdir -p /etc/s6-overlay/s6-rc.d/varnishd/contents.d
RUN mkdir -p /etc/s6-overlay/s6-rc.d/varnishncsa/contents.d
RUN mkdir -p /etc/s6-overlay/s6-rc.d/apache
RUN echo "longrun\n" > /etc/s6-overlay/s6-rc.d/apache/type
RUN echo "longrun\n" > /etc/s6-overlay/s6-rc.d/varnishd/type
RUN echo "longrun\n" > /etc/s6-overlay/s6-rc.d/varnishncsa/type
COPY docker-config/s6/etc-s6-overlay-s6-rc-d-apache-run /etc/s6-overlay/s6-rc.d/apache/run
COPY docker-config/s6/etc-s6-overlay-s6-rc-d-varnishd-run /etc/s6-overlay/s6-rc.d/varnishd/run
COPY docker-config/s6/etc-s6-overlay-s6-rc-d-varnishncsa-run /etc/s6-overlay/s6-rc.d/varnishncsa/run
RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/apache
RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/varnishd
RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/varnishncsa
RUN touch /etc/s6-overlay/s6-rc.d/varnishd/contents.d/apache
RUN touch /etc/s6-overlay/s6-rc.d/varnishncsa/contents.d/apache
# Configure Varnish
COPY docker-config/varnish/etc-varnish-default.vcl /etc/varnish/default.vcl

CMD ["/init"]

FROM overlay_varnish as waterdrop
ARG php_ini_file

# Add imagick here since it needs a lot of depenencies installed and
# is not easy to merge in all of them in the merge_ext section.
COPY --from=aptupdate /var/lib/apt/lists/ /var/lib/apt/lists/
RUN apt install -y --no-install-recommends \
    libmagickwand-dev \
    imagemagick

RUN yes '' | pecl install imagick
RUN docker-php-ext-enable imagick

# Clean up apt.
RUN rm -rf /var/lib/apt/lists/*

# Make sure php.ini and your custom php.ini files are set up correctly.
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY docker-config/php/$php_ini_file "$PHP_INI_DIR/conf.d/zz-custom.ini"

# Add a user with the most common linux user uid
RUN groupadd --gid 10001 webuser \
    && useradd --uid 10001 --gid 10001 webuser

# Configure apache to use the drupal web directory as docroot,
# then tell apache to use the webuser when it runs.
# That makes development easier when bind mounting your source files.
COPY docker-config/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/www-data/webuser/g' /etc/apache2/envvars
# Enable mod_rewrite and mod_remoteip
RUN a2enmod rewrite
RUN a2enmod remoteip

# If you are using any monitoring tools, consider enabling this line:
# RUN a2enmod status

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