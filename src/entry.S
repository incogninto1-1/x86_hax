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

    ; --- 1. PAINT OUR BUFFER GREEN ---
    mov edi, 0x3f000000
    mov ecx, 1024000
    mov eax, 0xFF00FF00
    rep stosd

    ; --- 2. HIJACK THE GTT ---
    ; Based on GMA500 specs, the GTT table is often at 0x40000 (PCI offset)
    ; or mapped at the start of the MMIO range.
    ; Let's try to find the GTT at the 'pvrsrvkm' address you found: dff00000
    mov edi, 0xdff00000
    mov ecx, 2048        ; Fill 2048 entries
    mov eax, 0x3f000001  ; Point entry to 0x3f000000 (Bit 0 is 'Present')
    
.fill_gtt:
    mov [edi], eax
    add eax, 4096       ; Point to next physical page
    add edi, 4          ; Next GTT entry
    loop .fill_gtt



.loop:
    ;hlt             ; Tell the CPU to sleep until the next event
    jmp .loop       ; If it wakes up, go back to sleep
