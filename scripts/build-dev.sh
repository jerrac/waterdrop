#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
cd $SCRIPT_DIR/../;
source .env;
docker buildx build \
      --tag="$WATERDROP_DEV_IMAGE_TAG" \
      --build-arg php8_apache_image_tag=$PHP8_APACHE_IMAGE_TAG \
      --build-arg php8_apache_extensions_directory=$PHP8_APACHE_EXTENSIONS_DIRECTORY \
      --build-arg php_ini_file=dev.zz-custom.ini \
      app