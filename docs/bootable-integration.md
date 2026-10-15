# Bootable Integration

The project uses an explicit development boot path:

1. BIOS-compatible boot sector executes at `0x7C00`.
2. Stage 1 loads stage 2 through BIOS INT 13h extensions.
3. Stage 2 enables A20 and installs a bootstrap GDT.
4. Stage 2 creates initial identity-mapped page tables.
5. Stage 2 enables PAE, EFER.LME, and paging.
6. Stage 2 enters x86-64 long mode.
7. Stage 2 transfers control to the kernel load address.
8. The kernel initializes platform, CPU, ACPI, PCI, NUMA, scheduler, and GPU layers.

This is a development bootstrap, not production firmware. The next hardening steps are dynamic kernel-size metadata, checksums/signatures, FAT12/16/32 loading, UEFI, ACPI parsing, SMP startup, robust exceptions, a physical-memory allocator, PCIe ECAM, and device drivers.
