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
