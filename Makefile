# Makefile for assembling NexOS Bootloader

bootloader.bin: bootloader.asm
	nasm -f bin -o bootloader.bin bootloader.asm

.PHONY: clean

clean:
	rm -f bootloader.bin

