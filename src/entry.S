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
    
    ; --- 1. PAINT THE BUFFER ---
    mov edi, 0x3f000000  ; Our sec_bootfb
    mov ecx, 1024000     ; 1280 * 800
    mov eax, 0xFF00FF00  ; Nuclear Green
    rep stosd

    ; --- 2. THE TRIGGER (The Flip) ---
    ; We write the buffer address to the Display Surface Register
    ; This tells the hardware: "Refresh now from this location"
    mov ebx, 0xFF18019C  ; DSPASURF Register
    mov eax, 0x3f000000
    mov [ebx], eax

    ; --- 3. THE "KICK" (Display Control) ---
    ; Enable Display A and Plane A (just in case they were stalled)
    mov ebx, 0xFF180180  ; DSPACNTR Register
    mov eax, [ebx]
    or eax, 0x80000000   ; Set Bit 31 (Display Enable)
    mov [ebx], eax

.loop:
    ;hlt             ; Tell the CPU to sleep until the next event
    jmp .loop       ; If it wakes up, go back to sleep
