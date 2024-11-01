[BITS 16]
[ORG 0x7C00]

KERNEL_ADDR equ 0x1000

start:
    mov [BOOT_DRIVE], dl
    mov bp, 0x9000
    mov sp, bp

    call load_kernel
    call enter_protected_mode
    jmp $

load_kernel:
    mov bx, KERNEL_ADDR
    mov dh, 9
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

disk_load:
    pusha
    mov ah, 0x02
    mov al, 9
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00

disk_load_loop:
    int 0x13
    jc disk_error
    add bx, 0x200
    dec dh
    jnz disk_load_loop
    popa
    ret

disk_error:
    jmp $

gdt_start:
    dq 0x0000000000000000
    dq 0x00cf9a000000ffff
    dq 0x00cf92000000ffff
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

enter_protected_mode:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 0x08:protected_mode_entry

[BITS 32]
protected_mode_entry:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    call KERNEL_ADDR
    jmp $

BOOT_DRIVE db 0
times 510 - ($ - $$) db 0
dw 0xAA55

