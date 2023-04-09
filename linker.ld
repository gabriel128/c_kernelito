ENTRY(kmain)
OUTPUT_FORMAT(binary)
SECTIONS
{
    . = 0x7e00;
    .text : ALIGN(512)
    {
        *(.text)
    }

    .rodata : ALIGN(512)
    {
        *(.rodata)
    }

    .data : ALIGN(512)
    {
        *(.data)
    }

    .bss : ALIGN(512)
    {
        *(COMMON)
        *(.bss)
    }

    .asm : ALIGN(512)
    {
        *(.asm)
    }
}
