; Explicit weak-style stubs keep early kernel linkable until subsystems land.
; Replace each routine with a real implementation before enabling the subsystem.
BITS 64

global platform_detect
global cpu_detect
global acpi_init
global pci_init
global numa_init
global scheduler_init
global gpu_init

section .text
platform_detect:
cpu_detect:
acpi_init:
pci_init:
numa_init:
scheduler_init:
gpu_init:
    ret
