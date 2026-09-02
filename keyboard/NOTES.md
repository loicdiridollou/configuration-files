# v1 keymap notes

This dir is gitignored (personal ZSA keymap), so there's no git history to fall back
on — this file is the only persistent record of intentional customizations beyond
what Oryx/Keymapp generates.

## Layer 1: top indicator LEDs forced off

The Voyager has two independent LED systems:
- Per-key RGB matrix (52 LEDs) — `ledmap[]` / `set_layer_color()` in `keymap.c`.
- 4 top-mounted single-color "indicator" LEDs (`STATUS_LED_1..4`, defined in
  `keyboards/zsa/voyager/voyager.h`). By stock default (`voyager.c`,
  `layer_state_set_kb()`), these binary-encode the active layer — layer 1 lights
  only `STATUS_LED_1`.

Requested behavior: those top LEDs should be **off** on layer 1 (other layers keep
the stock layer-bit-encoded pattern). Implemented via:

- `config.h`: `#define VOYAGER_USER_LEDS` — opts out of stock `layer_state_set_kb()`
  LED handling (see `keyboards/zsa/voyager/readme.md`, "Indicator LEDs" section).
- `keymap.c`: a `layer_state_set_user()` that replicates the stock per-layer
  `STATUS_LED_n(layer & (1 << (n-1)))` pattern for every layer except layer 1,
  where it forces all four off. Preserves the stock guards: skip if
  `rawhid_state.status_led_control` (Oryx/Keymapp has taken over) or if
  `!keyboard_config.led_level`.

**Gotcha:** a fresh "download config" from ZSA Oryx/Keymapp overwrites both
`config.h` and `keymap.c` in full, silently wiping this change. If the layer-1
indicator LEDs come back on after a config sync, that's why — just reapply the
two edits above (verbatim below) and `qmk compile -kb zsa/voyager -km v1` to verify.

### config.h — add after `RGB_MATRIX_STARTUP_SPD`

```c
// Take over the top-mounted indicator LEDs (STATUS_LED_1-4) ourselves instead
// of the stock layer-bit-encoded behavior, so layer 1 can force them off.
#define VOYAGER_USER_LEDS
```

### keymap.c — add after `keyboard_post_init_user()`

```c
// VOYAGER_USER_LEDS (config.h) hands control of the top indicator LEDs
// (STATUS_LED_1-4) to us. Replicate the stock layer-bit-encoded behavior,
// except layer 1 forces them all off.
layer_state_t layer_state_set_user(layer_state_t state) {
#ifdef COMMUNITY_MODULE_ORYX_ENABLE
  if (rawhid_state.status_led_control) {
    return state;
  }
#endif
  if (!keyboard_config.led_level) {
    return state;
  }
  uint8_t layer = get_highest_layer(state);
  if (layer == 1) {
    STATUS_LED_1(false);
    STATUS_LED_2(false);
    STATUS_LED_3(false);
    STATUS_LED_4(false);
  } else {
    STATUS_LED_1(layer & (1 << 0));
    STATUS_LED_2(layer & (1 << 1));
    STATUS_LED_3(layer & (1 << 2));
    STATUS_LED_4(layer & (1 << 3));
  }
  return state;
}
```
