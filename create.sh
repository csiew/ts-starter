#!/bin/sh

echo "Number of arguments provided: $#"

if (( $# -ge 1 )); then
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

ts_starter_src="$(pwd)/ts-starter"

echo "ts_starter location: ${ts_starter_src}"

if [ -d "$ts_starter_src" ]; then
  echo "ts_starter dir is present"
else
  echo "ts_starter dir not present"
  exit 1
fi

if [ -d "$target_path" ]; then
  echo "Target directory already exists: ${target_path}"
  exit 1
else
  mkdir "$target_path"
fi

cd $target_path
target_path_full=$(pwd)
echo "Target location: ${target_path_full}"

echo "Installing base dev dependencies..."
npm init -y
if [ `npm list -g | grep -c typescript` -eq 0 ]; then
  echo "It looks like you do not have TypeScript installed!"
  echo "Please install using: npm i -g typescript"
fi
if [ `npm list -g | grep -c ts-node` -eq 0 ]; then
  echo "It looks like you do not have ts-node installed!"
  echo "Please install using: npm i -g ts-node"
fi
npm i -D ts-node-dev eslint @types/node @types/validator

if [ "$project_type" = "api" ]; then
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
