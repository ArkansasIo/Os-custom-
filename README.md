# OS Custom — 64-bit Server OS

Custom x86-64 educational operating-system project exploring a legacy BIOS boot chain, long-mode entry, a native kernel skeleton, firmware interfaces, hardware discovery and compatibility layers.

## Current status

This repository is a **development prototype**, not a production-ready operating system. It does not yet provide user-mode process isolation, a filesystem, a security model, robust exception handling, real device drivers, or a complete POSIX/CP/M environment.

## Architecture

BIOS boot sector → stage 2 → initial page tables → x86-64 long mode → kernel entry point → subsystem initialization stubs.

Planned areas include BIOS/CMOS access, CPU and PCI discovery, storage/network drivers, NUMA, GPU integration and command-shell compatibility.

## Build

Install the tools on Ubuntu/Debian:

```sh
sudo apt-get update
sudo apt-get install -y nasm binutils make python3 qemu-system-x86
```

Build and check:

```sh
make clean
make check
```

The raw image is written to `build/os-custom.img`. A GitHub Actions workflow assembles the source and uploads build outputs as an artifact.

To try the image in an emulator:

```sh
qemu-system-x86_64 -drive format=raw,file=build/os-custom.img -m 256M
```

Use QEMU first. Do not flash this development image to physical hardware.

## Documentation

- [Build and test guide](docs/build-and-test.md)
- [Bootable integration and limitations](docs/bootable-integration.md)
- [Implementation roadmap](docs/implementation-roadmap.md)

The CI checks assembly, link and basic disk-image layout. Successful CI does **not** prove that the OS fully boots or that the hardware subsystems work on real hardware.
