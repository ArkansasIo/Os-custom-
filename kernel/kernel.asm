BITS 64
global kernel_main
extern scheduler_init
extern numa_init
extern gpu_init
extern platform_detect
extern cpu_detect
extern pci_init
extern acpi_init

section .text
kernel_main:
    call platform_detect
    call cpu_detect
    call acpi_init
    call pci_init
    call numa_init
    call scheduler_init
    call gpu_init
    mov rdi, 0xB8000
    mov rsi, boot_msg
.print:
    lodsb
    test al, al
    jz .done
    mov [rdi], al
    mov byte [rdi+1], 0x07
    add rdi, 2
    jmp .print
.done:
    ret

section .rodata
boot_msg db "64-bit Server OS: BIOS -> HW -> Kernel READY", 0
