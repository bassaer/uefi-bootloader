IMG       = os.img
MAKE      = make --no-print-directory

.PHONY: img run clean

all: clean run

kernel/kernel.bin:
	@$(MAKE) build -C kernel

boot/BOOTX64.EFI:
	@$(MAKE) build -C boot

img: boot/BOOTX64.EFI kernel/kernel.bin
	dd if=/dev/zero of=$(IMG) bs=1k count=1440
	mformat -i $(IMG) -f 1440 ::
	mmd -i $(IMG) ::/EFI
	mmd -i $(IMG) ::/EFI/BOOT
	mcopy -i $(IMG) $< ::/EFI/BOOT
	mcopy -i $(IMG) kernel/kernel.bin ::/

run: img
	qemu-system-x86_64 -name uefi-bootloader \
                     -monitor stdio \
                     -bios /usr/share/ovmf/OVMF.fd \
                     -drive format=raw,file=$(IMG) \
                     -device nec-usb-xhci,id=xhci \
                     -device usb-mouse \
                     -device usb-kbd \
                     -d guest_errors \
                     || true

clean:
	@$(MAKE) clean -C boot
	@$(MAKE) clean -C kernel
