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

.global copy_bytes
copy_bytes:
    # Copy bytes from one address to another
    #
    # NOTE: destination comes first! Mostly because putting "source" in the
    # "destination" register would require flipping rdi and rsi
    #
    # Inputs:
    #   %rdi - destination memory address
    #   %rsi - source memory address
    #   %rdx - bytes to copy
    #
    # Dirties:
    #   %rcx

    pushfq # Store processor flags
    cld # Clear direction flag - go forward
    mov %rdx, %rcx # Copy the third parameter to counter
    rep movsb # Copy
    popfq
    retq

.global copy_string
copy_string:
    # Copy a size-prefixed string from one address to another
    #
    # Destination first
    #
    # Inputs:
    #   %rdi - destination memory address
    #   %rsi - source memory address
    #
    # Dirties:
    #   %rcx

    movq (%rsi), %rcx # Copy length argument into counter
    pushfq # Setup flags
    cld
    rep movsb # Copy
    popfq
    retq
