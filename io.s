# Input / output operations

.global write
write:
    # Calls the Linux sys_write syscall.
    #
    # Inputs:
    #   %rdi - file descriptor. 1 is stdout, 2 is stderr
    # 	%rsi - starting memory address of message buffer
    #   %rdx - message length
    #
    # Outputs:
    #   %rax - number of bytes written OR negative error code mathcing errno

    movq $1, %rax # Syscall number 1 - write
    syscall
    retq
