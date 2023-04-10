#include "../includes/vga.h"

enum VgaColor {
  VGA_COLOER_BLACK = 0,
  VGA_COLOR_GREEN = 2,
  VGA_COLOR_RED = 4,
  VGA_COLOR_GRAY = 7,
};

inline void vga_printstr(char* chars) {
  uint8_t* video = (uint8_t*)0xB8000;

  uint32_t i = 0;

  while (chars[i]) {
    *video = chars[i];
    video++;
    *video = VGA_COLOR_GREEN;
    video++;
    i++;
  }
}
