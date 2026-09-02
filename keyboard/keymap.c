#include QMK_KEYBOARD_H
#include "version.h"
#define MOON_LED_LEVEL LED_LEVEL
#ifndef ZSA_SAFE_RANGE
#define ZSA_SAFE_RANGE SAFE_RANGE
#endif

enum custom_keycodes {
  RGB_SLD = ZSA_SAFE_RANGE,
  HSV_0_255_255,
  HSV_74_255_255,
  HSV_169_255_255,
};



#define DUAL_FUNC_0 LT(3, KC_F16)
#define DUAL_FUNC_1 LT(7, KC_G)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT_voyager(
    KC_EQUAL,       KC_1,           KC_2,           KC_3,           KC_4,           KC_5,                                           KC_6,           KC_7,           KC_8,           KC_9,           KC_0,           KC_MINUS,       
    KC_TAB,         KC_Q,           KC_W,           KC_E,           KC_R,           KC_T,                                           KC_Y,           KC_U,           KC_I,           KC_O,           KC_P,           KC_BSLS,        
    KC_ESCAPE,      MT(MOD_LCTL, KC_A),KC_S,           KC_D,           KC_F,           KC_G,                                           KC_H,           KC_J,           KC_K,           KC_L,           KC_SCLN,        DUAL_FUNC_0,    
    KC_LEFT_SHIFT,  MT(MOD_LALT, KC_Z),KC_X,           KC_C,           KC_V,           KC_B,                                           KC_N,           KC_M,           KC_COMMA,       KC_DOT,         MT(MOD_LCTL, KC_SLASH),KC_RIGHT_SHIFT, 
                                                    LT(2, KC_BSPC), MT(MOD_LGUI, KC_DELETE),                                MT(MOD_LSFT, KC_ENTER),LT(3, KC_SPACE)
  ),
  [1] = LAYOUT_voyager(
    KC_EQUAL,       KC_1,           KC_2,           KC_3,           KC_4,           KC_5,                                           KC_6,           KC_7,           KC_8,           KC_9,           KC_0,           KC_MINUS,       
    KC_TAB,         KC_Q,           KC_W,           KC_E,           KC_R,           KC_T,                                           KC_Y,           KC_U,           KC_I,           KC_O,           KC_P,           KC_BSLS,        
    KC_ESCAPE,      MT(MOD_LCTL, KC_A),KC_S,           KC_D,           KC_F,           KC_G,                                           KC_H,           KC_J,           KC_K,           KC_L,           KC_SCLN,        DUAL_FUNC_0,    
    KC_LEFT_SHIFT,  MT(MOD_LGUI, KC_Z),KC_X,           KC_C,           KC_V,           KC_B,                                           KC_N,           KC_M,           KC_COMMA,       KC_DOT,         MT(MOD_LCTL, KC_SLASH),KC_RIGHT_SHIFT, 
                                                    LT(2, KC_BSPC), MT(MOD_LALT, KC_DELETE),                                MT(MOD_LSFT, KC_ENTER),LT(3, KC_SPACE)
  ),
  [2] = LAYOUT_voyager(
    KC_ESCAPE,      KC_F1,          KC_F2,          KC_F3,          KC_F4,          KC_F5,                                          KC_F6,          KC_F7,          KC_F8,          KC_F9,          KC_F10,         KC_F11,         
    KC_GRAVE,       KC_EXLM,        KC_AT,          KC_HASH,        KC_DLR,         KC_PERC,                                        KC_7,           KC_8,           KC_9,           KC_MINUS,       KC_SLASH,       KC_F12,         
    KC_TRANSPARENT, KC_CIRC,        KC_AMPR,        KC_ASTR,        KC_LPRN,        KC_RPRN,                                        KC_4,           KC_5,           KC_6,           KC_PLUS,        KC_ASTR,        KC_BSPC,        
    KC_TRANSPARENT, DUAL_FUNC_0,    DUAL_FUNC_1,    KC_LEFT,        KC_RIGHT,       KC_RCBR,                                        KC_TRANSPARENT, KC_UP,          KC_DOWN,        KC_LBRC,        KC_RBRC,        KC_TRANSPARENT, 
                                                    KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [3] = LAYOUT_voyager(
    KC_TRANSPARENT, KC_F1,          KC_F2,          KC_F3,          KC_F4,          KC_F5,                                          KC_F6,          KC_F7,          KC_F8,          RGB_VAD,        RGB_VAI,        QK_BOOT,        
    KC_TRANSPARENT, KC_TRANSPARENT, KC_AUDIO_VOL_DOWN,KC_AUDIO_VOL_UP,KC_AUDIO_MUTE,  KC_TRANSPARENT,                                 KC_PAGE_UP,     KC_HOME,        KC_UP,          KC_END,         KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_MEDIA_PREV_TRACK,KC_MEDIA_NEXT_TRACK,KC_MEDIA_STOP,  KC_MEDIA_PLAY_PAUSE,RGB_SLD,                                        KC_PGDN,        KC_LEFT,        KC_DOWN,        KC_RIGHT,       KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, DUAL_FUNC_1,    HSV_0_255_255,  HSV_74_255_255, HSV_169_255_255,                                KC_TRANSPARENT, LCTL(LSFT(KC_TAB)),LCTL(KC_TAB),   KC_GRAVE,       KC_TRANSPARENT, KC_TRANSPARENT, 
                                                    KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT
  ),
};


