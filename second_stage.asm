; second_stage.asm

; Define memory location where we want to load this bootloader
; ORG 0x7E00

; Entry point
; BITS 16
start:
    ; Clear the screen (use INT 10h/AH=06h)
    mov ah, 06h      ; Function 06h - Scroll Up
    mov al, 0        ; Clear entire screen
    mov bh, 07h      ; Display attribute (white on black)
    mov cx, 0        ; Upper-left corner row and column
    mov dx, 184FH    ; Lower-right corner row and column
    int 10h          ; Call BIOS video services

    ; Set cursor position (use INT 10h/AH=02h)
    mov ah, 02h      ; Function 02h - Set Cursor Position
    mov bh, 0        ; Page number
    mov dh, 0        ; Row (0-based)
    mov dl, 0        ; Column (0-based)
    int 10h          ; Call BIOS video services

    ; Print a message
    mov ah, 0x0E     ; Function 0Eh - Teletype Output
    mov al, 'S'      ; Character to print
    int 10h          ; Call BIOS video services
    mov al, 'e'      ; Character to print
    int 10h
    mov al, 'c'      ; Character to print
    int 10h
    mov al, 'o'      ; Character to print
    int 10h
    mov al, 'n'      ; Character to print
    int 10h
    mov al, 'd'      ; Character to print
    int 10h

    mov al, ' '      ; Character to print
    int 10h
    
    mov al, 'S'      ; Character to print
    int 10h
    mov al, 't'      ; Character to print
    int 10h
    mov al, 'a'      ; Character to print
    int 10h
    mov al, 'g'      ; Character to print
    int 10h
    mov al, 'e'      ; Character to print
    int 10h

    ; Infinite loop
loop:
    jmp loop

; Fill the rest of the sector with zeros
times 510-($-$$) db 0
dw 0xAA55  ; Boot signature

