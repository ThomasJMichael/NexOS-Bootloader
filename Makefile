# Makefile for assembling NexOS Bootloader

# First-stage bootloader source file
FIRST_STAGE_SRC=bootloader.asm

# Second-stage bootloader source file
SECOND_STAGE_SRC=second_stage.asm

# Output directory for binary files
BUILD_DIR = build

# Output filenames
FIRST_STAGE_BIN = $(BUILD_DIR)/bootloader.bin
SECOND_STAGE_BIN = $(BUILD_DIR)/second_stage.bin
COMBINED_BIN = $(BUILD_DIR)/nexos_bootloader.bin
FAT12_IMG = $(BUILD_DIR)/bootloader.img

$(shell mkdir -p $(BUILD_DIR))

all: $(FAT12_IMG)

$(FIRST_STAGE_BIN): $(FIRST_STAGE_SRC)
	nasm -f bin -o $(FIRST_STAGE_BIN) $(FIRST_STAGE_SRC)

$(SECOND_STAGE_BIN): $(SECOND_STAGE_SRC)
	nasm -f bin -o $(SECOND_STAGE_BIN) $(SECOND_STAGE_SRC)

$(COMBINED_BIN): $(FIRST_STAGE_BIN) $(SECOND_STAGE_BIN)
	cat $(FIRST_STAGE_BIN) $(SECOND_STAGE_BIN) > $(COMBINED_BIN)

$(FAT12_IMG): $(COMBINED_BIN)
	# FAT12 Filesystem
	mkfs.fat -F 12 -C $(FAT12_IMG) 2880 # 1.44 MB floppy disk format
	dd if=$(COMBINED_BIN) of=$(FAT12_IMG) bs=512 count=1 conv=notrunc

.PHONY: clean

clean:
	rm -rf $(BUILD_DIR)/

