FEATURES ?= default

OBJ_FILES = ./.build/kernel.o ./.build/vga.o

# ./.build/kernel_entry.asm.o

CFLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce \
	-fomit-frame-pointer -finline-functions -fno-builtin \
	-nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: build run

run:
	qemu-system-x86_64 -no-reboot -drive format=raw,file=bin/kernel.img

build: clean
	nasm -g bootloader/main.asm -f bin -o bin/boot.bin

    # Compile files
	# nasm -f elf -g ./bootloader/kernel_entry.asm -o ./.build/kernel_entry.asm.o
	i686-elf-gcc $(CFLAGS) -c ./src/main.c -o ./.build/kernel.o
	i686-elf-gcc $(CFLAGS) -c ./src/vga.c -o ./.build/vga.o

    # Link Object files
	i686-elf-ld -g -relocatable -m elf_i386 $(OBJ_FILES) -o ./.build/kernelfull.o

	i686-elf-gcc $(CFLAGS) -T linker.ld -o ./bin/kernel.bin ./.build/kernelfull.o 

	# i686-elf-ld -g -T linker.ld -o ./bin/kernel.bin ./.build/kernel.o
	# i686-elf-gcc $(CFLAGS) -o ./.build/vga.o -c ./src/vga.c
	# i686-elf-ld -g -m elf_i386 -o ./.build/fullkernel.o ./.build/kernel.o ./.build/vga.o

	dd if=./bin/boot.bin >> ./bin/kernel.img
	dd if=./bin/kernel.bin >> ./bin/kernel.img
	dd if=/dev/zero bs=512 count=4000 >> ./bin/kernel.img

clean:
	rm -rf .build/*
	rm -rf bin/*

gdb: build
	gdb -x .gdbfile
