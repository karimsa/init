#!/bin/bash
set -e
set -o pipefail

function fetch_file() {
	file="$1"
	if ! test -e "$file"; then
		curl -sSL "http://init.alibhai.co/$file" >> "$file"
	fi
}

export projectDir="$PWD"
echo "Project directory: $projectDir"

echo "Installing tools ..."
npm install --save-dev --no-audit \
	eslint \
	prettier \
	eslint-config-prettier \
	eslint-config-standard \
	eslint-plugin-prettier \
	eslint-plugin-import \
	eslint-plugin-node \
	eslint-plugin-promise \
	eslint-plugin-standard \
	@babel/cli \
	@babel/core \
	@babel/preset-env

echo "Setting up .vscode ..."
mkdir -p .vscode
fetch_file ".vscode/extensions.json"
fetch_file ".vscode/settings.json"

echo "Setting up linter ..."
fetch_file ".prettierrc"
fetch_file ".eslintrc"

echo "Setting up babel ..."
fetch_file ".babelrc"
