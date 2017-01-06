# Miscellaneous utility routines

.global exit
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

.global write
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
    syscall
    ret

