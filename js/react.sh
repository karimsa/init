#!/bin/bash -e

common="`mktemp`"
curl -sSL "http://init.alibhai.co/js/common.sh" > $common
source $common

mkdir -p src/{views,components,lib}

fetch_file "js/react/index.html" "src/index.html"
fetch_file "js/react/app.jsx" "src/app.jsx"
fetch_file "js/react/lib/axios.js" "src/lib/axios.js"
fetch_file "js/react/views/home.jsx" "src/views/home.jsx"

npm install --save-dev \
	parcel-bundler

add_npm_script "start" "parcel src/index.html"
add_npm_script "build" "parcel build src/index.html"
