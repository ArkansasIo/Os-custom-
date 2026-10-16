BITS 16
org 0x8000

STAGE2_SECTORS equ 16
KERNEL_SECTORS equ 64
KERNEL_LBA equ 17
KERNEL_LOAD_SEG equ 0x1000
KERNEL_LOAD_OFFSET equ 0x0000

stage2_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    ; The BIOS passes the boot device in DL. Preserve it before any disk call.
    mov [boot_drive], dl
    sti

    call load_kernel
    jc disk_error
    call enable_a20
    lgdt [gdt_descriptor]
    cli
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:protected_mode

load_kernel:
    mov si, dap
    mov dl, [boot_drive]
    mov ah, 0x42
    int 0x13
    ret

enable_a20:
    in al, 0x92
    or al, 2
    and al, 0xFE
    out 0x92, al
    ret

BITS 32
protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    ; Clear the 4-level page-table area below 0x5000.
    xor eax, eax
    mov edi, 0x1000
    mov ecx, 4096
    rep stosd

    ; PML4[0] -> PDPT 0x2000 -> PD 0x3000.
    mov dword [0x1000], 0x2003
    mov dword [0x1004], 0x00000000
    mov dword [0x2000], 0x3003
    mov dword [0x2004], 0x00000000

    ; Map the first 2 MiB with one 2 MiB page (present, writable, PS).
    mov dword [0x3000], 0x00000083
    mov dword [0x3004], 0x00000000

    mov eax, 0x1000
    mov cr3, eax
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax
    jmp 0x18:long_mode

BITS 64
long_mode:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov rsp, 0x90000
    mov rax, 0x100000
    jmp rax

BITS 16
disk_error:
    mov si, disk_error_msg
.print:
    lodsb
    test al, al
    jz .halt
    mov ah, 0x0E
    int 0x10
    jmp .print
.halt:
    cli
    hlt
    jmp .halt

boot_drive db 0
disk_error_msg db "Stage2: disk read error", 0
align 4
dap:
    db 0x10, 0
    dw KERNEL_SECTORS
    dw KERNEL_LOAD_OFFSET
    dw KERNEL_LOAD_SEG
    dq KERNEL_LBA

gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
    dq 0x00AF9A000000FFFF
    dq 0x00AF92000000FFFF
gdt_descriptor:
    dw gdt_descriptor - gdt_start - 1
    dd gdt_start
