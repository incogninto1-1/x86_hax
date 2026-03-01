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

    ; --- TARGET ACQUIRED: sec_bootfb ---
    mov edi, 0x3f000000  
    
    ; The screen is 1280x800. At 4 bytes per pixel (ARGB8888), 
    ; that is 1,024,000 pixels = 4,096,000 bytes.
    ; We'll fill exactly that amount.
    mov ecx, 1024000      
    
    ; Let's use a bright "Nuclear Green" so there's no doubt.
    mov eax, 0xFF00FF00  
    
    rep stosd            ; Paint the town green

.loop:
    ;hlt             ; Tell the CPU to sleep until the next event
    jmp .loop       ; If it wakes up, go back to sleep
