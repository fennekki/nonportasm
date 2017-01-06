.data
startup_msg: .string "nonportasm 0.1\nall fennecs pet\n"
startup_msg_len: .quad (. - startup_msg - 1) # this point - startup_msg

.text
.global _start # entry point
_start:
    movq $1, %rdi # File descriptor 1 - stdout
    movq $startup_msg, %rsi # Message
    movq (startup_msg_len), %rdx # Get length
    call write

    movq $0, %rdi # Error 0
    jmp exit # call sys_exit
