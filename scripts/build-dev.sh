#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
cd $SCRIPT_DIR/../;
source .env;
docker pull debian:bookworm-slim;
docker buildx build \
      --tag="$WATERDROP_DEV_IMAGE_TAG" \
      --build-arg USERID=$(id -u) \
      --build-arg PHP_VERSION=$PHP_VERSION \
      --build-arg CUSTOM_PHP_INI_FILE=dev.zz-custom.ini \
      --build-arg S6_VERSION=v3.1.6.2 \
      --build-arg PHP_INI_DIR=/etc/php/$PHP_VERSION/apache/conf.d \
      app