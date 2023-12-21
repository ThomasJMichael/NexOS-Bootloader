# Makefile for assembling NexOS Bootloader

# First-stage bootloader source file
FIRST_STAGE_SRC=bootloader.asm

# Second-stage bootloader source file
SECOND_STAGE_SRC=second_stage.asm

# Output filenames
FIRST_STAGE_BIN=bootloader.bin
SECOND_STAGE_BIN=second_stage.bin
COMBINED_BIN=nexos_bootloader.bin

all: $(COMBINED_BIN)

$(FIRST_STAGE_BIN): $(FIRST_STAGE_SRC)
	nasm -f bin -o $(FIRST_STAGE_BIN) $(FIRST_STAGE_SRC)

$(SECOND_STAGE_BIN): $(SECOND_STAGE_SRC)
	nasm -f bin -o $(SECOND_STAGE_BIN) $(SECOND_STAGE_SRC)
$(COMBINED_BIN): $(FIRST_STAGE_BIN) $(SECOND_STAGE_BIN)
	cat $(FIRST_STAGE_BIN) $(SECOND_STAGE_BIN) > $(COMBINED_BIN)

.PHONY: clean

clean:
	rm -f $(FIRST_STAGE_BIN) $(SECOND_STAGE_BIN)

