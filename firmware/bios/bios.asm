BITS 16
org 0

global bios_entry

bios_entry:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    call bios_post
    call bios_boot
.halt:
    cli
    hlt
    jmp .halt

bios_post:
    ret

bios_boot:
    ret
