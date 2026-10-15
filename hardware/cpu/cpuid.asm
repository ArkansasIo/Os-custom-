BITS 64
global cpu_detect
global cpu_features_ecx
global cpu_features_edx

section .bss
cpu_features_ecx resd 1
cpu_features_edx resd 1

section .text
cpu_detect:
    push rbx
    mov eax, 1
    cpuid
    mov [rel cpu_features_ecx], ecx
    mov [rel cpu_features_edx], edx
    pop rbx
    ret
