all: qemu_launch

qemu_launch: os.bin
	qemu-system-i386 -drive format=raw,file=os.bin

os.bin: boot.bin kernel.bin
	cat $^ > $@

boot.bin: boot.asm
	nasm $< -f bin -o $@

kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -s -o $@ -Ttext 0x1000 $^ --oformat binary -nostdlib -static

kernel-entry.o: kernel-entry.elf
	nasm $< -f elf32 -o $@

kernel.o: kernel.c
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@

clean:
	rm -f *.bin *.o


