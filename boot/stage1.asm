BITS 16
org 0x7C00

STAGE2_SECTORS equ 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    mov [boot_drive], dl

    ; BIOS INT 13h extensions load stage 2 from LBA 1 to physical 0x8000.
    mov byte [dap + 2], STAGE2_SECTORS
    mov si, dap
    mov dl, [boot_drive]
    mov ah, 0x42
    int 0x13
    jc disk_error

    ; Pass the BIOS drive in DL; stage 2 also restores it from this handoff byte.
    mov dl, [boot_drive]
    jmp 0x0000:0x8000

disk_error:
    mov si, msg
.loop:
    lodsb
    test al, al
    jz .halt
    mov ah, 0x0E
    int 0x10
    jmp .loop
.halt:
    cli
    hlt
    jmp .halt

boot_drive db 0
msg db "Boot: stage2 load failed", 0

align 4
dap:
    db 0x10, 0
    db STAGE2_SECTORS
    db 0
    dw 0x8000
    dw 0x0000
    dq 1

times 510-($-$$) db 0
dw 0xAA55
