ENTRY(kmain)
OUTPUT_FORMAT(binary)
SECTIONS
{
    . = 0x7e00;
    .text :
    {
        *(.text)
    }

    . = 0x8e00;
    .rodata :
    {
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(COMMON)
        *(.bss)
    }

    .asm :
    {
        *(.asm)
    }
}
