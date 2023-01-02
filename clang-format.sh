#! /bin/bash

function clang_format() {
	echo "finding files..."
	find . -type f \( \
		-name "*.c" -o \
		-name "*.cpp" -o \
		-name "*.cc" -o \
		-name "*.h" -o \
		-name "*.hpp" -o \
		-name "*.hh" -o \
		-name "*.m" -o \
		-name "*.mm" \
		\) \
		-not -path "*/target/*" \
		-not -path "*/node_modules/*" \
		-not -path "*/build/*" \
		-not -path "*/ephemeral/*" \
		-print0 | xargs -0 clang-format --verbose --style=file -i
}

function find_clang_format() {
	# Check if clang-format is installed
	if ! command -v clang-format >/dev/null 2>&1; then
		echo "Error: clang-format is not installed"
		exit 1
	fi
}

function main() {
	cd ..
	echo "Running clang-format..."
	find_clang_format
	clang_format
}

main
