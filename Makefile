SOURCES=$(wildcard src/**/*.c src/*.c)
OBJECTS=$(patsubst src/%.c,build/%.o,$(SOURCES))
HEADERS=$(wildcard includes/**/*.h includes/*.h)
CC=i686-elf-gcc
LD=i686-elf-ld

#TODO what's Iinc
CFLAGS = -g -ffreestanding -fomit-frame-pointer -finline-functions \
	-nostdlib \
    -Wall -Werror -Wextra -pedantic -Wfloat-equal \
    -lgcc \
    -O0
    # -std=c11 \

TARGET=bin/kernel.bin

.PHONY: all clean build

all: build run

run:
	qemu-system-x86_64 -no-reboot -drive format=raw,file=bin/kernel.img

build: clean bootloader bin/boot.bin bin/kernel.bin
    # Compile files
	# DEPRECATED: nasm -f elf -g ./bootloader/kernel_entry.asm -o ./.build/kernel_entry.asm.o
	#
	# i686-elf-gcc $(CFLAGS) -c ./src/main.c -o ./.build/kernel.o
	# i686-elf-gcc $(CFLAGS) -c ./src/vga.c -o ./.build/vga.o

    # Link Object files
	# i686-elf-ld -g -relocatable -m elf_i386 $(OBJ_FILES) -o ./.build/kernelfull.o
	dd if=./bin/boot.bin >> ./bin/kernel.img
	dd if=./bin/kernel.bin >> ./bin/kernel.img
	dd if=/dev/zero bs=512 count=4000 >> ./bin/kernel.img
	ls -sh ./bin/kernel.bin
	ls -sh ./bin/kernel.img

# Link Object files
bin/kernel.bin: $(OBJECTS)
	# $(LD) -g -relocatable -o ./build/kernel.o $(OBJECTS)
	# $(CC) $(CFLAGS) -T linker.ld -o ./bin/kernel.bin ./build/kernel.o
	$(CC) $(CFLAGS) -T linker.ld -o ./bin/kernel.bin $(OBJECTS)

# Compile C files to object files
build/%.o: src/%.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

bin/boot.bin: ./bootloader/main.asm
	nasm -g bootloader/main.asm -f bin -o bin/boot.bin

clean:
	rm -rf build/*
	rm -rf bin/*

gdb: build
	gdb -x .gdbfile

# TESTS
TEST_DIR=tests
TEST_SRC=$(wildcard $(TEST_DIR)/*_tests.c)
TESTBINS=$(patsubst $(TEST_DIR)/%.c,$(TEST_DIR)/bin/%,$(TEST_SRC))
