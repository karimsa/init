#!/bin/bash

common="`mktemp`"
curl -sSL "http://init.alibhai.co/js/common.sh" > $common
source $common

mkdir -p src

echo "Setting up babel ..."
fetch_file "babelrc-node.json" ".babelrc"
add_npm_script "build" "babel src -d dist"
add_npm_script "watch" "npm run build -- -w"

# add package target
add_npm_field "main" "dist/index.js"

run_npm_install