const uint16_t PROGMEM combo0[] = { MT(MOD_LGUI, KC_DELETE), MT(MOD_LSFT, KC_ENTER), COMBO_END};
const uint16_t PROGMEM combo1[] = { MT(MOD_LALT, KC_DELETE), MT(MOD_LSFT, KC_ENTER), COMBO_END};

combo_t key_combos[COMBO_COUNT] = {
    COMBO(combo0, TO(1)),
    COMBO(combo1, TO(0)),
};



extern rgb_config_t rgb_matrix_config;

RGB hsv_to_rgb_with_value(HSV hsv) {
  RGB rgb = hsv_to_rgb( hsv );
  float f = (float)rgb_matrix_config.hsv.v / UINT8_MAX;
  return (RGB){ f * rgb.r, f * rgb.g, f * rgb.b };
}

void keyboard_post_init_user(void) {
  rgb_matrix_enable();
}

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

const uint8_t PROGMEM ledmap[][RGB_MATRIX_LED_COUNT][3] = {
    [0] = { {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173}, {139,179,173} },

    [1] = { {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217}, {44,189,217} },

    [2] = { {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192}, {240,188,192} },

    [3] = { {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112}, {84,214,112} },

};

void set_layer_color(int layer) {
  for (int i = 0; i < RGB_MATRIX_LED_COUNT; i++) {
    HSV hsv = {
      .h = pgm_read_byte(&ledmap[layer][i][0]),
      .s = pgm_read_byte(&ledmap[layer][i][1]),
      .v = pgm_read_byte(&ledmap[layer][i][2]),
    };
    if (!hsv.h && !hsv.s && !hsv.v) {
        rgb_matrix_set_color( i, 0, 0, 0 );
    } else {
        RGB rgb = hsv_to_rgb_with_value(hsv);
        rgb_matrix_set_color(i, rgb.r, rgb.g, rgb.b);
    }
  }
}

bool rgb_matrix_indicators_user(void) {
  if (rawhid_state.rgb_control) {
      return false;
  }
  if (!keyboard_config.disable_layer_led) { 
    switch (biton32(layer_state)) {
      case 0:
        set_layer_color(0);
        break;
      case 1:
        set_layer_color(1);
        break;
      case 2:
        set_layer_color(2);
        break;
      case 3:
        set_layer_color(3);
        break;
     default:
        if (rgb_matrix_get_flags() == LED_FLAG_NONE) {
          rgb_matrix_set_color_all(0, 0, 0);
        }
    }
  } else {
    if (rgb_matrix_get_flags() == LED_FLAG_NONE) {
      rgb_matrix_set_color_all(0, 0, 0);
    }
  }

  return true;
}




bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case QK_MODS ... QK_MODS_MAX:
    // Mouse and consumer keys (volume, media) with modifiers work inconsistently across operating systems,
    // this makes sure that modifiers are always applied to the key that was pressed.
    if (IS_CONSUMER_KEYCODE(QK_MODS_GET_BASIC_KEYCODE(keycode))) {
      if (record->event.pressed) {
        add_mods(QK_MODS_GET_MODS(keycode));
        send_keyboard_report();
        wait_ms(2);
        register_code(QK_MODS_GET_BASIC_KEYCODE(keycode));
        return false;
      } else {
        wait_ms(2);
        del_mods(QK_MODS_GET_MODS(keycode));
      }
    }
    break;

    case DUAL_FUNC_0:
      if (record->tap.count > 0) {
        if (record->event.pressed) {
          register_code16(KC_QUOTE);
        } else {
          unregister_code16(KC_QUOTE);
        }
      } else {
        if (record->event.pressed) {
          register_code16(KC_DQUO);
        } else {
          unregister_code16(KC_DQUO);
        }  
      }  
      return false;
    case DUAL_FUNC_1:
      if (record->tap.count > 0) {
        if (record->event.pressed) {
          register_code16(KC_GRAVE);
        } else {
          unregister_code16(KC_GRAVE);
        }
      } else {
        if (record->event.pressed) {
          register_code16(KC_TILD);
        } else {
          unregister_code16(KC_TILD);
        }  
      }  
      return false;
    case RGB_SLD:
      if (record->event.pressed) {
        rgblight_mode(1);
      }
      return false;
    case HSV_0_255_255:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(0,255,255);
      }
      return false;
    case HSV_74_255_255:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(74,255,255);
      }
      return false;
    case HSV_169_255_255:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(169,255,255);
      }
      return false;
  }
  return true;
}
