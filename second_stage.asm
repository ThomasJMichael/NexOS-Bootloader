; second_stage.asm

jmp start

; Define memory location where we want to load this bootloader
ORG 0x7E00
BITS 16

; UART Consts
UART_COM1_BASE      dw 0x3F8  ; COM1 Port Address
UART_DARA           db 0      ; Data register offset
UART_DIV_LOW        db 0      ; Divisor latch low byte offset
UART_DIV_HIGH       db 1      ; Divisor Latch high byte offset
UART_INT_ENAB       db 1      ; Interrupt enable register offset
UART_LINE_CTRL      db 3      ; Line control register offset

; Initilize UART
init_uart:
    mov dx, UART_COM1_BASE      ; Load COM1 port address into DX

    ; Set baud rate (115200 bps), 8 data bits, 1 stop bit, no parity
    mov al, 0x00                ; Divisor latch access bit (DLAB) = 0
    out dx, al                  ; Access UART_DLL (Divisor Latch Low Byte)
    mov al, 0x01                ; Divisor latch access bit (DLAB) = 1
    out dx, al                  ; Access UART_DLM (Divisor Latch High Byte)
    mov al, 0x03                ; Line control register value (8N1)
    out dx, al                  ; set line control register

    ret

; Function to send a char over UART
send_char:
    mov dx, UART_COM1_BASE      ; Load COM1 port address into DX

uart_send_char_loop:
    ;in al, dx                   ; Read UART line status register
    ;test al, 20h                ; Check if transmitter is empty (Bit 5 set)
    ;jz uart_send_char_loop      ; Wait until transmitter is empty
    mov al, [di]                ; Load the character to send from memory
    out dx, al                  ; Send the character to UART data register
    ret

start:
    ; Clear the screen (use INT 10h/AH=06h)
    mov ah, 06h                 ; Function 06h - Scroll Up
    mov al, 0                   ; Clear entire screen
    mov bh, 07h                 ; Display attribute (white on black)
    mov cx, 0                   ; Upper-left corner row and column
    mov dx, 184FH               ; Lower-right corner row and column
    int 10h                     ; Call BIOS video services

    ; Set cursor position (use INT 10h/AH=02h)
    mov ah, 02h                 ; Function 02h - Set cursor position
    mov bh, 0                   ; Page number
    mov dh, 0                   ; Row (0 based)
    mov dl, 0                   ; Column (0 based)
    int 10h                     ; Call BIOS video services

    ; Init UART
    call init_uart

    ; Print Message over UART
    mov si, uart_message        ; Load address of the message

uart_print_loop:
    mov di, si                  ; Copy source address to destination address
    lodsb
    call send_char
    lodsb                       ; Load the next character from the message into AL
    jmp uart_print_loop

uart_print_done:

; Infinite loop
uart_loop:
    jmp uart_loop

uart_message db "BASEBALL", 0

; Fill the rest of the sector with zeros
times 510-($-$$) db 0
dw 0xAA55  ; Boot signature
