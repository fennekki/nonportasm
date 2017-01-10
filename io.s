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

.global printz
printz:
    # Prints a zero-terminated string to stdout
    # 
    # Inputs:
    # 	%rdi - starting memory address of message buffer
    #
    # Dirties:
    # 	%rdi
    # 	%rsi
    # 	%rdx
    #
    # Outputs:
    # 	%rax - a literal 0 on success OR a literal -1 on error
    
    callq stringz_length # Get length in rax - rdi already has the address
    
    # Setup write syscall
    mov %rdi, %rsi # Buffer address
    mov %rax, %rdx # Length
    mov $1, %rdi # Stdout
    callq write
    retq
