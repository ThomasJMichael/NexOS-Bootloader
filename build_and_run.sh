#!/bin/bash

# NexOS Bootloader Build and Run Script

echo "Building NexOS Bootloader..."

# Run make to build the bootloader
make

# Check if make was successful
if [ $? -ne 0 ]; then
    echo "Build failed, aborting."
    exit 1
fi

# Define the bootloader binary name
BOOTLOADER_BIN=build/nexos_bootloader.bin

# Check if the bootloader binary exists
if [ ! -f $BOOTLOADER_BIN ]; then
    echo "Error: $BOOTLOADER_BIN not found."
    exit 1
fi

echo "Booting with QEMU..."

# Run the image in QEMU
qemu-system-x86_64 -fda build/bootloader.img -serial stdio

echo "Boot process completed."

