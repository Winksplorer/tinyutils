section .text
global _start

_start:
    ; Check if there is 1 argument passed
    mov rsi, [rsp]                                   ; argc
    cmp rsi, 2                                       ; check if there is an argv[1]
    je spam_n                                        ; if there is, then jump to spam_n. if not, program flow will continue.

spam_y:
    mov rax, 1
    mov rdi, 1
    mov rsi, y_msg
    mov rdx, 2
    syscall
    jmp spam_y

spam_n:
    mov rax, 1
    mov rdi, 1
    mov rsi, n_msg
    mov rdx, 2
    syscall
    jmp spam_n

section .rodata
y_msg: db "y",0xa,0
n_msg: db "n",0xa,0