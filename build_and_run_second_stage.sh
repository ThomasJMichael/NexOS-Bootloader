#!/bin/bash

# NexOS Second-Stage Bootloader Build and Run Script

echo "Building NexOS Second-Stage Bootloader..."

# Run make to build the second-stage bootloader
make second_stage.bin

# Check if make was successful
if [ $? -ne 0 ]; then
    echo "Build failed, aborting."
    exit 1
fi

echo "Running the Second-Stage Bootloader..."

# Run the second-stage bootloader in QEMU
qemu-system-x86_64 -fda second_stage.bin -serial stdio

echo "Second-stage bootloader execution completed."

