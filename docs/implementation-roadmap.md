# Implementation Roadmap

This project is a small x86-64 learning kernel. Work should be landed in testable stages.

## Phase 1 — Reproducible boot
- [x] Build boot sector and second stage with NASM.
- [x] Link a minimal ELF64 kernel and produce a flat binary.
- [x] Check the boot signature and image layout in CI.
- [ ] Verify a full boot under QEMU and capture serial/debug output.
- [ ] Replace fixed-size kernel loading with a disk header containing length and checksum.

## Phase 2 — Kernel foundations
- [ ] GDT/TSS setup, IDT, exception handlers, serial console.
- [ ] Physical page allocator and virtual memory mapper.
- [ ] PIT/APIC timer and interrupt controller support.
- [ ] PCI configuration access and ACPI table parsing.
- [ ] Basic memory-map acquisition from a boot protocol.

## Phase 3 — Drivers and storage
- [ ] PCIe ECAM discovery, block-device interface, AHCI/NVMe drivers.
- [ ] Read-only FAT implementation for development media.
- [ ] Network device discovery and Ethernet driver.

## Phase 4 — Compatibility and services
- [ ] Define a documented syscall ABI before adding user processes.
- [ ] Implement process/task model, ring-3 transition, memory isolation.
- [ ] Implement a command shell and filesystem-backed applications.
- [ ] Treat CP/M compatibility as an API/emulation layer, not an operating-system substitute.

## Phase 5 — Platform support and hardening
- [ ] UEFI boot path and Secure Boot-aware signing strategy.
- [ ] SMP startup, scheduler synchronization and NUMA-aware allocation.
- [ ] Kernel tests, fuzzing of parsers, reproducible builds and security review.

Hardware folders describe planned interfaces until real drivers and tests are present.
