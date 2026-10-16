#!/usr/bin/env python3
"""Sanity checks for the raw BIOS disk image produced by make."""
from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit("usage: check_image.py IMAGE")

image = Path(sys.argv[1]).read_bytes()
if len(image) % 512:
    raise SystemExit("image size is not sector-aligned")
if len(image) < 18 * 512:
    raise SystemExit("image is too small for boot sector + stage2 + kernel")
if image[510:512] != b"\x55\xaa":
    raise SystemExit("missing x86 boot signature at byte 510")
if not any(image[512:17 * 512]):
    raise SystemExit("stage2 region is empty")
if not any(image[17 * 512:]):
    raise SystemExit("kernel region is empty")
print(f"image OK: {len(image)} bytes ({len(image)//512} sectors)")
