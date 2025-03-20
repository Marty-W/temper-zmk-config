#!/bin/bash
set -e

# Fix the problematic ZMK_COMBO_8 macro in the keymap file
KEYMAP_FILE="boards/shields/temper/temper.keymap"

echo "Fixing ZMK_COMBO_8 macro in $KEYMAP_FILE..."

# Create a backup
cp "$KEYMAP_FILE" "${KEYMAP_FILE}.bak"

# Add hm_combo definition before ZMK_COMBO_8 usage
sed -i.tmp '/#define ZMK_COMBO_8/,/ZMK_COMBO_6/c\
/* Combo Configuration */\
#define ZMK_COMBO_8(NAME, TAP, POS, LAYERS, COMBO_MS, IDLE_MS, HOLD, SIDE)     \\\
    ZMK_BEHAVIOR(hm_combo_##NAME, hold_tap,                                    \\\
        flavor = "balanced";                                                    \\\
        tapping-term-ms = <280>;                                               \\\
        quick-tap-ms = <QUICK_TAP_MS>;                                         \\\
        require-prior-idle-ms = <150>;                                         \\\
        hold-trigger-on-release;                                               \\\
        hold-trigger-key-positions = <SIDE THUMBS>;                            \\\
        bindings = <&kp>, <TAP>;                                               \\\
    )                                                                          \\\
    ZMK_COMBO_6(NAME, &hm_combo_##NAME HOLD 0, POS, LAYERS, COMBO_MS, IDLE_MS)' "$KEYMAP_FILE"

# Add MASK_MODS definition if missing
if ! grep -q "MASK_MODS" "$KEYMAP_FILE"; then
  MASK_MODS_DEF="\n/* Mask Mods Helper */\n#define MASK_MODS(NAME, MODS, BINDING) \\\n    ZMK_BEHAVIOR(NAME, mod_morph, \\\n        mods = <MODS>; \\\n        bindings = <BINDING>, <BINDING>; \\\n    )\n"
  
  # Insert MASK_MODS before Navigation Configuration section
  sed -i.tmp "/\/\* Navigation Configuration \*\//i\\$MASK_MODS_DEF" "$KEYMAP_FILE"
fi

# Define MOUSE layer if needed
if ! grep -q "#define MOUSE 5" "$KEYMAP_FILE"; then
  sed -i.tmp '/\/\* Layer Definitions \*\//,/SYS 4/ s/SYS 4/SYS 4\n#define MOUSE 5/' "$KEYMAP_FILE"
fi

# Define desktop management keys if needed
if ! grep -q "DSK_PREV" "$KEYMAP_FILE"; then
  DESKTOP_KEYS="\n/* Desktop Management Keys */\n#define DSK_PREV &kp LG(LC(LEFT))   // Previous desktop\n#define DSK_NEXT &kp LG(LC(RIGHT))  // Next desktop\n#define DSK_MGR &kp LG(TAB)       // Desktop manager\n#define PIN_APP &kp LG(LC(F))     // Pin application\n#define PIN_WIN &kp LG(LC(W))     // Pin window\n#define VOL_DOWN &kp C_VOL_DN    // Volume down\n"
  
  # Insert desktop keys before Custom Mac Keycodes section
  sed -i.tmp "/\/\* Custom Mac Keycodes \*\//i\\$DESKTOP_KEYS" "$KEYMAP_FILE"
fi

# Clean up temporary files
rm -f "${KEYMAP_FILE}.tmp"

echo "Fix applied successfully! A backup was saved to ${KEYMAP_FILE}.bak" 