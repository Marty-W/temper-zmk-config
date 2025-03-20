#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================================================${NC}"
echo -e "${BLUE}     Welcome to the Temper ZMK Configuration Setup!              ${NC}"
echo -e "${BLUE}==================================================================${NC}"
echo
echo -e "This interactive script will help you set up your development environment"
echo -e "and guide you through the process of building and flashing firmware for"
echo -e "your Temper keyboard."
echo

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo -e "${RED}Warning: This script is optimized for macOS. Some parts may not work correctly on your system.${NC}"
  read -p "Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting..."
    exit 1
  fi
fi

echo -e "${YELLOW}What would you like to do?${NC}"
echo -e "1) Set up the local development environment (first-time setup)"
echo -e "2) Fix the keymap file to resolve build errors"
echo -e "3) Build firmware for the left half"
echo -e "4) Build firmware for the right half"
echo -e "5) Read the documentation"
echo -e "6) Exit"
echo

read -p "Enter your choice (1-6): " choice

case $choice in
  1)
    echo -e "${YELLOW}Setting up the local development environment...${NC}"
    make setup
    echo -e "${GREEN}Setup complete! You can now build firmware for your keyboard.${NC}"
    ;;
  2)
    echo -e "${YELLOW}Fixing keymap file...${NC}"
    make fix-keymap
    echo -e "${GREEN}Keymap file has been fixed. You should now be able to build without errors.${NC}"
    ;;
  3)
    echo -e "${YELLOW}Building firmware for the left half...${NC}"
    make build-left
    echo -e "${GREEN}Build process completed. Check for any errors above.${NC}"
    ;;
  4)
    echo -e "${YELLOW}Building firmware for the right half...${NC}"
    make build-right
    echo -e "${GREEN}Build process completed. Check for any errors above.${NC}"
    ;;
  5)
    if command -v less &> /dev/null; then
      less LOCAL_DEV.md
    else
      cat LOCAL_DEV.md
    fi
    ;;
  6)
    echo -e "${BLUE}Goodbye!${NC}"
    exit 0
    ;;
  *)
    echo -e "${RED}Invalid choice. Please run the script again and select a valid option (1-6).${NC}"
    exit 1
    ;;
esac

echo
echo -e "${BLUE}What would you like to do next?${NC}"
echo -e "- Run ${YELLOW}./start-here.sh${NC} to return to this menu"
echo -e "- Run ${YELLOW}make help${NC} to see available make commands"
echo -e "- Edit ${YELLOW}boards/shields/temper/temper.keymap${NC} to customize your keyboard"
echo
echo -e "${GREEN}Happy hacking!${NC}" 