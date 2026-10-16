NASM ?= nasm
LD ?= ld
BUILD := build

.PHONY: all clean check tools

all: $(BUILD)/stage1.bin $(BUILD)/stage2.bin $(BUILD)/kernel.elf $(BUILD)/kernel.bin

tools:
	@command -v $(NASM) >/dev/null || (echo "nasm is required" >&2; exit 1)
	@command -v $(LD) >/dev/null || (echo "binutils ld is required" >&2; exit 1)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/stage1.bin: boot/stage1.asm | $(BUILD)
	$(NASM) -f bin -Wall -Werror -o $@ $@
	$(NASM) -f bin -Wall -Werror -o $@ $<

$(BUILD)/stage2.bin: boot/stage2.asm | $(BUILD)
	$(NASM) -f bin -Wall -Werror -o $@ $<

$(BUILD)/entry.o: kernel/entry.asm | $(BUILD)
	$(NASM) -f elf64 -Wall -Werror -o $@ $<

$(BUILD)/kernel.o: kernel/kernel.asm | $(BUILD)
	$(NASM) -f elf64 -Wall -Werror -o $@ $<

$(BUILD)/stubs.o: kernel/stubs.asm | $(BUILD)
	$(NASM) -f elf64 -Wall -Werror -o $@ $<

$(BUILD)/kernel.elf: $(BUILD)/entry.o $(BUILD)/kernel.o $(BUILD)/stubs.o kernel/linker.ld
	$(LD) -nostdlib -z max-page-size=0x1000 -T kernel/linker.ld -o $@ $(BUILD)/entry.o $(BUILD)/kernel.o $(BUILD)/stubs.o

$(BUILD)/kernel.bin: $(BUILD)/kernel.elf
	objcopy -O binary $< $@
	@test "$$(wc -c < $@)" -le $$((64 * 512)) || (echo "kernel exceeds stage-2 64-sector limit" >&2; exit 1)

$(BUILD)/os-custom.img: $(BUILD)/stage1.bin $(BUILD)/stage2.bin $(BUILD)/kernel.bin
	@test "$$(wc -c < $(BUILD)/stage1.bin)" -eq 512
	@test "$$(wc -c < $(BUILD)/stage2.bin)" -le $$((16 * 512)) || (echo "stage2 exceeds stage-1 16-sector load" >&2; exit 1)
	@test "$$(wc -c < $(BUILD)/kernel.bin)" -le $$((64 * 512))
	dd if=/dev/zero of=$@ bs=512 count=4096 status=none
	dd if=$(BUILD)/stage1.bin of=$@ conv=notrunc status=none
	dd if=$(BUILD)/stage2.bin of=$@ bs=512 seek=1 conv=notrunc status=none
	dd if=$(BUILD)/kernel.bin of=$@ bs=512 seek=17 conv=notrunc status=none

check: tools all $(BUILD)/os-custom.img
	@python3 scripts/check_image.py $(BUILD)/os-custom.img
	@echo "Build checks passed."

clean:
	rm -rf $(BUILD)
