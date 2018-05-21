# Zero-terminated string handling

.global stringz_length
stringz_length:
    # Determine length of a zero-terminated string
    #
    # Inputs:
    # 	%rdi - string memory address
    #
    # Dirties:
    # 	%rcx
    #
    # Outputs:
    # 	%rax - string length

    movq %rdi, %rax # Put pointer in rax
    xorq %rcx, %rcx # Clear rcx
1:
    movb (%rax), %cl # Copy byte to rcx low byte
    inc %rax # Move pointer
    cmpb $0, %cl # Test against zero
    jne 1b # Loop until done

    dec %rax # We'll do one extra increment otherwise
    subq %rdi, %rax # Difference between pointers is result
    retq

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

    pushq %rdi # Save rdi, rsi
    pushq %rsi
    movq %rsi, %rdi # Copy source over
    callq stringz_length # Get length in rax
    movq %rax, %rcx # Setup rcx
    popq %rsi # Restore
    popq %rdi

    pushfq # Push flags
    cld # Go forward
    rep movsb # Counter is already set up, just copy
    popfq # Return flags
    retq
