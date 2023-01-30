ENTRY(_Reset)

SECTIONS
{
    . = 0x0;
    .text : { startup.o(.vector_table) startup.o(.text)}
    . = ALIGN(8);
}