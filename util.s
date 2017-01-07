# Miscellaneous utility routines.

.text
.global exit
exit:
    # Calls the Linux sys_exit syscall, exiting program.
    #
    # Inputs:
    #   %rdi - error code to return from program

    movq $60, %rax
    syscall

.global write
write:
    # Calls the Linux sys_write syscall.
    #
    # Inputs:
    #   %rdi - file descriptor (usually 1 - stdout)
    #   %rsi - message buffer (address)
    #   %rdx - message length (quad)
    #
    # Outputs:
    #   %rax - TODO what does it output

    movq $1, %rax # Syscall number 1 - write
    syscall
    retq

.global quad_to_hex
quad_to_hex:
    # Converts given quadword to hex.
    #
    # Inputs:
    #   %rdi - input quadword
    #
    # Outputs:
    #   %rax -
    # TODO THE WHOLE THING

    nop
    retq
