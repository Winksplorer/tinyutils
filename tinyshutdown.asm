section .text
global _start
global not_root
global version_arg

%macro _syscall 4
mov rax, %1
mov rdi, %2
mov rsi, %3
mov rdx, %4
syscall
%endmacro

; entry point
_start:
    ; Check for -v argument (version)
    mov rsi, [rsp]                                   ; argc
    mov rdi, [rsp+8]                                 ; argv
    cmp rsi, 2                                       ; check if there is an argv[1]
    je argv1_exists                                  ; if there is, then jump to argv1_exists. if not, program flow will continue.

    ; throw an error if the user is not root
    _syscall 0x66, 0, 0, 0                           ; getuid(2)
    cmp rax, 0                                       ; compare UID with root UID
    jne not_root                                     ; if we're not root, print a message and exit

    ; sync disks then shut down
    _syscall 1, 1, sync_msg, 17                      ; write(2) (syncing disks message)
    _syscall 0xa2, 0, 0, 0                           ; sync(2)
    _syscall 1, 1, shutdown_msg, 17                  ; write(2) (shutting down message)
    _syscall 0xa9, 0xfee1dead, 0x28121969, 0x4321fedc; reboot(2) (shutdown)
    _syscall 0x3c, 1, 0, 0                           ; exit(2) (if program is still executing (it should not be), then throw error)

; when the user isn't root
not_root:
    _syscall 1, 1, not_root_msg, 65                  ; write(2) (write the "you are not root" message to stdout)
    _syscall 0x3c, 1, 0, 0                           ; exit(2) (exit in error)

; when there is an argv[1], print version info. We don't really care if it's -v or not, just print the darn string because strcmp is too complex 😭
argv1_exists:
    _syscall 1, 1, version_str, 141                  ; write(2) (version string)
    _syscall 0x3c, 0, 0, 0                           ; exit(2) (it printed string, we good)

section .rodata
not_root_msg: db "tinyshutdown: error: shutdown can only be performed by root user", 0xa, 0
sync_msg: db "syncing disks...", 0xa, 0
shutdown_msg: db "shutting down...", 0xa, 0
version_str: db "tinyshutdown ", TINY_VER, 0xa, "This program is a part of tinyutils, a collection of linux utilities written in assembly.", 0xa, "Licensed under the Unlicense.", 0xa, 0 