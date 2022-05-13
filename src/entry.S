.section .init

.global _start
_start:
    mov r0,#0x0
    mov r1,#0x0
    mov r2,#0x0
    mov r3,#0x0
    mov r4,#0x0
    mov r5,#0x0
    mov r6,#0x0
    mov r7,#0x0
    mov r8,#0x0
    mov r9,#0x0
    mov r10,#0x0
    mov r11,#0x0
    mov r12,#0x0
    mov sp,#0x3F000
    mov lr,#0x0
    bl main

/* Go into an endless loop after main() has finished */
.endless:
    b .endless
