#!/bin/bash
set -e
set -o pipefail

if test "$VERBOSE" = "true"; then
	set -x
fi

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

function add_npm_field() {
	key="$1"
	value="$2"

	if test "`jq .$key package.json`" = "null"; then
		echo "Adding $key to package.json: $value"
		jq ".$key = \"$value\"" package.json | unexpand -t2 > package.new.json
		mv package.new.json package.json
	fi
}

function add_npm_script() {
	action="$1"
	cmd="$2"

	if test "`jq .scripts.$action package.json`" = "null"; then
		echo "Adding npm script: $action"
		jq '.scripts = .scripts // {}' package.json > package.new.json
		mv package.new.json package.json
		jq ".scripts.$action = \"$cmd\"" package.json | unexpand -t2 > package.new.json
		mv package.new.json package.json
	fi
}

deps=""
devDeps=""

function add_npm_dep() {
	package="$1"
	if jq ".dependencies[\"$package\"]" package.json | grep -E '^null$' &>/dev/null; then
		deps="$deps $package"
	fi
}

function add_npm_dev_dep() {
	package="$1"
	if jq ".devDependencies[\"$package\"]" package.json | grep -E '^null$' &>/dev/null; then
		devDeps="$devDeps $package"
	fi
}

function run_npm_install() {
	if ! test -z "$deps"; then
		echo "Installing: $deps"
		npm install --save --no-audit $deps
	fi
	if ! test -z "$devDeps"; then
		echo "Installing: $devDeps"
		npm install --save-dev --no-audit $devDeps
	fi
}

function ignore_file() {
	if ! grep "$1" .gitignore &>/dev/null; then
		echo "Adding to gitignore: $1"
		echo "$1" >> .gitignore
	fi
}

if ! which jq &>/dev/null; then
	echo "jq is not installed, but is required"
	exit 1
fi

export projectDir="$PWD"
echo "Project directory: $projectDir"

if ! test -e "package.json"; then
	echo "Creating: package.json"
	echo '{}' > package.json
fi

ignore_file 'node_modules'
ignore_file '*.log'

echo "Installing tools ..."
add_npm_dev_dep eslint
add_npm_dev_dep prettier
add_npm_dev_dep eslint-config-prettier
add_npm_dev_dep eslint-config-standard
add_npm_dev_dep eslint-plugin-prettier
add_npm_dev_dep eslint-plugin-import
add_npm_dev_dep eslint-plugin-node
add_npm_dev_dep eslint-plugin-promise
add_npm_dev_dep eslint-plugin-standard
add_npm_dev_dep @babel/cli
add_npm_dev_dep @babel/core
add_npm_dev_dep @babel/preset-env

echo "Setting up .vscode ..."
mkdir -p .vscode
fetch_file "vscode/extensions.json" ".vscode/extensions.json"
fetch_file "vscode/settings.json" ".vscode/settings.json"

echo "Setting up linter ..."
fetch_file "prettier.json" ".prettierrc"
fetch_file "eslint.json" ".eslintrc"
add_npm_script "lint" "eslint src/**/*.js"
