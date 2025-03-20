# Local Development Setup for Temper ZMK Config

This guide explains how to set up a local development environment for your Temper keyboard ZMK configuration.

## Prerequisites

- **macOS**: The setup scripts are optimized for macOS. If using Linux or Windows, you'll need to modify the scripts.
- **Command Line**: Basic knowledge of terminal commands.
- **Python**: Python 3.8 or newer.
- **Git**: Git version control system.
- **ARM GCC Toolchain**: The ZMK build process requires the ARM GCC toolchain.
- **USB Connection**: For flashing the firmware.

## Setup

The build system has been set up with a Makefile to simplify common tasks. Here's how to get started:

### 1. Initial Setup

Run the setup command to install all necessary dependencies and prepare the ZMK environment:

```bash
make setup
```

This will:

- Install Homebrew (if not installed)
- Install required dependencies (cmake, ninja, python3, gperf, dtc, git, wget)
- Install West (the Zephyr meta-tool)
- Create a local ZMK build directory
- Initialize the west workspace
- Update west modules
- Create build scripts for both halves of the keyboard

### 2. Fix Keymap Issues

The `fix-keymap.sh` script addresses known issues in the keymap file that can cause build errors:

```bash
make fix-keymap
```

This will:

- Fix the ZMK_COMBO_8 macro definition
- Add any missing definitions like MASK_MODS
- Define the MOUSE layer
- Add desktop management key definitions

### 3. Build Firmware

To build the firmware for each half of the keyboard:

For the left half:

```bash
make build-left
```

For the right half:

```bash
make build-right
```

## Flashing the Firmware

After building, follow these steps to flash the firmware:

1. Put your nice!nano in bootloader mode by double-tapping the reset button.
2. Mount the USB drive that appears (typically named NICENANO).
3. Copy the appropriate UF2 file to the drive:
   - Left half: `zmk-build/build-left/zephyr/zmk.uf2`
   - Right half: `zmk-build/build-right/zephyr/zmk.uf2`
4. The board will automatically restart with the new firmware.

## Editing the Keymap

The main keymap file is located at:

```
boards/shields/temper/temper.keymap
```

After making changes, rebuild and flash the firmware using the steps above.

## Additional Commands

### Clean Build Files

To clean up build files and start fresh:

```bash
make clean
```

### Get Help

For a list of available commands:

```bash
make help
```

## Troubleshooting

### Build Errors

If you encounter build errors:

1. Check the error message for specific issues.
2. The most common issues are syntax errors in the keymap file.
3. Run `make fix-keymap` to fix common issues.
4. If errors persist, check the specific line mentioned in the error message.

### Flashing Issues

If you have trouble flashing:

1. Make sure your nice!nano is in bootloader mode (the LED should be pulsing).
2. Try a different USB cable or port.
3. Check if the NICENANO drive is mounted correctly.

## Advanced Configuration

For more advanced configuration options, refer to the [ZMK Documentation](https://zmk.dev/docs/).
