MEMORY 
{
    READ_WRITE (RW) : ORIGIN = 0x0, LENGTH = 0x1000
    READ_EXEC (RXI) : ORIGIN = 0x1000, LENGTH = 0x1000
    EXEC_ONLY (R) : ORIGIN = 0x2000, LENGTH = 0x1000
}


/* SECTIONS
{
    .part1 : { *(a) *(b) } > READ_WRITE
    .part2 : { *(c) *(d) } > READ_EXEC
    .part3 : { *(e) *(f) } > EXEC_ONLY
} */

SECTIONS
{
    .meh : { *(.text2) } > READ_EXEC
}