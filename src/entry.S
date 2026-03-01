[BITS 32]
section .text
global _start

; --- THE LINUX FAKE HEADER ---
jmp _start         ; Jump over the header
times 510-($-$$) db 0   ; Padding to offset 0x1FE
dw 0xAA55               ; Boot signature

; Offset 0x200 starts the real header
header_start:
    db 0                ; setup_sects
    dw 0                ; root_flags
    dd 0                ; syssize
    dw 0                ; ram_size
    dw 0                ; vid_mode
    dw 0                ; root_dev
    dw 0xAA55           ; boot_flag (again)
    
    ; AT OFFSET 0x202: The "HdrS" Magic
    db 'H', 'd', 'r', 'S' 
    dw 0x020d           ; Protocol version (2.13)
; -----------------------------

_start:
    cli             ; Disable interrupts
    cld             ; Clear direction flag

    ; --- Step 1: Clear the screen to Black ---
    mov edi, 0x3f000000  ; FB Address
    mov ecx, 1024000     ; 1280 * 800 pixels
    xor eax, eax         ; Black (0x00000000)
    rep stosd

    ; --- Step 2: Draw a 200x200 Red Square (Center-ish) ---
    ; Offset = (Row * Stride) + Column
    ; Let's start at Row 300, Col 540
    mov edi, 0x3f000000
    add edi, (300 * 1280 * 4) + (540 * 4)

    mov edx, 200         ; Height
.draw_row:
    mov ecx, 200         ; Width
    mov eax, 0xFFFF0000  ; Bright Red
    push edi             ; Save start of row
    rep stosd            ; Draw 200 red pixels
    pop edi              ; Restore start of row
    add edi, (1280 * 4)  ; Move to next line
    dec edx
    jnz .draw_row

.loop:
    ;hlt             ; Tell the CPU to sleep until the next event
    jmp .loop       ; If it wakes up, go back to sleep
