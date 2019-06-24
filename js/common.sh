#!/bin/bash
set -e
set -o pipefail
set -x

function fetch_file() {
	file="$1"

	output="$2"
	if test -z "$output"; then
		output="$file"
	fi

	if ! test -e "$output"; then
		echo "Creating: $output"
		curl -sSL "http://init.alibhai.co/$file" >> "$output"
	fi
}

function add_npm_script() {
	action="$1"
	cmd="$2"

	if test "`jq .scripts.$action package.json`" = "null"; then
		echo "Adding npm script: $action"
		jq '.scripts = .scripts // {}' package.json > package.new.json && mv package.new.json package.json
		jq ".scripts.$action = 'npm run build -- -w'" package.json | unexpand -t2 > package.new.json
		mv package.new.json package.json
	fi
}

if ! which jq &>/dev/null; then
	echo "jq is not installed, but is required"
	exit 1
fi

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
