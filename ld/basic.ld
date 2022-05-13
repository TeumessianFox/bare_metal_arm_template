ENTRY(_start)
SECTIONS
{
    . = 0xFFFF0000;
    .init : {
        *(.init)
    }
}
