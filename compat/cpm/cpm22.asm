BITS 64
global cpm22_init
extern cpm_bdos_dispatch
extern cpm_bios_dispatch
cpm22_init:
    call cpm_bdos_dispatch
    call cpm_bios_dispatch
    ret
