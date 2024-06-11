#!/usr/bin/env bash
# Remove the SCRIPT_DIR stuff if you keep this script in the root of your project.
# It assumes that this script is in a subdirectory of the project root.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
cd $SCRIPT_DIR/../;
if [[ -z $WORK_DIR ]]; then
  PROJECT_DIR=$(pwd);
fi
if [[ -z $WORK_DIR ]]; then
  WORK_DIR="/app"; # If you need to run composer in a subdirectory of your app, set that by setting `WORK_DIR="/app/path/to/dir"` before the command.
fi
if [[ -z $APP_SRC ]]; then
  APP_SRC="$PROJECT_DIR/app/src"; # Change this if you do not have your app source code in app/src.
fi
if [[ -z $COMPOSER_CACHE ]]; then
  COMPOSER_CACHE="$PROJECT_DIR/tmp/composer_cache"; # Change this if you have a different location for the composer cache.
fi
docker pull composer;
docker run --rm \
    --volume $APP_SRC:/app \
    --volume $COMPOSER_CACHE:/cache/composer_cache \
    --user $(id -u):$(id -g) \
    --workdir /app \
    -e COMPOSER_CACHE_DIR="/cache/composer_cache" \
    composer "$@";
