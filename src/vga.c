#include "../includes/vga.h"

static const uint8_t MAX_WIDTH = 80;
static const uint8_t MAX_HEIGHT = 25;

static uint16_t* video = (uint16_t*)0xB8000;
static volatile uint16_t current_x = 0;
static volatile uint16_t current_y = 0;

enum VgaColor {
  VGA_COLOR_BLACK = 0,
  VGA_COLOR_GREEN = 2,
  VGA_COLOR_RED = 4,
  VGA_COLOR_GRAY = 7,
};

#pragma pack()
typedef struct VgaPixel {
  enum VgaColor color;
  char character;
} VgaPixel;

VgaPixel VgaPixel_new(char a_char, enum VgaColor color) {
  VgaPixel pixel = {color, a_char};

  return pixel;
}

uint16_t vga_pixel_to_hex(VgaPixel pixel) {
  return ((uint16_t)pixel.color << 8) | (uint16_t)pixel.character;
}

void inc_x() {
  if (current_x == (MAX_WIDTH - 1) && current_y == (MAX_HEIGHT - 1)) {
    // scroll
  } else if (current_x == (MAX_WIDTH - 1)) {
    current_x = 0;
    current_y++;
  } else {
    current_x++;
  }
}

void put_char(VgaPixel pixel, uint16_t x, uint16_t y) {
  video[y * MAX_WIDTH + x] = vga_pixel_to_hex(pixel);
}

void clean_screen() {
  for (uint16_t y = 0; y < MAX_HEIGHT; y++) {
    for (uint16_t x = 0; x < MAX_WIDTH; x++) {
      VgaPixel pixel = VgaPixel_new(' ', VGA_COLOR_BLACK);
      put_char(pixel, x, y);
    }
  }
}

inline void vga_printstr(char* chars) {
  uint32_t i = 0;
  clean_screen();

  while (chars[i]) {
    VgaPixel pixel = VgaPixel_new(chars[i], VGA_COLOR_RED);
    put_char(pixel, current_x, current_y);
    inc_x();
    i++;
  }
}
