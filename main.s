.data
startup_msg: .string "nonportasm 0.1\nall fennecs pet\n"
startup_msg_len: .quad (. - startup_msg - 1) # this point - startup_msg

.text
.global _start # entry point

exit:
    # Calls the Linux sys_exit syscall, exiting program
    #
    # Inputs:
    #   %rdi - error code to return from program 
    #
    # Dirties:
    #   %rax - syscall number 60

    movq $60, %rax
    syscall

write:
    # Calls the Linux sys_write syscall
    #
    # Inputs:
    #   %rdi - file descriptor (usually 1 - stdout)
    #   %rsi - message buffer (address)
    #   %rdx - message length (quad)
    #
    # Dirties:
    #   %rax - syscall number 1
    movq $1, %rax # Syscall number 1 - write
    movq $1, %rdi # File descriptor 1 - stdout
    movq $startup_msg, %rsi # Message
    movq (startup_msg_len), %rdx # Get length
    syscall
    ret


_start:
    movq $1, %rdi # File descriptor 1 - stdout
    movq $startup_msg, %rsi # Message
    movq (startup_msg_len), %rdx # Get length
    call write

    movq $0, %rdi # Error 0
    jmp exit # call sys_exit
