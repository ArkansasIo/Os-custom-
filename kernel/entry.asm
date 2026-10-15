BITS 64
global _start
extern kernel_main

section .text
_start:
    cli
    mov rsp, stack_top
    xor rbp, rbp
    call kernel_main
.halt:
    hlt
    jmp .halt

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:
