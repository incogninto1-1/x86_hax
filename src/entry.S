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

    ; --- Toggle LCD Reset (GPIO 47) ---
    mov ebx, 0xff119000
    
    ; Set Direction of Bank 1 (Bit 15) to Output
    mov eax, [ebx + 0x10]
    or eax, (1 << 15)
    mov [ebx + 0x10], eax

    ; Set Data of Bank 1 (Bit 15) to LOW (Reset active)
    mov eax, [ebx + 0x04]
    and eax, ~(1 << 15)
    mov [ebx + 0x04], eax
    
    ; Pause a bit (simple loop)
    mov ecx, 0xFFFF
.delay: loop .delay

    ; Set Data of Bank 1 (Bit 15) to HIGH (Release reset)
    or eax, (1 << 15)
    mov [ebx + 0x04], eax

    

.loop:
    ;hlt             ; Tell the CPU to sleep until the next event
    jmp .loop       ; If it wakes up, go back to sleep
