[org 0x7C00]  ; Bootloader origin
[bits 16]     ; 16-bit real mode

;
; FAT12 header
; 
jmp short start
nop

bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0F0h                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; serial number, value doesn't matter
ebr_volume_label:           db '   NexOS   '        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes

; Print a message
start:
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
