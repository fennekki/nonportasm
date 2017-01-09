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

.global copy_stringz
copy_stringz:
    # Copy a zero terminated bytestring from one address to another
    #
    # Again: destination comes first!
    #
    # Inputs:
    #   %rdi - destination memory address
    #   %rsi - source memory address
    #
    # Dirties:
    #   %rcx

    xorq %rcx, %rcx # Reset counter
    1: cmpq $0, (%rsi, %rcx) # Test source + counter against 0
    incq %rcx # Increment counter (because we've found a byte to copy)
    jnz 1b # If comparison wasn't zero, string isn't over

    pushfq # Push flags
    cld # Go forward
    rep movsb # Counter is already set up, just copy
    popfq # Return flags
    retq
