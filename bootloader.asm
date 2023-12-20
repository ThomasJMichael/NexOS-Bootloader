[org 0x7C00]  ; Bootloader origin
[bits 16]     ; 16-bit real mode

; Print a message
mov ah, 0x0E
mov si, loading_msg

print_char:
    lodsb	; Load byte at SI into AL, and increment SI
    cmp al, 0	; Check if byte is 0, end of string
    je done	; If end of string jmp to done
    mov ah, 0x0E ; Reset AH to teletype function
    int 0x10	; BIOS interupt to print character in AL
    jmp print_char

done:

; Set up disk parameters to load the second stage
mov ah, 0x02   ; BIOS read disk function
mov al, 8      ; Number of sectors to read
mov ch, 0      ; Cylinder number
mov cl, 2      ; Starting sector (2, as the first sector is the boot sector)
mov dh, 0      ; Head number
mov dl, 0      ; Drive number (0 = first floppy disk)
mov bx, 0x1000 ; Segment where we load the second stage
mov es, bx
mov bx, 0x0000 ; Offset
int 0x13       ; Call BIOS

; Check for disk read errors
jc read_error

; Jump to second stage
jmp 0x1000:0x0000

read_error:
; Handle disk read error
hlt

loading_msg db 'Loading...', 0

; Boot signature
times 510 - ($ - $$) db 0
dw 0xAA55
