ASM=nasm
CC=gcc
CC16=/usr/bin/watcom/bin1/wcc
LD16=/usr/bin/watcom/bin1/wlink

SRC_DIR=src
BUILD_DIR=build

BOOTLOADER = bootloader
FIRST_STAGE_NAME = first_stage
FIRST_STAGE_DIR = $(SRC_DIR)/$(FIRST_STAGE_NAME)
FIRST_STAGE_BIN = $(BUILD_DIR)/$(FIRST_STAGE_NAME).bin

STAGE_TWO_NAME = second_stage
STAGE_TWO_DIR = $(SRC_DIR)/$(STAGE_TWO_NAME)
STAGE_TWO_BIN = $(BUILD_DIR)/$(STAGE_TWO_NAME).bin

$(shell mkdir -p $(BUILD_DIR))

all: $(BOOTLOADER)

$(BOOTLOADER): $(FIRST_STAGE_BIN) $(STAGE_TWO_BIN)

$(FIRST_STAGE_BIN):
	$(MAKE) -C $(FIRST_STAGE_DIR) BUILD_DIR=$(abspath $(BUILD_DIR))

$(STAGE_TWO_BIN):
	$(MAKE) -C $(STAGE_TWO_DIR) BUILD_DIR=$(abspath $(BUILD_DIR))

clean:
	$(MAKE) -C $(FIRST_STAGE_DIR) BUILD_DIR=$(abspath $(BUILD_DIR)) clean
	$(MAKE) -C $(STAGE_TWO_DIR) BUILD_DIR=$(abspath $(BUILD_DIR)) clean
	rm -rf $(BUILD_DIR)/*
