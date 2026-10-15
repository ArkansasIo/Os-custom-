BITS 64
global cmos_read
global cmos_write

; Logical CMOS interface. Physical RTC/NVRAM mapping is platform-specific.
cmos_read:
    xor eax, eax
    ret

cmos_write:
    ret
