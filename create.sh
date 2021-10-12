#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "You must provide the target path"
  exit 1
fi

target_path=$1
ts_starter_parent=$(pwd)
ts_starter_src="${ts_starter_parent}/ts-starter"

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

  echo "Installing Node packages..."
  npm init -y
  npm list -g | grep typescript || npm i -g typescript
  npm i -D @types/node ts-node ts-node-dev express
  npm i sequelize pg pg-hstore
  
  echo "Copying config files..."
  cp $ts_starter_src/tsconfig.json $target_path_full/tsconfig.json
  cp $ts_starter_src/.eslintrc $target_path_full/.eslintrc
  cp $ts_starter_src/.eslintignore $target_path_full/.eslintignore
  
  echo "Done"
  exit 0
else
  echo "Target directory does not exist: ${target_path}"
fi

exit 1

