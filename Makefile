.PHONY: setup fix-keymap build-left build-right clean

# Default target
all: setup fix-keymap

# Setup the ZMK environment
setup:
	@echo "Setting up ZMK environment..."
	@chmod +x ./setup-zmk-local.sh
	@./setup-zmk-local.sh

# Fix the keymap file
fix-keymap:
	@echo "Fixing keymap file..."
	@chmod +x ./fix-keymap.sh
	@./fix-keymap.sh

# Build left half firmware
build-left:
	@echo "Building left half firmware..."
	@chmod +x ./build-left.sh
	@./build-left.sh

# Build right half firmware
build-right:
	@echo "Building right half firmware..."
	@chmod +x ./build-right.sh
	@./build-right.sh

# Clean build files
clean:
	@echo "Cleaning build files..."
	@rm -rf zmk-build

help:
	@echo "ZMK Build System"
	@echo "----------------"
	@echo "make setup      - Set up the ZMK environment"
	@echo "make fix-keymap - Fix issues in the keymap file"
	@echo "make build-left - Build firmware for left half"
	@echo "make build-right- Build firmware for right half"
	@echo "make clean      - Clean build directory"
	@echo "make all        - Setup and fix keymap" 