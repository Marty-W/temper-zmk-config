#!/bin/bash
set -e

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up ZMK development environment...${NC}"

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo -e "${RED}This script is designed for macOS. Please modify for your OS.${NC}"
  exit 1
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
  echo -e "${YELLOW}Installing Homebrew...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo -e "${GREEN}Homebrew already installed.${NC}"
fi

# Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
brew update
brew install cmake ninja python3 gperf dtc git wget

# Install west if not already installed
if ! command -v west &> /dev/null; then
  echo -e "${YELLOW}Installing west...${NC}"
  pip3 install west
else
  echo -e "${GREEN}West already installed.${NC}"
fi

# Create a local ZMK build directory
WORKSPACE_DIR="$(pwd)"
BUILD_DIR="${WORKSPACE_DIR}/zmk-build"

if [ ! -d "$BUILD_DIR" ]; then
  echo -e "${YELLOW}Creating ZMK build directory at ${BUILD_DIR}...${NC}"
  mkdir -p "$BUILD_DIR"
else
  echo -e "${GREEN}ZMK build directory already exists.${NC}"
fi

# Initialize west workspace if not already initialized
if [ ! -d "$BUILD_DIR/.west" ]; then
  echo -e "${YELLOW}Initializing west workspace...${NC}"
  cd "$BUILD_DIR"
  west init -l "${WORKSPACE_DIR}/config"
else
  echo -e "${GREEN}West workspace already initialized.${NC}"
fi

# Update west modules
cd "$BUILD_DIR"
echo -e "${YELLOW}Updating west modules...${NC}"
west update

# Create build scripts for left and right halves
echo -e "${YELLOW}Creating build scripts...${NC}"

# Left half build script
cat > "${WORKSPACE_DIR}/build-left.sh" << 'EOF'
#!/bin/bash
set -e

WORKSPACE_DIR="$(pwd)"
BUILD_DIR="${WORKSPACE_DIR}/zmk-build"

cd "$BUILD_DIR"
echo "Building firmware for left half..."
west build -d build-left -b nice_nano_v2 -- -DZMK_CONFIG="${WORKSPACE_DIR}/config" -DSHIELD="temper_left" -DZMK_EXTRA_MODULES="${WORKSPACE_DIR}"

echo "Firmware built successfully!"
echo "Output file: ${BUILD_DIR}/build-left/zephyr/zmk.uf2"
echo "To flash, copy this file to your nice!nano while in bootloader mode."
EOF

# Right half build script
cat > "${WORKSPACE_DIR}/build-right.sh" << 'EOF'
#!/bin/bash
set -e

WORKSPACE_DIR="$(pwd)"
BUILD_DIR="${WORKSPACE_DIR}/zmk-build"

cd "$BUILD_DIR"
echo "Building firmware for right half..."
west build -d build-right -b nice_nano_v2 -- -DZMK_CONFIG="${WORKSPACE_DIR}/config" -DSHIELD="temper_right" -DZMK_EXTRA_MODULES="${WORKSPACE_DIR}"

echo "Firmware built successfully!"
echo "Output file: ${BUILD_DIR}/build-right/zephyr/zmk.uf2"
echo "To flash, copy this file to your nice!nano while in bootloader mode."
EOF

# Make scripts executable
chmod +x "${WORKSPACE_DIR}/build-left.sh"
chmod +x "${WORKSPACE_DIR}/build-right.sh"

echo -e "${GREEN}Setup complete!${NC}"
echo -e "${BLUE}To build the firmware:${NC}"
echo -e "  - For left half: ${YELLOW}./build-left.sh${NC}"
echo -e "  - For right half: ${YELLOW}./build-right.sh${NC}"
echo -e "${BLUE}To flash the firmware:${NC}"
echo -e "  1. Put your nice!nano in bootloader mode by double-tapping the reset button"
echo -e "  2. Copy the .uf2 file from the build directory to the USB drive that appears"
echo -e "     Left half: ${YELLOW}${BUILD_DIR}/build-left/zephyr/zmk.uf2${NC}"
echo -e "     Right half: ${YELLOW}${BUILD_DIR}/build-right/zephyr/zmk.uf2${NC}" 