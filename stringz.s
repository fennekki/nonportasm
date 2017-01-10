# Zero-terminated string handling

.global stringz_length
stringz_length:
    # Determine length of a zero-terminated string
    #
    # TODO would repnz help with this?
    #
    # Inputs:
    # 	%rdi - string memory address
    #
    # Outputs:
    # 	%rax - string length

    xorq %rax, %rax # Reset rax
    incq %rax # Increment rax (even in an empty string there's an initial 0)
    1: testb $0xFF, -1(%rdi, %rax) # Test string addr + rax - 1 against nonzero
    jnz 1b # If comparison wasn't zero, string isn't over
    retq # rax is now string length

.global copy_stringz
copy_stringz:
    # Copy a zero-terminated bytestring from one address to another
    #
    # Again: destination comes first!
    #
    # Inputs:
    #   %rdi - destination memory address
    #   %rsi - source memory address
    #
    # Dirties:
    # 	%rax
    #   %rcx

    pushq %rdi # Save rdi
    movq %rsi, %rdi # Copy source over
    callq stringz_length # Get length in rax
    movq %rax, %rcx # Setup rcx
    popq %rdi # Restore rdi

    pushfq # Push flags
    cld # Go forward
    rep movsb # Counter is already set up, just copy
    popfq # Return flags
    retq
