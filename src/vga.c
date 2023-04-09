#include "../includes/vga.h"

void vga_printstr(char *chars) {
  char *video = (char *)0xB8000;

  uint32_t i = 0;

  while (chars[i]) {
    *video = chars[i];
    video++;
    *video = RED;
    video++;
    i++;
  }
}
