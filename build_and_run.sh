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
BOOTLOADER_BIN=nexos_bootloader.bin

# Check if the bootloader binary exists
if [ ! -f $BOOTLOADER_BIN ]; then
    echo "Error: $BOOTLOADER_BIN not found."
    exit 1
fi

echo "Creating bootable image..."

# Create a bootable image with 'dd'
dd if=/dev/zero of=bootloader.img bs=512 count=2880  # Create a 1.44 MB floppy image
dd if=$BOOTLOADER_BIN of=bootloader.img conv=notrunc

# Check if dd was successful
if [ $? -ne 0 ]; then
    echo "Failed to create bootable image, aborting."
    exit 1
fi

echo "Booting with QEMU..."

# Run the image in QEMU
qemu-system-x86_64 -fda bootloader.img

echo "Boot process completed."

