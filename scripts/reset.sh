#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
ROOT_DIR=$SCRIPT_DIR/../;
cd "$ROOT_DIR";
source .env;
rm -rf app/src;
rm -f app/docker-config/drupal/settings.php;
rm -f dev.run.yml;
rm -f secrets/$PROJECTNAME*;
docker volume rm "${PROJECTNAME}_db_data";
docker volume rm "${PROJECTNAME}_app_data_public";
docker volume rm "${PROJECTNAME}_app_data_private";
docker volume rm "${PROJECTNAME}_share";
rm -f .env;
echo "Please remove the Docker network you created manually.";
echo "";
echo "";