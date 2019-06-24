#!/bin/bash

common="`mktemp`"
curl -sSL "http://init.alibhai.co/js/common.sh" > $common
source $common

mkdir -p src

echo "Setting up linter ..."
fetch_file ".prettierrc"
fetch_file ".eslintrc"
jq '.scripts = .scripts // {}' package.json > package.new.json && mv package.new.json package.json
jq '.scripts.lint = .scripts.lint // "eslint src/**/*.js"' package.json > package.new.json && mv package.new.json package.json

echo "Setting up babel ..."
fetch_file ".babelrc-node" ".babelrc"
jq '.scripts.build = .scripts.build // "babel src -d dist"' package.json > package.new.json && mv package.new.json package.json
jq '.scripts.watch = .scripts.watch // "npm run build -- -w"' package.json > package.new.json && mv package.new.json package.json
