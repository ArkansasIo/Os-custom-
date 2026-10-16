# Build and Test

## Toolchain

On Ubuntu/Debian:

```sh
sudo apt-get update
sudo apt-get install -y nasm binutils make python3 qemu-system-x86
```

## Build

```sh
make clean
make check
```

This builds a raw BIOS disk image at `build/os-custom.img`. The stage-1 sector is at LBA 0, stage 2 starts at LBA 1 and is reserved 16 sectors, and the kernel begins at LBA 17. Stage 2 currently supports a maximum of 64 kernel sectors. The limits are deliberately checked by the build.

## Run in QEMU

```sh
qemu-system-x86_64 -drive format=raw,file=build/os-custom.img -m 256M
```

Use the emulator first. Do not write this development image directly to a physical disk.

## Scope and known limitations

This is an educational BIOS/legacy boot prototype. It is not a secure or production server operating system. Subsystem entry points are explicit stubs until implemented. No filesystem, process isolation, user mode, memory allocator, interrupt/exception handlers, device drivers, networking stack, or security boundary is claimed as complete.
