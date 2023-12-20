#!/bin/bash

# NexOS Bootloader Build and Run Script

echo "Building NexOS Bootloader..."

# Run make to assemble the bootloader
make

# Check if make was successful
if [ $? -ne 0 ]; then
    echo "Build failed, aborting."
    exit 1
fi

echo "Creating bootable image..."

# Create a bootable image from the compiled binary
dd if=bootloader.bin of=bootloader.img bs=512 count=1 conv=notrunc

# Check if dd was successful
if [ $? -ne 0 ]; then
    echo "Failed to create bootable image, aborting."
    exit 1
fi

echo "Booting with QEMU..."

# Run the image in QEMU
qemu-system-x86_64 bootloader.img

echo "Boot process completed."

