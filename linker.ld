/* linker.ld */
ENTRY(_start)
OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)

SECTIONS
{
    /* Tell the ELF header we live at 256MB mark */
    . = 0x10000000;

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
}
