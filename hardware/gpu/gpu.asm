BITS 64
global gpu_detect
global gpu_vendor

GPU_NONE equ 0
GPU_NVIDIA equ 1
GPU_AMD equ 2
GPU_INTEL equ 3

section .bss
gpu_vendor resq 1

section .text
gpu_detect:
    mov qword [rel gpu_vendor], GPU_NONE
    ret
