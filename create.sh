#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "You must provide the target path"
  exit 1
fi

target_path=${1:-}
project_type=${2:-"base"}

case $project_type in
  api)
    echo "API project type selected"
    ;;
  base)
    echo "Base project type selected"
    ;;
  *)
    echo "Invalid project type. Must be one of: base, api"
    ;;
esac

ts_starter_src=$(pwd)

echo "ts_starter location: ${ts_starter_src}"

if [ -d "$ts_starter_src" ]; then
  echo "ts_starter dir is present"
else
  echo "ts_starter dir not present"
  exit 1
fi

if [ -d "$target_path" ]; then
  cd $target_path
  target_path_full=$(pwd)
  echo "Target location: ${target_path_full}"

  echo "Installing base dev dependencies..."
  npm init -y
  npm list -g | grep typescript || npm i -g typescript
  npm i -D ts-node ts-node-dev eslint @types/node @types/validator

  if [ "$project_type" -eq "api" ]; then
    echo "Installing API dev dependencies..."
    npm i express sequelize pg pg-hstore bcrypt dotenv
    npm i -D @types/express @types/sequelize @types/bcrypt jsonwebtoken @types/jsonwebtoken
  fi
  
  echo "Copying config files..."
  cp $ts_starter_src/tsconfig.json $target_path_full/tsconfig.json
  cp $ts_starter_src/.eslintrc $target_path_full/.eslintrc
  cp $ts_starter_src/.eslintignore $target_path_full/.eslintignore

  echo "Updating package.json scripts..."
  node $ts_starter_src/update_package_json.js
  
  echo "Done"
  exit 0
else
  echo "Target directory does not exist: ${target_path}"
fi

echo "Done"

exit 1

