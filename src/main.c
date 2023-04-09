#include "../includes/main.h"
#include "../includes/vga.h"

void kmain() { init(); }

void init() {
  vga_printstr("BAAA");

  while (1)
    ;
}
