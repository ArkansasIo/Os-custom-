# OS Custom — 64-bit Server OS

Custom x86-64 operating-system project integrating a BIOS/CMOS layer, boot chain, CP/M 2.2-style interface, hardware-target abstraction, 1024-bit arithmetic, NUMA and GPU architecture.

## Architecture

BIOS/CMOS → Stage 1 → Stage 2 → x86-64 long mode → native kernel → hardware abstraction → CP/M/DOS/Linux compatibility.

The initial implementation is a development/educational bootstrap. It must be validated in QEMU before physical hardware deployment.

See `docs/bootable-integration.md` and `docs/hardware-targets.md`.
